//
//  CoreDataConstants.h
//  Kirapika
//
//  Created by Justin Jia on 2/1/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#ifndef Kirapika_CoreDataConstants_h
#define Kirapika_CoreDataConstants_h

#import <CoreData/CoreData.h>

#import "Sender+Create.h"
#import "Message+Create.h"
#import "NSManagedObjectContext+Queryable.h"

#define MESSAGE_CONTEXT @"context"
#define MESSAGE_CONTEXT_TRANS @"contextTranscoding"
#define MESSAGE_DATE @"date"
#define MESSAGE_ROW_ID @"rowID"
#define SENDER_NAME @"name"
#define SENDER_PHOTOURL @"photoUrl"
#define SENDER_IS_LEFT_USER @"isLeftUser"

#endif
