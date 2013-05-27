//
//  UIView+FindFirstResponder.m
//  Kirapika
//
//  Created by Justin Jia on 5/14/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "UIView+FindFirstResponder.h"

@implementation UIView (FindFirstResponder)

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (id subView in self.subviews) {
        if ([subView isFirstResponder]){
            return subView;
        }
        if ([subView findFirstResponder]){
            return [subView findFirstResponder];
        }
    }
    return nil;
}

@end
