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

@property (nonatomic, strong) ToggleView *toggleView;
@property (nonatomic, strong) ReplyText *replyText;
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
    
    self.toggleView = [[ToggleView alloc]initWithFrame:CGRectMake(0, 0, 160, 36) toggleViewType:ToggleViewTypeWithLabel toggleBaseType:ToggleBaseTypeDefault toggleButtonType:ToggleButtonTypeChangeImage];
    self.toggleView.toggleDelegate = self;
    self.toggleView.selectedButton = self.toggleButtonSelected;
    [self.titleView addSubview:self.toggleView];
}

- (void)documentIsReady
{
    if (!self.messagesCount)
        [self messagesAddObject:[self createMessageFromMessage:[self.replyText replyAnyObjectWithSender:!self.replyTextSender]]];
    
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
        NSString *check = [self checkSpecialCommandWithText:text];
        if (check) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self replyRecievedWithText:check];
                [self setEditingEnabled:YES];
            });
        } else {
            UIApplication* application = [UIApplication sharedApplication];
            __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^(void){
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }];
            
            NSArray *replys = [self.replyText replyWithMessageContext:text andSender:self.replyTextSender andData:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self replyRecievedWithMessages:replys];
                [self setEditingEnabled:YES];
                
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            });
        }
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
                return [NSString stringWithFormat:@"have set limit to:%ld", number];
            } else {
                return @"cannot be 0";
            }
        } else if ([text isEqualToString:@"SetNormalReply"]) {
            self.replyText.replyTextPreference = NormalReply;
            return @"have set reply text preference to 'normal'";
        } else if ([text isEqualToString:@"SetSingleReply"]) {
            self.replyText.replyTextPreference = SingleReply;
            return @"have set reply text preference to 'single'";
        } else if ([text isEqualToString:@"SetAllPossibleReply"]) {
            self.replyText.replyTextPreference = AllPossibleReply;
            return @"have set reply text preference to 'all possiable'";
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _replyText = nil;
}

@end
