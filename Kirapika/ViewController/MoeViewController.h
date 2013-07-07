//
//  MoeViewController.h
//  Kirapika
//
//  Created by Justin Jia on 1/19/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ViewController.h"

#define OPEN_URL_NOTIFICATION @"openURLNotification"

@interface MoeViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *status;
- (IBAction)clearButtonTapped:(id)sender;
- (void)openURL:(NSNotification *)aNotification;

@end
