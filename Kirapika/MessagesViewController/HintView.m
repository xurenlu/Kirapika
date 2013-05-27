//
//  HintView.m
//  Kirapika
//
//  Created by Justin Jia on 4/10/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "HintView.h"

@interface HintView ()

- (void)setup;

@end

@implementation HintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    self.image = [[UIImage imageNamed:@"hint-bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 1.0f, 12.0f, 1.0f)];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
        
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.label.enabled = NO;
    self.label.font = [UIFont systemFontOfSize:14.0];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self addSubview:self.label];
}

@end
