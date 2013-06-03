//
//  CoreDataMessagesViewController.m
//  Kirapika
//
//  Created by Justin Jia on 4/7/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "CoreDataMessagesViewController.h"
#import "FilesManagement.h"

@interface CoreDataMessagesViewController ()

@property (nonatomic ,strong) UIManagedDocument *document;
@property (nonatomic) BOOL finishedLoadingContext;
- (void)documentIsOpened;

@end

@implementation CoreDataMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDocument];
}

- (void)loadDocument
{
    [self setEditingEnabled:NO];
    [self setIsReplying:YES];

    NSString *path = [self.userDefaults objectForKey:CURRENT_DATABASE_NAME];
    if (path) {
        NSURL *url = [[NSURL fileURLWithPath:[[FilesManagement documentDirectory] path]] URLByAppendingPathComponent:path];
        self.document = [[UIManagedDocument alloc]initWithFileURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            [self.document openWithCompletionHandler:^(BOOL success){
                [self documentIsOpened];
            }];
        } else {
            [self replyRecievedWithText:NSLocalizedString(@"Sorry, I think there is something wrong with the document.", @"error message")];
        }
    } else {
        [self replyRecievedWithText:NSLocalizedString(@"Sorry, I think the document is not existed.", @"error message")];
    }
}

- (void)documentIsOpened
{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.managedObjectContext = self.document.managedObjectContext;
        [self.managedObjectContext performBlock:^{
            [self documentIsReady];
        }];
    } else {
        [self replyRecievedWithText:NSLocalizedString(@"Sorry, I think there is something wrong with the document. Please try again.", @"error message")];
    }
}

- (void)documentIsReady
{
    [self setEditingEnabled:YES];
}

- (void)presentNotificationWithMessage:(Message *)message
{
    [self presentNotificationWithText:message.context];
}

- (void)presentNotificationWithMessages:(NSArray *)replys
{
    for (Message *message in replys) [self presentNotificationWithMessage:message];
}

- (void)replyRecievedWithMessage:(Message *)reply
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reply) {
            [self messagesAddObject:[self createMessageFromMessage:reply]];
            [MessageSoundEffect playMessageReceivedSound];
        }
        [self setIsReplying:NO];
    });
}

- (void)replyRecievedWithMessages:(NSArray *)replys
{
    for (Message *reply in replys) [self replyRecievedWithMessage:reply];
}

- (BubbleMessageData *)createMessageFromMessage:(Message *)message
{
    BubbleMessageData *bubbleMessageData = [BubbleMessageData new];
    bubbleMessageData.bubbleDate = message.date;
    bubbleMessageData.bubbleCurrentSender = [self bubbleCurrentSender:message.whoSent];
    bubbleMessageData.bubbleContext = message.context;
    return bubbleMessageData;
}

- (BubbleMessageStyle)bubbleCurrentSender:(Sender *)sender
{
    return (BubbleMessageStyle)sender.isLeftUser.intValue;
}

- (UIBackgroundTaskIdentifier)startBackgroundTask
{
    return [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)bgTask
{
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}

@end
