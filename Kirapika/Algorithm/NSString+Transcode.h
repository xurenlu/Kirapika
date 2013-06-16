//
//  NSString+Transcode.h
//  Kirapika
//
//  Created by Justin Jia on 5/21/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "EightDigitNumberPool.h"

#define NOSIMIWO @"NOSIMIWO"

@interface NSString (Transcode)

- (NSString *)transcode:(NSManagedObjectContext *)context save:(BOOL)saved withEightDigitNumberPool:(EightDigitNumberPool *)pool;

@end
