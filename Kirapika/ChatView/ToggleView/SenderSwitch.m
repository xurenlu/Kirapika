//
//  SenderSwitch.m
//  Kirapika
//
//  Created by Justin Jia on 6/4/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "SenderSwitch.h"
#import "UserDefaultsKeys.h"

#define WIDTH 160
#define HEIGHT 36

@interface SenderSwitch()

- (void)setup;

@end

@implementation SenderSwitch

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
    self.toggleView = [[ToggleView alloc]initWithFrame:CGRectMake((self.bounds.size.width-WIDTH)/2, 0, WIDTH, HEIGHT)
                                        toggleViewType:ToggleViewTypeWithLabel
                                        toggleBaseType:ToggleBaseTypeDefault
                                      toggleButtonType:ToggleButtonTypeChangeImage];
    self.toggleView.selectedButton = (ToggleButtonSelected)[[NSUserDefaults standardUserDefaults] boolForKey:CURRENT_SENDER_KEY];
    [self addSubview:self.toggleView];
}

@end
