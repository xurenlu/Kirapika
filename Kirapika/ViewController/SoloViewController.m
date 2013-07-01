//
//  SoloViewController.m
//  Kirapika
//
//  Created by Justin Jia on 4/7/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "SoloViewController.h"
#import "FilesManagement.h"

#define CONDITION_KEY @"solo condition key"
#define CONTEXTS_ARRAY_KEY @"solo context array key"
#define HINT_KEY @"solo hint key"
#define PASSED_CONDITION_KEY @"solo passed condition key"
#define FAILED_CONDITION_KEY @"solo failed condition key"

@interface SoloViewController ()

@property (nonatomic) NSUInteger currentSectionIndex;
@property (nonatomic, strong) NSArray *sections;
- (void)nextSection;
- (void)finalSection;
- (void)displayHint:(NSString *)hint;
- (void)displayContexts:(NSArray *)context;
- (void)checkCondition:(NSString *)text;
- (NSDictionary *)currentSection;

@end

@implementation SoloViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setEditingEnabled:NO];

    [self clearAllMessages];
    self.currentSender = BubbleMessageStyleRightSender;
    
    NSString *path = [self.userDefaults objectForKey:CURRENT_PLIST_NAME];
    if (path) {
        NSURL *url = [[[FilesManagement documentDirectory] URLByAppendingPathComponent:path] filePathURL];
        self.sections = [[NSArray alloc]initWithContentsOfURL:url];
        [self nextSection];
    } else {
        [self replyRecievedWithText:NSLocalizedString(@"Sorry, I think the document is not existed.", @"error message")];
    }
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [super sendPressed:sender withText:text];
    [self checkCondition:text];
}

- (void)nextSection
{
    [self displayContexts:(self.currentSection)[CONTEXTS_ARRAY_KEY]];
    [self displayHint:(self.currentSection)[HINT_KEY]];
}

- (void)finalSection
{
    [super setEditingEnabled:NO];
}

- (void)displayHint:(NSString *)hint
{
    self.hint.label.text  = hint;
}

- (void)displayContexts:(NSArray *)contexts
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self setEditingEnabled:NO];
        for (NSString *context in contexts) {
            [self setIsReplying:YES];
            [NSThread sleepForTimeInterval:fmax(1.5, context.length/6.5)];
            [self replyRecievedWithText:context];
        }
        [NSThread sleepForTimeInterval:1.5];
        [self setEditingEnabled:YES];
    });
}

- (void)checkCondition:(NSString *)text
{
    self.currentSectionIndex = [text isEqualToString:(self.currentSection)[CONDITION_KEY]] ? [(self.currentSection)[PASSED_CONDITION_KEY] intValue] : [(self.currentSection)[FAILED_CONDITION_KEY] intValue];
    
    self.currentSectionIndex >= self.sections.count ? [self finalSection] : [self nextSection];
}

- (void)setEditingEnabledInterval:(BOOL)enabled
{
    [self.tableView scrollToBottomAnimated:YES];
    [UIView animateWithDuration:0.20 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(enabled * self.hint.bounds.size.height, 0, 0, 0);
        [self.hint setAlpha:enabled];
    }completion:^(BOOL finished) {
        [super setEditingEnabledInterval:enabled];
    }];
}

#pragma mark - Data
- (NSDictionary *)currentSection
{
    return (self.sections)[self.currentSectionIndex];
}

#pragma mark - Unload
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setSections:nil];
}

@end
