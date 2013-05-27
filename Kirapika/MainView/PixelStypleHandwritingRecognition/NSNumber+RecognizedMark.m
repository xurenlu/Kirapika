//
//  NSDictionary+LetterRecognitionFromLocus.m
//  Kirapika
//
//  Created by Justin Jia on 1/24/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "NSNumber+RecognizedMark.h"

@implementation NSNumber (RecognizedMark)

- (RecognizedMarkType)mark
{
    return ((self.intValue - 10) / 15) % 4; //only public top 4 now
}

@end
