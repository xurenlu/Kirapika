//
//  CoreDataMessagesViewController.h
//  Kirapika
//
//  Created by Justin Jia on 4/7/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "MessagesViewController.h"
#import "CoreDataConstants.h"

@interface CoreDataMessagesViewController : MessagesViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)documentIsReady;

- (void)presentNotificationWithMessage:(Message *)message;
- (void)presentNotificationWithMessages:(NSArray *)replys;

- (void)replyRecievedWithMessage:(Message *)reply;
- (void)replyRecievedWithMessages:(NSArray *)replys;
- (BubbleMessageData *)createMessageFromMessage:(Message *)message;
- (BubbleMessageStyle)bubbleCurrentSender:(Sender *)sender;

- (UIBackgroundTaskIdentifier)startBackgroundTask;
- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)bgTask;

@end
