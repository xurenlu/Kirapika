//
//  ViewController.m
//  Kirapika
//
//  Created by Justin Jia on 1/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ViewController.h"
#import "GNTransition.h"

@interface ViewController ()

@property (nonatomic, strong) GNTransition *gnTransition;

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.view.pixelStyleHandwritingRecognitionViewDelegate = self;
    self.transitioningDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)recognizedMark:(RecognizedMarkType)mark
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.guideView.alpha = 1.0f;
    }];
    
    if (mark == LetterC) {
        self.view.guideView.label.text = NSLocalizedString(@"release to chat", @"main view hint");
    } else if (mark == LetterM) {
        self.view.guideView.label.text = NSLocalizedString(@"release to set up the app", @"main view hint");
    } else if (mark == LetterR) {
        self.view.guideView.label.text = NSLocalizedString(@"release to go back in time", @"main view hint");
    } else if (mark == LetterS) {
        self.view.guideView.label.text = NSLocalizedString(@"release to view messages", @"main view hint");
    }
}

- (void)finalRecognizedMark:(RecognizedMarkType)mark
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.guideView.alpha = 0;
    }];

    UIViewController *controller;
    if (mark == LetterC) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatNavigationController"];
    } else if (mark == LetterM) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MoeNavigationController"];
    } else if (mark == LetterR) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RecallNavigationController"];
    } else if (mark == LetterS) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SoloNavigationController"];
    }
    
    [controller setTransitioningDelegate:self];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    GNTransition *trans = [GNTransition new];
    trans.isPresented = NO;
    return trans;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    GNTransition *trans = [GNTransition new];
    trans.isPresented = YES;
    return trans;
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

@end
