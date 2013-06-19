//
//  ViewController.h
//  Kirapika
//
//  Created by Justin Jia on 1/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "PixelStyleHandwritingRecognitionView.h"

@interface ViewController : UIViewController <PixelStyleHandwritingRecognitionViewDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet PixelStyleHandwritingRecognitionView *view;

@end
