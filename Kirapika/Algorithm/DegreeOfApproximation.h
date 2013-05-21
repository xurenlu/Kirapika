//
//  DegreeOfApproximation.h
//  v1.2 add synonyms check(update) and length check
//
//  Created by Justin Jia on 1/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DegreeOfApproximation : NSObject

@property (nonatomic, strong) NSString *x;
- (double)degreeOfApproximation:(NSString *)y;

@end
