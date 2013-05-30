//
//  MessagesNavigationViewController.m
//  Kirapika
//
//  Created by Justin Jia on 5/5/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "MessagesNavigationViewController.h"

@interface MessagesNavigationViewController ()

- (void)setup;

@end

@implementation MessagesNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self.topViewController action:@selector(leftBarButtonItemTapped)];
    [self.topViewController.navigationItem setLeftBarButtonItem:clearButton animated:YES];
}

#pragma mark - View Rotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
