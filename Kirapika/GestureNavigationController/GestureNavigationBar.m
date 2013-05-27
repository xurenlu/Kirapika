//
//  GestureNavigationBar.m
//  Kirapika
//
//  Created by Justin Jia on 5/6/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "GestureNavigationBar.h"

@interface GestureNavigationBar()

- (void)setup;

@end

@implementation GestureNavigationBar

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
    self.multipleTouchEnabled = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch = touches.anyObject;
    UIWindow *window = touch.window;
    
    [self.delegate touchBegan:window];
    
    CGPoint loaction = [touch locationInView:window];
    float distance = window.bounds.size.height - loaction.y;
    [self.delegate setBackgroundView:window with:distance];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    UIWindow *window = touch.window;

    CGPoint loaction = [touch locationInView:window];
    CGPoint oldLocation = [touch previousLocationInView:window];
    
    float distance = window.bounds.size.height - loaction.y;
        
    [self.delegate setBackgroundView:window with:distance];
    [self.delegate moveView:loaction.y - oldLocation.y];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    [self.delegate touchFailed:touch.window];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    UIWindow *window = touch.window;

    CGPoint location = [touch locationInView:window];
    CGPoint oldLocation = [touch previousLocationInView:window];
    (location.y > oldLocation.y) ? [self.delegate touchSucceed:window] : [self.delegate touchFailed:window];
}

@end
