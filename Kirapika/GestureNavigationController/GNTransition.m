//
//  GNTransitionController.m
//  Kirapika
//
//  Created by Justin Jia on 6/17/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "GNTransition.h"

@implementation GNTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *inView = [transitionContext containerView];

    CGRect toViewFinalFrame = inView.frame;
    
    CGRect toViewInitFrame = inView.frame;
    toViewInitFrame.origin.y += inView.bounds.size.height;
    
    [inView addSubview:toView];
    
    CGRect fromViewInitFrame = inView.frame;
    
    CGRect fromViewFinalFrame = inView.frame;
    float dis = fromViewFinalFrame.size.height;
    fromViewFinalFrame.origin.x += dis / 20;
    fromViewFinalFrame.size.width -= dis / 20 * 2;
    fromViewFinalFrame.origin.y += dis / 20;
    fromViewFinalFrame.size.height -= dis / 20 * 2;
    
    if (!self.isPresented) {
        toView.frame = toViewInitFrame;
        fromView.frame = fromViewInitFrame;
        [inView bringSubviewToFront:toView];
    } else {
        fromView.frame = toViewFinalFrame;
        toView.frame = fromViewFinalFrame;
        [inView bringSubviewToFront:fromView];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (!self.isPresented) {
            toView.frame = toViewFinalFrame;
            fromView.frame = fromViewFinalFrame;
        } else {
            fromView.frame = toViewInitFrame;
            toView.frame = fromViewInitFrame;
        }

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
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