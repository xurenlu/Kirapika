//
//  ChatViewController.h
//  kirakira pikapika
//
//  Created by Justin Jia on 1/19/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataMessagesViewController.h"
#import "ToggleView.h"

@interface ChatViewController : CoreDataMessagesViewController <ToggleViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *titleView;

@end