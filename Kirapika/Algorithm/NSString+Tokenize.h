//
//  NSString+Tokenize.h
//  v1.0
//
//  Created by Lancy on 22/10/12.
//  Copyright (c) 2012 Lancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tokenize)

- (NSMutableArray *)arrayWithWordTokenize;
- (NSString *)separatedStringWithSeparator:(NSString *)separator;

@end
