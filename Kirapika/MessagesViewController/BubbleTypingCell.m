//
//  BubbleTypingCell.m
//  Kirapika
//
//  Created by Justin Jia on 5/31/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "BubbleTypingCell.h"

@interface BubbleTypingCell()

- (void)setup;
@property (nonatomic, strong) UIImageView *typingImageView;

@end

@implementation BubbleTypingCell

#pragma mark - Initialization
- (void)setup
{
    if (!self.typingImageView) {
        self.typingImageView = [UIImageView new];
        [self addSubview:self.typingImageView];
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
}

- (void)setStyle:(BubbleMessageStyle)style
{
    UIImage *bubbleImage = [UIImage imageNamed:(style == BubbleMessageStyleLeftSender) ? @"messageBubbleTypingLeft" : @"messageBubbleTypingRight"];
    CGFloat x = (style == BubbleMessageStyleLeftSender) ? 0 : self.bounds.size.width - bubbleImage.size.width;
    
    self.autoresizingMask = (style == BubbleMessageStyleLeftSender) ? UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight :                            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    self.typingImageView.image = bubbleImage;
    self.typingImageView.frame = CGRectMake(x, 4, 55, 30);
}

- (id)initWithBubbleStyle:(BubbleMessageStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        [self setStyle:style];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

+ (CGFloat)height
{
    return 40;
}

@end
