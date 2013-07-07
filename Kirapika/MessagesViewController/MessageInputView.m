//
//  MessageInputView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MessageInputView.h"

@interface MessageInputView ()

@property (nonatomic, strong) UIImageView *inputFieldBack;

- (void)setup;
- (void)setupTextView;
- (void)setupSendButton;

@end

@implementation MessageInputView

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.image = [[UIImage imageNamed:@"input-bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f) resizingMode:UIImageResizingModeStretch];
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    
    [self setupTextView];
    [self setupSendButton];
}

- (void)setupTextView
{
    CGFloat width = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 246.0f : 690.0f;
    
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6.0f, 3.0f, width, self.bounds.size.height)];
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 6;
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.textView];
    
    self.inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                0.0f,
                                                                                self.textView.frame.size.width + 2.0f,
                                                                                self.bounds.size.height)];

    self.inputFieldBack.image = [[UIImage imageNamed:@"input-field"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f) resizingMode:UIImageResizingModeStretch];

    self.inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight);
    [self addSubview:self.inputFieldBack];
}

- (void)setupSendButton
{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(self.bounds.size.width - 65.0f, 8.0f, 59.0f, 26.0f);
    self.sendButton.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin);

    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [[UIImage imageNamed:@"send"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [[UIImage imageNamed:@"send-highlighted"] resizableImageWithCapInsets:insets];
    [self.sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [self.sendButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = NSLocalizedString(@"Send", @"send button text");
    [self.sendButton setTitle:title forState:UIControlStateNormal];
    [self.sendButton setTitle:title forState:UIControlStateHighlighted];
    [self.sendButton setTitle:title forState:UIControlStateDisabled];
    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [self.sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [self.sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    self.sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    self.sendButton.enabled = NO;
    [self addSubview:self.sendButton];
}

#pragma mark - User Interaction
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];

    UIImage *image = [UIImage imageNamed:userInteractionEnabled ? @"input-field" : @"input-field-disable"];
    self.inputFieldBack.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)];
}

@end