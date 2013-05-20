//
//  Sender+Create.h
//  kirakira pikapika
//
//  Created by Justin Jia on 1/20/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "Sender.h"

@interface Sender (Create)

+ (Sender *)senderWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;

@end
