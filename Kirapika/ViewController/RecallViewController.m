//
//  RecallViewController.m
//  Kirapika
//
//  Created by Justin Jia on 4/7/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "RecallViewController.h"

@interface RecallViewController ()

@end

@implementation RecallViewController

- (void)documentIsReady
{
    if (!self.messagesCount) [self messagesAddObject:[self createMessageFromText:@"haven't compeleted yet" andSender:self.currentSender]];
}

@end
