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
    NSString *str = [self checkSynoyms:self.mutableCopy];
    NSMutableArray *arr = [str.arrayWithWordTokenize mutableCopy];
    [arr removeObject:@":"];
    
    for (int i=0; i<arr.count; i++) {
        NSString *org = [arr objectAtIndex:i];
        NSArray *matches = [[[context ofType:@"Word"] where:@"%K = %@", WORD_ORG, org] toArray];
        if (matches.count) {
            [arr replaceObjectAtIndex:i withObject:[(Word *)matches.lastObject trans]];
        } else if (org.intValue <= 10000000 || org.intValue >= 99999999 || org.length != NOSIMIWO.length) {
            if (saved) {
                Word *word = [Word wordWithData:[self dictionaryWithValuesForWord:org inContext:context withEightDigitNumberPool:pool] inManagedObjectContext:context];
                [arr replaceObjectAtIndex:i withObject:word.trans];
            } else {
                [arr replaceObjectAtIndex:i withObject:NOSIMIWO];
            }
        }
    }
        
    return [arr componentsJoinedByString:nil];
}

- (NSDictionary *)dictionaryWithValuesForWord:(NSString *)str inContext:(NSManagedObjectContext *)context withEightDigitNumberPool:(EightDigitNumberPool *)pool
{
    NSString *trans = pool ? [[NSNumber numberWithInt:pool.number] stringValue] : nil;
    if (!trans)
        do {
            trans = [[NSNumber numberWithInt:(20000000 + rand() % 89999999)] stringValue];
        } while ([[[[context ofType:@"Word"] where:@"%K = %@", WORD_TRANS, trans] toArray] count]);
    return [NSDictionary dictionaryWithObjectsAndKeys:str, WORD_ORG, trans, WORD_TRANS, nil];
}

- (NSString *)checkSynoyms:(NSMutableString *)str
{
    NSString *sStr = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Synonyms" withExtension:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *sPool = [NSMutableArray new];
    for (NSString *str in [sStr componentsSeparatedByString:@";;\n"]) [sPool addObject:[str componentsSeparatedByString:@"::"]];
    
    for (int i=0; i<sPool.count; i++)
        for (NSString *syns in [sPool objectAtIndex:i])
            [str replaceOccurrencesOfString:syns withString:[NSString stringWithFormat:@"%d:", 10000000+i] options:NSWidthInsensitiveSearch range:NSMakeRange(0, str.length)];
    return str;
}

@end