//
//  Word+Create.m
//  Kirapika
//
//  Created by Justin Jia on 5/21/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "CoreDataConstants.h"

@implementation Word (Create)

+ (Word *)wordWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    Word *word = nil;
    
    NSArray *matches = [[[[context ofType:@"Word"] where:@"%@ = %@", WORD_ORG, [data objectForKey:WORD_ORG]] orderBy:WORD_ORG] toArray];
    
    if (matches.count > 1 || !matches) {
        NSLog(@"Error, handle it!");
    } else if (matches.count == 0) {
        word = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
        word.org = [data objectForKey:WORD_ORG];
        word.trans = [data objectForKey:WORD_TRANS];
    } else {
        word = [matches lastObject];
    }
    
    return word;
}

@end