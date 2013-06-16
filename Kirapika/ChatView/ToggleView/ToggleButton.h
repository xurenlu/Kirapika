//
//  ToggleButton.h
//  ToggleView
//
//  Created by SOMTD on 12/10/15.
//  Copyright (c) 2012 somtd.com. All rights reserved.
//

typedef enum{
    ToggleButtonTypeDefault,
    ToggleButtonTypeChangeImage,
}ToggleButtonType;

@interface ToggleButton : UIImageView

@property (nonatomic) ToggleButtonType buttonType;
- (id)initWithImage:(UIImage *)image buttonType:(ToggleButtonType)aButtonType;
- (void)selectedLeftToggleButton;
- (void)selectedRightToggleButton;

@end
