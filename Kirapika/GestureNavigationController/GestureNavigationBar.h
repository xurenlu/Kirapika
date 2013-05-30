//
//  GestureNavigationBar.h
//  Kirapika
//
//  Created by Justin Jia on 5/6/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeDownOnNavigationBarToDismissCurrentViewController <NSObject>

- (void)touchBegan:(UIWindow *)window;
- (void)setBackgroundViewWith:(float)distanceToBottom;
- (void)moveView:(float)distance;

- (void)touchFailed;
- (void)touchSucceed;

@end

@interface GestureNavigationBar : UINavigationBar

@property (nonatomic, assign) id<SwipeDownOnNavigationBarToDismissCurrentViewController> swipeDownOnNavigationBarToDismissCurrentViewControllerDelegate;

@end
