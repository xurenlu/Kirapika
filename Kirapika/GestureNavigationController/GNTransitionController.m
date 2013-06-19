//
//  GNTransitionController.m
//  Kirapika
//
//  Created by Justin Jia on 6/17/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "GNTransitionController.h"

@implementation GNTransitionController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    //    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    //    UIView *inView = [transitionContext containerView];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    float dis = frame.size.height;
    
    frame.origin.x += dis / 20;
    frame.size.width -= dis / 20 * 2;
    frame.origin.y += dis / 20;
    frame.size.height -= dis / 20 * 2;
    
    [UIView animateWithDuration:0.35f animations:^{
        fromView.frame = frame;
        fromView.alpha = 0;
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

@end