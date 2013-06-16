//
//  DegreeOfApproximation.h
//  v1.2 add synonyms check(update) and length check
//
//  Created by Justin Jia on 1/13/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

@interface DegreeOfApproximation : NSObject

+ (int)extraCost:(NSMutableString *)x;
+ (double)degreeOfApproximation:(NSString *)x :(NSString *)y withExtra:(int)extra;

@end
