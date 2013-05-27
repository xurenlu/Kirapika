//
//  EightDigitNumberPool.m
//  Kirapika Builder
//
//  Created by Justin Jia on 5/24/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "EightDigitNumberPool.h"

@implementation EightDigitNumberPool

- (int)number
{
    if (_number == 0 || _number == 99999999) _number = 20000000;
    _number++;
    return _number;
}

@end
