//
//  MessagesViewController.h
//  Kirapika
//
//  Created by Justin Jia on 3/29/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "UserDefaultsKeys.h"
#import "MessagesNavigationViewController.h"
#import "MessagesTableView.h"
#import "MessageInputView.h"
#import "MessageSoundEffect.h"
#import "BubbleMessageCell.h"
#import "BubbleTypingCell.h"

@interface MessagesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, HPGrowingTextViewDelegate, MessagesNavigationViewControllerDelegate>

#pragma mark - TableView and InputView
@property (weak, nonatomic) IBOutlet MessagesTableView *tableView;
@property (weak, nonatomic) IBOutlet MessageInputView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightConstraint;

#pragma mark - Data
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (nonatomic) BOOL isReplying;

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
- (void)sendPressed:(UIButton *)sender;
- (void)replyRecievedWithText:(NSString *)text;

- (void)clearAllMessages;
- (void)clearAllNotificaitons;
- (void)presentNotificationWithText:(NSString *)text;

- (void)setEditingEnabled:(BOOL)enabled;
- (void)setEditingEnabledInterval:(BOOL)enabled;
- (void)setViewingModeEnabled:(BOOL)enabled;

#pragma mark - Messages View Controller
- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setBackgroundColor:(UIColor *)color;

#pragma mark - Data
- (int)messagesCount;
- (void)setMessages:(NSMutableArray *)messages;
- (void)messagesAddObject:(id)object;
- (void)messagesAddObjectFromArray:(NSArray *)array;
- (void)messagesRemoveAllObjects;
- (BubbleMessageData *)createMessageFromText:(NSString *)text andSender:(BubbleMessageStyle)sender;
- (BubbleMessageStyle)currentSender;
- (void)setCurrentSender:(BubbleMessageStyle)currentSender;

@end
