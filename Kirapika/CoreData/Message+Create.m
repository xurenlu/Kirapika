//
//  Messages+Create.m
//  kirakira pikapika
//
//  Created by Justin Jia on 1/20/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "CoreDataConstants.h"

@implementation Message (Create)

+ (Message *)messageWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    Message *message = nil;
    
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%@ = %@", MESSAGE_DATE, [data objectForKey:MESSAGE_DATE]];
//
//    //limit
//    //fetchRequest.fetchLimit = 100000;
//    //fetchRequest.fetchBatchSize = 20;
//     
//    NSSortDescriptor *sortDescriptorByMessage = [NSSortDescriptor sortDescriptorWithKey:MESSAGE_DATE ascending:YES];
//    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptorByMessage];
//    
//    NSError *error = nil;
//    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    NSArray *matches = [[[[context ofType:@"Message"] where:@"%@ = %@", MESSAGE_DATE, [data objectForKey:MESSAGE_DATE]] orderBy:MESSAGE_DATE] toArray];
    
    if (matches.count > 1 || !matches) {
        NSLog(@"Error, handle it!");
    } else if (matches.count == 0) {
        message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
        message.context = [data objectForKey:MESSAGE_CONTEXT];
        message.contextTranscoding = [data objectForKey:MESSAGE_CONTEXT_TRANS];
        message.date = [data objectForKey:MESSAGE_DATE];
        message.rowID = [data objectForKey:MESSAGE_ROW_ID];
        message.whoSent = [Sender senderWithData:data inManagedObjectContext:context];
    } else {
        message = [matches lastObject];
    }
    
    return message;
}

@end
