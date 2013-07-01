//
//  PixelStyleHandwritingRecognitionView.m
//  Kirapika
//
//  Created by Justin Jia on 1/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "PixelStyleHandwritingRecognitionView.h"
#import "PixelView.h"

#define HEIGHT_VIEW 8
#define WIDTH_VIEW 8
#define LINE 1
#define TOP_MOVE 3
#define LEFT_MOVE 1
@interface PixelStyleHandwritingRecognitionView()

@property (nonatomic, strong) NSNumber *stateLightViewCount;
@property (nonatomic) BOOL wait;
- (void)setup;
- (CGPoint)centerOfPixelWithTag:(int)tag;
- (int)TagOfPixelViewContainsCGPoint:(CGPoint)point;
- (void)shadeWithCenter:(int)tag;

@end

/*
    Cartesian coordinate system
    (1,1) (2,1) ...
    (1,2) (2,2) ...
    ...
*/

@implementation PixelStyleHandwritingRecognitionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    [self setImage:[UIImage imageNamed:@"home screen.png"]];
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:NO];
    [self setAutoresizingMask:UIViewAutoresizingNone];
    for (int i=0; i<(int)self.bounds.size.height / HEIGHT_VIEW * (int)(self.bounds.size.width / WIDTH_VIEW); i++) {
        PixelView *pixel = [PixelView new];
        [pixel setBounds:CGRectMake(0, 0, WIDTH_VIEW - LINE, HEIGHT_VIEW - LINE)];
        [pixel setTag:i];
        [pixel setCenter:[self centerOfPixelWithTag:i]];
        [self addSubview:pixel];
    }
    
    int width = 230;
    int height = 33;
    self.guideView = [[GuideView alloc]initWithFrame:CGRectMake((self.bounds.size.width-width)/2, self.bounds.size.height-40-height, width, height)];
    [self addSubview:self.guideView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.wait = YES;
    UITouch *touch = [touches anyObject];
    int tag =[self TagOfPixelViewContainsCGPoint:[touch locationInView:self]];
    [self shadeWithCenter:tag];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    [self shadeWithCenter:[self TagOfPixelViewContainsCGPoint:[touch locationInView:self]]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    int tag =[self TagOfPixelViewContainsCGPoint:[touch locationInView:self]];
    [self shadeWithCenter:tag];
    
    self.wait = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        if (!self.wait) {
            self.wait = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                for (PixelView *pixelView in self.subviews) [pixelView isNormal];
                [self.pixelStyleHandwritingRecognitionViewDelegate finalRecognizedMark:self.stateLightViewCount.mark];
            });
        }
    });
}

- (CGPoint)centerOfPixelWithTag:(int)tag
{
    double x = (tag % (int)(self.bounds.size.width / WIDTH_VIEW)) * WIDTH_VIEW + WIDTH_VIEW / 2 - LINE + LEFT_MOVE;
    double y = ((int)tag / (int)(self.bounds.size.width / WIDTH_VIEW)) * HEIGHT_VIEW + HEIGHT_VIEW / 2 - LINE + TOP_MOVE;
    return CGPointMake(x, y);
}

- (int)TagOfPixelViewContainsCGPoint:(CGPoint)point
{
    for (int tag=0; tag<(int)self.bounds.size.height / HEIGHT_VIEW * (int)(self.bounds.size.width / WIDTH_VIEW); tag++) {
        double x = ((int)tag % (int)(self.bounds.size.width / WIDTH_VIEW)) * WIDTH_VIEW + LEFT_MOVE;
        double y = ((int)tag / (int)(self.bounds.size.width / WIDTH_VIEW)) * HEIGHT_VIEW + TOP_MOVE;
        CGRect rect = CGRectMake(x, y, WIDTH_VIEW, HEIGHT_VIEW);
        if (CGRectContainsPoint(rect, point)) {
            for (PixelView *pixelView in self.subviews) {
                if (pixelView.tag == tag) return pixelView.tag;
            }
        }
    }
    return -1;
}

- (void)shadeWithCenter:(int)tag
{
    self.stateLightViewCount = @0;
    
    for (PixelView *pixelView in self.subviews) {
        BOOL mostLeft = !((tag - 0) % (int)(self.bounds.size.width / WIDTH_VIEW));
        BOOL mostRight = !((tag + 1) % (int)(self.bounds.size.width / WIDTH_VIEW));
        BOOL secondLeft = !((tag - 1) % (int)(self.bounds.size.width / WIDTH_VIEW));
        BOOL secondRight = !((tag + 2) % (int)(self.bounds.size.width / WIDTH_VIEW));
        int nextRow = (int)(self.bounds.size.width / WIDTH_VIEW);
        if (pixelView.tag == tag) {
            [pixelView isCenter];
        } else if (pixelView.tag == tag - 1 && !mostLeft) {
            [pixelView isShadeWithLevel:PixelShadeStateDark];
        } else if (pixelView.tag == tag + 1 && !mostRight) {
            [pixelView isShadeWithLevel:PixelShadeStateDark];
        } else if (pixelView.tag == tag + nextRow) {
            [pixelView isShadeWithLevel:PixelShadeStateDark];
        } else if (pixelView.tag == tag - nextRow) {
            [pixelView isShadeWithLevel:PixelShadeStateDark];
        } else if (pixelView.tag == tag + nextRow + 1 && !mostRight) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        } else if (pixelView.tag == tag - nextRow + 1 && !mostRight) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        } else if (pixelView.tag == tag + nextRow - 1 && !mostLeft) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        } else if (pixelView.tag == tag - nextRow- 1 && !mostLeft) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        } else if (pixelView.tag == tag - 2 && !mostLeft && !secondLeft) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        } else if (pixelView.tag == tag + 2 && !mostRight && !secondRight) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        } else if (pixelView.tag == tag + 2 * nextRow) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        } else if (pixelView.tag == tag - 2 * nextRow) {
            [pixelView isShadeWithLevel:PixelShadeStateLight];
        }
        
        if (pixelView.state == PixelShadeStateCenter) {
            self.stateLightViewCount = @(self.stateLightViewCount.intValue + 1);
        }
    }
    
    [self.pixelStyleHandwritingRecognitionViewDelegate recognizedMark:self.stateLightViewCount.mark];
}

- (NSArray *)subviews
{
    NSMutableArray *subviews = [NSMutableArray new];
    for (UIView *view in [super subviews]) {
        if (view.tag != -1) [subviews addObject:view];
    }
    return subviews;
}

@end
