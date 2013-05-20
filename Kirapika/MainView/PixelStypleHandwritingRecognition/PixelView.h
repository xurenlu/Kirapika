//
//  PixelView.h
//  kirakira pikapika
//
//  Created by Justin Jia on 1/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PixelView : UIView

typedef enum{
    PixelShadeStateNormal,
    PixelShadeStateLight,
    PixelShadeStateDark,
    PixelShadeStateCenter,
}PixelShadeState;

@property (nonatomic) PixelShadeState state;
- (void)isShadeWithLevel:(PixelShadeState)level;
- (void)isCenter;
- (void)isNormal;
@
end
