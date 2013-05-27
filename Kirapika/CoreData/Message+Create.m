//
//  Messages+Create.m
//  Kirapika
//
//  Created by Justin Jia on 1/20/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "CoreDataConstants.h"

@implementation Message (Create)

+ (Message *)messageWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    Message *message = nil;
    
    NSArray *matches = [[[context ofType:@"Message"] where:@"%K = %@", MESSAGE_DATE, [data objectForKey:MESSAGE_DATE]] toArray];
    
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
