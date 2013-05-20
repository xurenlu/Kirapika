//
//  NSString+Tokenize.m
//  v1.0
//
//  Created by Lancy on 22/10/12.
//  Copyright (c) 2012 Lancy. All rights reserved.
//

#import "NSString+Tokenize.h"

@implementation NSString (Tokenize)

- (NSMutableArray *)arrayWithWordTokenize
{
    NSMutableArray *tokensArray = [NSMutableArray array];
    NSString *string = self;
    
    CFLocaleRef locale = CFLocaleCopyCurrent();
    CFRange range = CFRangeMake(0, [string length]);
    
    CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault,
                                                             (CFStringRef)string,
                                                             range,
                                                             kCFStringTokenizerUnitWordBoundary,
                                                             locale);
    
    CFStringTokenizerTokenType tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer);
    
    while (tokenType != kCFStringTokenizerTokenNone) {
        range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        [tokensArray addObject:[string substringWithRange:NSMakeRange(range.location, range.length)]];
        tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer);
    }
    
    CFRelease(locale);
    CFRelease(tokenizer);
    
    return tokensArray;
}

- (NSString *)separatedStringWithSeparator:(NSString *)separator
{
    return [self.arrayWithWordTokenize componentsJoinedByString:separator];
}

@end
