//
//  NSString+Transcode.m
//  Kirapika
//
//  Created by Justin Jia on 5/21/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "NSString+Transcode.h"
#import "NSString+Tokenize.h"
#import "CoreDataConstants.h"

@implementation NSString (Transcode)

- (NSString *)transcode:(NSManagedObjectContext *)context save:(BOOL)saved withEightDigitNumberPool:(EightDigitNumberPool *)pool
{
    NSMutableArray *arr = [[self checkSynoyms:self.mutableCopy].arrayWithWordTokenize mutableCopy];
    [arr removeObject:@":"];
    
    for (NSUInteger i=0; i<arr.count; i++) {
        NSString *org = arr[i];
        NSArray *matches = [[[context ofType:WORD] where:@"%K = %@", WORD_ORG, org] toArray];
        if (matches.count) {
            arr[i] = [(Word *)matches.lastObject trans];
        } else if (org.intValue <= 10000000 || org.intValue >= 99999999 || org.length != NOSIMIWO.length) {
            Word *word = saved ? [Word wordWithData:[self dictionaryForWord:org inContext:context withEightDigitNumberPool:pool] inManagedObjectContext:context] : nil;
            arr[i] = saved ? word.trans : NOSIMIWO;
        }
    }
        
    return [arr componentsJoinedByString:nil];
}

- (NSDictionary *)dictionaryForWord:(NSString *)str inContext:(NSManagedObjectContext *)context withEightDigitNumberPool:(EightDigitNumberPool *)pool
{
    NSString *trans = pool ? [@(pool.number) stringValue] : nil;
    if (!trans)
        do {
            trans = [@(20000000 + rand() % 79999999) stringValue];
        } while ([[[[context ofType:WORD] where:@"%K = %@", WORD_TRANS, trans] toArray] count]);
    return @{WORD_ORG: str, WORD_TRANS: trans};
}

- (NSString *)checkSynoyms:(NSMutableString *)str
{
    NSString *sStr = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Synonyms" withExtension:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *sPool = [NSMutableArray new];
    for (NSString *str in [sStr componentsSeparatedByString:@";;\n"]) [sPool addObject:[str componentsSeparatedByString:@"::"]];
    
    for (NSUInteger i=0; i<sPool.count; i++)
        for (NSString *syns in sPool[i])
            [str replaceOccurrencesOfString:syns withString:[NSString stringWithFormat:@"%d:", 10000000+i] options:NSWidthInsensitiveSearch range:NSMakeRange(0, str.length)];
    return str;
}

@end