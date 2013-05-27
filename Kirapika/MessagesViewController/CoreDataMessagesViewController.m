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

    NSString *path = [self.userDefaults objectForKey:CURRENT_DATABASE_PATH];
    if (path) {
        NSURL *url = [[NSURL fileURLWithPath:[[FilesManagement documentDirectory] path]] URLByAppendingPathComponent:path];
        self.document = [[UIManagedDocument alloc]initWithFileURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            [self.document openWithCompletionHandler:^(BOOL success){
                if (success) [self documentIsOpened];
                if (!success) NSLog(@"Couldn't open document at %@", url);
            }];
        } else {
            NSLog(@"Document is not existed at %@.", url);
        }
    } else {
        NSLog(@"Database is not in use!");
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
        NSLog(@"Document is not ready!");
    }
}

- (void)documentIsReady
{
    [self setEditingEnabled:YES];
}

- (void)presentNotificationWithMessages:(NSArray *)replys
{
    for (Message *message in replys) [self presentNotificationWithMessage:message];
}

- (void)presentNotificationWithMessage:(Message *)message
{
    [self presentNotificationWithText:message.context];
}

- (void)replyRecievedWithMessages:(NSArray *)replys
{
    for (Message *message in replys) {
        [self messagesAddObject:[self createMessageFromMessage:message]];
        [self presentNotificationWithMessage:message];
    }
    [MessageSoundEffect playMessageReceivedSound];
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

@end
