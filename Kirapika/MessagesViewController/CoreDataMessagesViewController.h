//
//  CoreDataMessagesViewController.h
//  kirakira pikapika
//
//  Created by Justin Jia on 4/7/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "MessagesViewController.h"
#import "CoreDataConstants.h"

@interface CoreDataMessagesViewController : MessagesViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)documentIsReady;

- (void)presentNotificationWithMessages:(NSArray *)replys;
- (void)presentNotificationWithMessage:(Message *)message;

- (void)replyRecievedWithMessages:(NSArray *)replys;
- (BubbleMessageData *)createMessageFromMessage:(Message *)message;
- (BubbleMessageStyle)bubbleCurrentSender:(Sender *)sender;

@end
