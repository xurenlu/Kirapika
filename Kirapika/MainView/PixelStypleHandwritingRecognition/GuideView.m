//
//  guideView.m
//  Kirapika
//
//  Created by Justin Jia on 5/4/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "GuideView.h"

@interface GuideView()

- (void)setup;

@end

@implementation GuideView

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
    self.image = [[UIImage imageNamed:@"guide-view"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 22) resizingMode:UIImageResizingModeStretch];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    self.tag = -1;
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, -2, self.bounds.size.width, self.bounds.size.height)];
    self.label.enabled = YES;
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:self.label];
}

@end
