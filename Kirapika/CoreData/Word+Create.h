//
//  Word+Create.h
//  Kirapika
//
//  Created by Justin Jia on 5/21/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "Word.h"

@interface Word (Create)

+ (Word *)wordWithData:(NSDictionary *)data inManagedObjectContext:(NSManagedObjectContext *)context;

@end
