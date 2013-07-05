//
//  MessagesViewController.m
//  Kirapika
//
//  Created by Justin Jia on 3/29/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "MessagesViewController.h"
#import "NSString+MessagesView.h"
#import "DAKeyboardControl.h"

@interface MessagesViewController ()

@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation MessagesViewController

@synthesize messages = _messages;

#pragma mark - Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBackgroundColor:[UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.inputView.textView.delegate = self;
    [self.inputView.sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    __block MessagesViewController *blockSafeSelf = self;
    self.view.keyboardTriggerOffset = self.inputView.bounds.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        CGRect toolBarFrame = blockSafeSelf.inputView.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        blockSafeSelf.inputView.frame = toolBarFrame;
        
        UIEdgeInsets tableViewInsets = blockSafeSelf.tableView.contentInset;
        tableViewInsets.bottom = blockSafeSelf.tableView.bounds.size.height - toolBarFrame.origin.y;
        blockSafeSelf.tableView.contentInset = tableViewInsets;
    }];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setViewingModeEnabled:(toInterfaceOrientation == UIInterfaceOrientationPortrait) ? NO : YES];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self messagesAddObject:[self createMessageFromText:text andSender:self.currentSender]];
    [self.inputView.textView setText:nil];
    [self growingTextViewDidChange:self.inputView.textView];
    [MessageSoundEffect playMessageSentSound];
}

- (void)sendPressed:(UIButton *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{ [self sendPressed:sender withText:[self.inputView.textView.text trimWhitespace]]; });
}

- (void)replyRecievedWithText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (text) {
            [self messagesAddObject:[self createMessageFromText:text andSender:!self.currentSender]];
            [MessageSoundEffect playMessageReceivedSound];
        }
        [self setIsReplying:NO];
    });
}

- (void)clearAllMessages
{
    [self messagesRemoveAllObjects];
}

- (void)clearAllNotificaitons
{
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationIconBadgeNumber) {
        [application setApplicationIconBadgeNumber:0];
        [application cancelAllLocalNotifications];
    }
}

- (void)presentNotificationWithText:(NSString *)text
{
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = text;
    localNotification.applicationIconBadgeNumber += 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)setEditingEnabled:(BOOL)enabled
{
    dispatch_async(dispatch_get_main_queue(), ^{ [self setEditingEnabledInterval:enabled]; });
}

- (void)setEditingEnabledInterval:(BOOL)enabled
{
    [self.inputView.textView resignFirstResponder];
    [self.inputView setUserInteractionEnabled:enabled];
}

- (void)setViewingModeEnabled:(BOOL)enabled
{
    [[UIApplication sharedApplication] setStatusBarHidden:enabled];
    [self.navigationController setNavigationBarHidden:enabled animated:YES];
    [self.inputViewHeightConstraint setConstant:enabled ? 0 : 40];
    [self.inputView setHidden:enabled];
    [self.tableView setShowsVerticalScrollIndicator:enabled];
    [self.view.findFirstResponder resignFirstResponder];
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesCount + self.isReplying;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.messagesCount) {
        BubbleMessageStyle style = !self.currentSender;
        
        NSString *cellID = @"TypingCell";
        BubbleTypingCell *cell = (BubbleTypingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) cell = [[BubbleTypingCell alloc] initWithBubbleStyle:style reuseIdentifier:cellID];
        
        [cell setStyle:style];
        
        return cell;
    } else {
        BubbleMessageStyle style = [self messageStyleForRowAtIndexPath:indexPath];
        
        NSString *CellID = [NSString stringWithFormat:@"MessageCell%d", style];
        BubbleMessageCell *cell = (BubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
        
        if(!cell) cell = [[BubbleMessageCell alloc] initWithBubbleStyle:style reuseIdentifier:CellID];
        
        cell.bubbleView.text = [self textForRowAtIndexPath:indexPath];
        cell.backgroundColor = tableView.backgroundColor;
        cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        return cell;
    }
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.messagesCount) return [BubbleTypingCell height];
    return [BubbleView cellHeightForText:[self textForRowAtIndexPath:indexPath]];
}

#pragma mark - Messages Navigation View Controller Delegate
- (void)leftBarButtonItemTapped
{
    [self clearAllMessages];
}

#pragma mark - HP Growing Textview Delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.inputView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.inputView.frame = r;
    
    UIEdgeInsets tableViewInsets = self.tableView.contentInset;
    tableViewInsets.bottom -= diff;
    self.tableView.contentInset = tableViewInsets;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    self.inputView.sendButton.enabled = ([growingTextView.text trimWhitespace].length > 0);
}

#pragma mark - Messages View Controller
- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(self.messages)[indexPath.row] bubbleCurrentSender];
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(self.messages)[indexPath.row] bubbleContext];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

#pragma mark - Data
- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) _userDefaults = [NSUserDefaults standardUserDefaults];
    return _userDefaults;
}

- (NSMutableArray *)messages
{
    if (!_messages) _messages = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.userDefaults objectForKey:MESSAGES_ARRAY_KEY]] mutableCopy];
    if (!_messages.count) _messages = [NSMutableArray new];
    [self clearAllNotificaitons];
    return _messages;
}

- (int)messagesCount
{
    return self.messages.count;
}

- (void)setMessages:(NSMutableArray *)messages
{
    _messages = messages;
    [self.userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_messages] forKey:MESSAGES_ARRAY_KEY];
    [self.tableView reloadDataWithAutoScrolling];
}

- (void)messagesAddObject:(id)object
{
    [_messages addObject:object];
    [self.userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_messages] forKey:MESSAGES_ARRAY_KEY];
    UITableViewRowAnimation ani = self.isReplying ? UITableViewRowAnimationNone : UITableViewRowAnimationFade;
    [self.tableView insertRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesCount-1 inSection:0] withRowAnimation:ani];
}

- (void)messagesAddObjectFromArray:(NSArray *)array
{
    [_messages addObjectsFromArray:array];
    [self.userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_messages] forKey:MESSAGES_ARRAY_KEY];
    [self.tableView reloadDataWithAutoScrolling];
}

- (void)messagesRemoveAllObjects
{
    [_messages removeAllObjects];
    [self.userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_messages] forKey:MESSAGES_ARRAY_KEY];
    [self.tableView reloadDataWithAutoScrolling];
}

- (BubbleMessageData *)createMessageFromText:(NSString *)text andSender:(BubbleMessageStyle)sender
{
    BubbleMessageData *bubbleMessageData = [BubbleMessageData new];
    bubbleMessageData.bubbleDate = [NSDate date];
    bubbleMessageData.bubbleCurrentSender = sender;
    bubbleMessageData.bubbleContext = text;
    return bubbleMessageData;
}

- (BubbleMessageStyle)currentSender
{
    return [self.userDefaults boolForKey:CURRENT_SENDER_KEY];
}

- (void)setCurrentSender:(BubbleMessageStyle)currentSender
{
    [self.userDefaults setBool:currentSender forKey:CURRENT_SENDER_KEY];
}

- (void)setIsReplying:(BOOL)isReplying
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isReplying != _isReplying) {
            _isReplying = isReplying;
            NSIndexPath *ind = [NSIndexPath indexPathForRow:self.messagesCount inSection:0];
            UITableViewRowAnimation ani = UITableViewRowAnimationFade;
            isReplying ? [self.tableView insertRowAtIndexPath:ind withRowAnimation:ani] : [self.tableView deleteRowAtIndexPath:ind withRowAnimation:ani];
        }
    });
}

#pragma mark - Unload
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setUserDefaults:nil];
    _messages = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setUserDefaults:nil];
    _messages = nil;
}

@end
