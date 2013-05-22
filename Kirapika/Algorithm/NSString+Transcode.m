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

- (NSString *)transcode:(NSManagedObjectContext *)context save:(BOOL)saved
{
    NSString *str = [self checkSynoyms:[self mutableCopy]];
    NSMutableArray *arr = [str.arrayWithWordTokenize mutableCopy];
    [arr removeObject:@":"];

    for (int i=0; i<arr.count; i++) {
        NSString *org = [arr objectAtIndex:i];
        NSArray *matches = [[[context ofType:@"Word"] where:@"%@ = %@", WORD_ORG, org] toArray];
        if (matches.count) {
            [arr replaceObjectAtIndex:i withObject:[(Word *)matches.lastObject trans]];
        } else if (org.intValue <= 100000 || org.intValue >= 999999 || org.length > 6) {
            if (saved) {
                [Word wordWithData:[self dictionaryWithValuesForWord:org inContext:context] inManagedObjectContext:context];
            } else {
                [arr replaceObjectAtIndex:i withObject:@"NOSIMI"];
            }
        }
    }
    
    return [arr componentsJoinedByString:nil];
}

- (NSDictionary *)dictionaryWithValuesForWord:(NSString *)str inContext:(NSManagedObjectContext *)context
{
    NSString *trans = nil;
    do {
        trans = [[NSNumber numberWithInt:100000 + rand() % 899999] stringValue];
    } while ([[[[context ofType:@"Word"] where:@"%@ = %@", WORD_TRANS, trans] toArray] count]);
    return [NSDictionary dictionaryWithObjectsAndKeys:str, WORD_ORG, trans, WORD_TRANS, nil];
}

- (NSString *)checkSynoyms:(NSMutableString *)str
{
    NSString *sStr = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Synonyms" withExtension:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *sPool = [NSMutableArray new];
    for (NSString *str in [sStr componentsSeparatedByString:@";;\n"]) [sPool addObject:[str componentsSeparatedByString:@"::"]];
    
    for (int i=0; i<sPool.count; i++)
        for (NSString *syns in [sPool objectAtIndex:i])
            [str replaceOccurrencesOfString:syns withString:[NSString stringWithFormat:@"%d:", 100000+i] options:NSWidthInsensitiveSearch range:NSMakeRange(0, [str length])];
    return str;
}

@end