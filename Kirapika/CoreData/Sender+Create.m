//
//  Sender+Create.m
//  Kirapika
//
//  Created by Justin Jia on 1/20/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "CoreDataConstants.h"

@implementation Sender (Create)

+ (Sender *)senderWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context
{
    Sender *sender = nil;
    
    NSArray *matches = [[[context ofType:@"Sender"] where:@"%K = %@", SENDER_NAME, [data objectForKey:SENDER_NAME]] toArray];
    
    if (matches.count > 1 || !matches) {
        NSLog(@"Error, handle it!");
    } else if (matches.count == 0) {
        sender = [NSEntityDescription insertNewObjectForEntityForName:@"Sender" inManagedObjectContext:context];
        sender.name = [data objectForKey:SENDER_NAME];
        sender.photoURL = [data objectForKey:SENDER_PHOTOURL];
        sender.isLeftUser = [data objectForKey:SENDER_IS_LEFT_USER];
    } else {
        sender = [matches lastObject];
    }
    
    return sender;
}

@end
