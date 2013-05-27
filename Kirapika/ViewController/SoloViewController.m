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

@property (nonatomic, setter = setCurrentSectionIndex:, getter = currentSection) int currentSectionIndex;
@property (nonatomic, strong) NSArray *sections;
- (void)nextSection;
- (void)finalSection;
- (void)displayHint:(NSString *)hint;
- (void)displayContexts:(NSArray *)context;
- (void)checkCondition:(NSString *)text;

@end

@implementation SoloViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setEditingEnabled:NO];
    
    [self clearAllMessages];
    self.currentSender = BubbleMessageStyleRightSender;
    
    NSString *path = [self.userDefaults objectForKey:CURRENT_PLIST_PATH];
    if (path) {
//        NSURL *url = [[[[NSBundle bundleWithURL:[FilesManagement documentDirectory]] resourceURL] URLByAppendingPathComponent:path] URLByAppendingPathExtension:@"plist"];
        NSURL *url = [[[NSURL fileURLWithPath:[[FilesManagement documentDirectory] path]] URLByAppendingPathComponent:path] URLByAppendingPathExtension:@"plist"];
        self.sections = [[NSArray alloc]initWithContentsOfURL:url];
        [self nextSection];
    } else {
        NSLog(@"Plist is not in use!");
    }
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [super sendPressed:sender withText:text];
    [self checkCondition:text];
}

- (void)nextSection
{
    [self displayContexts:[[self.sections objectAtIndex:self.currentSectionIndex] objectForKey:CONTEXTS_ARRAY_KEY]];
    [self displayHint:[[self.sections objectAtIndex:self.currentSectionIndex] objectForKey:HINT_KEY]];
}

- (void)finalSection
{
    NSLog(@"finalSection");
}

- (void)displayHint:(NSString *)hint
{
    self.hint.label.text  = hint;
}

- (void)displayContexts:(NSArray *)contexts
{
    [self setEditingEnabled:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1.5];
        for (NSString *context in contexts) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self replyRecievedWithText:context];
            });
            [NSThread sleepForTimeInterval:fmax(1.5, context.length/6)];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setEditingEnabled:YES];
        });
    });
}

- (void)checkCondition:(NSString *)text
{
    NSDictionary *section = [self.sections objectAtIndex:self.currentSectionIndex];
    self.currentSectionIndex = [text isEqualToString:[section objectForKey:CONDITION_KEY]] ? [[section objectForKey:PASSED_CONDITION_KEY] intValue] : [[section objectForKey:FAILED_CONDITION_KEY] intValue];
    
    self.currentSectionIndex >= self.sections.count ? [self finalSection] : [self nextSection];
}

- (void)setEditingEnabled:(BOOL)enabled
{
    [self.tableView scrollToBottomAnimated:YES];
    [UIView animateWithDuration:0.20 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(enabled * self.hint.bounds.size.height, 0, 0, 0);
        [self.hint setAlpha:enabled];
    }completion:^(BOOL finished) {
        [super setEditingEnabled:enabled];
    }];
}

@end
