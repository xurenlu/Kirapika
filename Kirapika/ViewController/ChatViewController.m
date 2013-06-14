//
//  ChatViewController.m
//  Kirapika
//
//  Created by Justin Jia on 1/19/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ChatViewController.h"
#import "ReplyText.h"

@interface ChatViewController ()

@property (nonatomic, strong) ReplyText *replyText;
@property (nonatomic) UIBackgroundTaskIdentifier replyingMessagesTask;
- (void)replyWithText:(NSString *)text;
- (NSString *)checkSpecialCommandWithText:(NSString *)text;
- (ToggleButtonSelected)toggleButtonSelected;
- (ReplyTextSender)replyTextSender;

@end

@implementation ChatViewController

#pragma mark - Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.senderSwitch.toggleView.toggleDelegate = self;
}

- (void)documentIsReady
{
    self.messagesCount ? [self setIsReplying:NO] : [self replyRecievedWithMessage:[self.replyText replyAnyObjectWithSender:!self.currentSender]];

    [super documentIsReady];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self setEditingEnabled:NO];
    [super sendPressed:sender withText:text];
    [self replyWithText:text];
}

- (void)replyWithText:(NSString *)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.replyingMessagesTask = [self startBackgroundTask];

        [self setIsReplying:YES];

        NSString *check = [self checkSpecialCommandWithText:text];
        NSArray *replys = !check ? [self.replyText replysWithText:text andSender:self.replyTextSender] : nil;
        
        [self presentNotificationWithText:check];
        [self presentNotificationWithMessages:replys];
        
        [self replyRecievedWithText:check];
        [self replyRecievedWithMessages:replys];

        [self setEditingEnabled:YES];
        
        [self endBackgroundTask:self.replyingMessagesTask];
    });
}

- (NSString *)checkSpecialCommandWithText:(NSString *)text
{
    if (text.length > 11) {
        if ([[text substringToIndex:11] isEqualToString:@"SetLimitTo:"]) {
            long int number = [[text substringFromIndex:11] intValue];
            if (number > 0) {
                [self.replyText loadWithManagedObjectContext:self.managedObjectContext andLimit:number];
                [self.userDefaults setInteger:number forKey:DATA_LIMIT_NUMBER_KEY];
                return [NSString stringWithFormat:@"%@%ld", NSLocalizedString(@"have set limitation to:", @"special command return value"), number];
            } else {
                return NSLocalizedString(@"limitation cannot be 0.", @"special command return value");
            }
        } else if ([text isEqualToString:@"SetNormalReply"]) {
            self.replyText.replyTextPreference = NormalReply;
            return NSLocalizedString(@"Succeed.", @"special command return value");
        } else if ([text isEqualToString:@"SetSingleReply"]) {
            self.replyText.replyTextPreference = SingleReply;
            return NSLocalizedString(@"Succeed.", @"special command return value");
        } else if ([text isEqualToString:@"SetAllPossibleReply"]) {
            self.replyText.replyTextPreference = AllPossibleReply;
            return NSLocalizedString(@"Succeed.", @"special command return value");
        }
    }
    return nil;
}

#pragma mark - Toggle View Delegate
- (void)selectLeftButton
{
    self.currentSender = BubbleMessageStyleLeftSender;
}

- (void)selectRightButton
{
    self.currentSender = BubbleMessageStyleRightSender;
}

#pragma mark - Data
- (ReplyText *)replyText
{
    if (_replyText == nil) {
        _replyText = [ReplyText new];
        _replyText.replyTextPreference = NormalReply;
        int limit = [self.userDefaults integerForKey:DATA_LIMIT_NUMBER_KEY];
        [_replyText loadWithManagedObjectContext:self.managedObjectContext andLimit:limit ? limit : DATA_LIMIT_NUMBER_DEFAULT];
    }
    return _replyText;
}

- (ToggleButtonSelected)toggleButtonSelected
{
    return (ToggleButtonSelected)self.currentSender;
}

- (ReplyTextSender)replyTextSender
{
    return (ReplyTextSender)self.currentSender;
}

#pragma mark - Unload
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endBackgroundTask:self.replyingMessagesTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self endBackgroundTask:self.replyingMessagesTask];
    _replyText = nil;
}

@end
