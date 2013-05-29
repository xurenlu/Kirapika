//
//  ViewController.m
//  Kirapika
//
//  Created by Justin Jia on 1/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.view.pixelStyleHandwritingRecognitionViewDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
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
        self.view.guideView.label.text = NSLocalizedString(@"release to chat", nil);
    } else if (mark == LetterM) {
        self.view.guideView.label.text = NSLocalizedString(@"release to set up the app", nil);
    } else if (mark == LetterR) {
        self.view.guideView.label.text = NSLocalizedString(@"release to go back in time", nil);
    } else if (mark == LetterS) {
        self.view.guideView.label.text = NSLocalizedString(@"release to view messages", nil);
    }
}

- (void)finalRecognizedMark:(RecognizedMarkType)mark
{
    if (mark == LetterC) {
        [self performSegueWithIdentifier:@"chatSegue" sender:self];
    } else if (mark == LetterM) {
        [self performSegueWithIdentifier:@"moeSegue" sender:self];
    } else if (mark == LetterR) {
        [self performSegueWithIdentifier:@"recallSegue" sender:self];
    } else if (mark == LetterS) {
        [self performSegueWithIdentifier:@"soloSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [UIView animateWithDuration:0.35 animations:^{
        self.view.guideView.alpha = 0;
        self.view.alpha = 0;
        
        CGRect frame = self.view.window.frame;
        float dis = self.view.window.bounds.size.height;
        
        frame.origin.y += 20;
        frame.size.height -= 20;
        
        frame.origin.x += dis / 20;
        frame.size.width -= dis / 20 * 2;
        frame.origin.y += dis / 20;
        frame.size.height -= dis / 20 * 2;
        
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        self.view.alpha = 1;
        self.view.frame = self.view.window.frame;
    }];
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
