//
//  PixelView.m
//  kirakira pikapika
//
//  Created by Justin Jia on 1/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "PixelView.h"

@implementation PixelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:246.0f/255.0f alpha:0.0f]];
        self.state = PixelShadeStateNormal;
    }
    return self;
}

- (void)isShadeWithLevel:(PixelShadeState)level
{
    if (self.state != PixelShadeStateCenter) {
        if (level == PixelShadeStateDark) {
            [self setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:246.0f/255.0f alpha:0.4f]];
            self.state = PixelShadeStateDark;
        } else if (level == PixelShadeStateLight && self.state == PixelShadeStateNormal) {
            [self setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:246.0f/255.0f alpha:0.2f]];
            self.state = PixelShadeStateLight;
        }
    }
}

- (void)isCenter
{
    [self setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:246.0f/255.0f alpha:0.6f]];
    self.state = PixelShadeStateCenter;
}

- (void)isNormal
{
    [self setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:246.0f/255.0f alpha:0.0f]];
    self.state = PixelShadeStateNormal;
}

@end
