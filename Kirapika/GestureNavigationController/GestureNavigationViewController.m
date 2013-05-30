//
//  GestureNavigationViewController.m
//  Kirapika
//
//  Created by Justin Jia on 5/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "GestureNavigationViewController.h"

@interface GestureNavigationViewController ()

@property (nonatomic, strong) UIImageView *backgroundView;

@end

@implementation GestureNavigationViewController

- (void)touchBegan:(UIWindow *)window
{
    [window addSubview:self.backgroundView];
    [window sendSubviewToBack:self.backgroundView];
    [self.view.findFirstResponder resignFirstResponder];
}

- (void)setBackgroundViewWith:(float)distanceToBottom
{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    
    frame.origin.x += distanceToBottom / 20;
    frame.size.width -= distanceToBottom / 20 * 2;
    frame.origin.y += distanceToBottom / 20;
    frame.size.height -= distanceToBottom / 20 * 2;
    
    self.backgroundView.frame = frame;
    self.backgroundView.alpha = 1 - (distanceToBottom / frame.size.height);
}

- (void)moveView:(float)distance
{
    CGRect v = self.view.frame;
    v.origin.y += distance;
    self.view.frame = v;
}

- (void)touchSucceed
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect v = self.view.frame;
        v.origin.y = [UIScreen mainScreen].applicationFrame.size.height;
        self.view.frame = v;
        [self setBackgroundViewWith:0];
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self setBackgroundView:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)touchFailed
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect v = self.view.frame;
        v.origin.y = 0;
        self.view.frame = v;
        [self setBackgroundViewWith:[UIScreen mainScreen].applicationFrame.size.height];
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self setBackgroundView:nil];
    }];
}

#pragma mark - Data
- (UIImageView *)backgroundView
{
    if (!_backgroundView) _backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home screen.png"]];
    return _backgroundView;
}

#pragma mark - View Rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Unload
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setBackgroundView:nil];
}

@end
