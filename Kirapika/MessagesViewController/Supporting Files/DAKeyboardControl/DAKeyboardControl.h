//
//  DAKeyboardControl.h
//  DAKeyboardControlExample
//
//  Created by Daniel Amitay on 7/14/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#warning wait to add until final release of iOS 7

typedef void (^DAKeyboardDidMoveBlock)(CGRect keyboardFrameInView);

@interface UIView (DAKeyboardControl)

@property (nonatomic) CGFloat keyboardTriggerOffset;

- (void)addKeyboardPanningWithActionHandler:(DAKeyboardDidMoveBlock)didMoveBlock;
- (void)addKeyboardNonpanningWithActionHandler:(DAKeyboardDidMoveBlock)didMoveBlock;

- (void)removeKeyboardControl;

- (CGRect)keyboardFrameInView;

- (void)hideKeyboard;

@end