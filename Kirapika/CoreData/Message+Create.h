//
//  Messages+Create.h
//  Kirapika
//
//  Created by Justin Jia on 1/20/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "Message.h"

@interface Message (Create)

+ (Message *)messageWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;

@end
