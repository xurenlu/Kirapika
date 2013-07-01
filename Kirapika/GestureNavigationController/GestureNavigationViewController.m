//
//  GestureNavigationViewController.m
//  Kirapika
//
//  Created by Justin Jia on 5/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "GestureNavigationViewController.h"

@interface GestureNavigationViewController ()

@end

@implementation GestureNavigationViewController

- (void)touchBegan:(UIWindow *)window
{
    [self.view.findFirstResponder resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)moveView:(float)distance
//{
//    CGRect v = self.view.frame;
//    v.origin.y += distance;
//    self.view.frame = v;
//}
//
//- (void)touchSucceed
//{
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CGRect v = self.view.frame;
//        v.origin.y = [UIScreen mainScreen].applicationFrame.size.height;
//        self.view.frame = v;
//    } completion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//}
//
//- (void)touchFailed
//{
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CGRect v = self.view.frame;
//        v.origin.y = 0;
//        self.view.frame = v;
//    } completion:^(BOOL finished) {
//    }];
//}

#pragma mark - View Rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
