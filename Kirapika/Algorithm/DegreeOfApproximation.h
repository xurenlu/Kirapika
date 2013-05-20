//
//  DegreeOfApproximation.h
//  v1.2 add synonyms check(update) and length check
//
//  Created by Justin Jia on 1/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DegreeOfApproximation : NSObject

typedef enum{
    IncludeLengthCheck,
    ExcludeLengthCheck,
}DegreeOfApproximationPreference;

- (void)prepare;
- (void)saveOneString:(NSString *)x;
- (double)degreeOfApproximationWithString:(NSString *)x andString:(NSString *)y;
- (double)degreeOfApproximationWithStringIncludeLengthCheck:(NSString *)x andString:(NSString *)y;

@end
