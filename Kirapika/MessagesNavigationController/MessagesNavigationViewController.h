//
//  MessagesNavigationViewController.h
//  kirakira pikapika
//
//  Created by Justin Jia on 5/5/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureNavigationViewController.h"

@protocol MessagesNavigationViewControllerDelegate <NSObject>

@optional - (void)leftBarButtonItemTapped;
@optional - (void)rightBarButtonItemTapped;

@end

@interface MessagesNavigationViewController : GestureNavigationViewController

@end
