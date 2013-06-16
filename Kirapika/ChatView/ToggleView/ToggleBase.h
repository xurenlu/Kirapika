//
//  ToggleBase.h
//  ToggleView
//
//  Created by SOMTD on 12/10/15.
//  Copyright (c) 2012 somtd.com. All rights reserved.
//

typedef enum{
    ToggleBaseTypeDefault,
    ToggleBaseTypeChangeImage,
}ToggleBaseType;

@interface ToggleBase : UIImageView

@property (nonatomic) ToggleBaseType baseType;
- (id)initWithImage:(UIImage *)image baseType:(ToggleBaseType)aBaseType;
- (void)selectedLeftToggleBase;
- (void)selectedRightToggleBase;

@end
