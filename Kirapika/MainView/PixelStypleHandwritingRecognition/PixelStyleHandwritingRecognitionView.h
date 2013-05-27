//
//  PixelStyleHandwritingRecognitionView.h
//  Kirapika
//
//  Created by Justin Jia on 1/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideView.h"
#import "NSNumber+RecognizedMark.h"

@protocol PixelStyleHandwritingRecognitionViewDelegate;

@interface PixelStyleHandwritingRecognitionView : UIImageView

@property (nonatomic, assign) id<PixelStyleHandwritingRecognitionViewDelegate> pixelStyleHandwritingRecognitionViewDelegate;
@property (nonatomic, strong) GuideView *guideView;

@end

@protocol PixelStyleHandwritingRecognitionViewDelegate <NSObject>

- (void)recognizedMark:(RecognizedMarkType)mark;
- (void)finalRecognizedMark:(RecognizedMarkType)mark;

@end
