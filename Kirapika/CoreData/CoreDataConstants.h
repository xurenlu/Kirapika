//
//  CoreDataConstants.h
//  Kirapika
//
//  Created by Justin Jia on 2/1/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#ifndef Kirapika_CoreDataConstants_h
#define Kirapika_CoreDataConstants_h

@import CoreData;

#import "Word+Create.h"
#import "Sender+Create.h"
#import "Message+Create.h"

#import "NSManagedObjectContext+Queryable.h"

#define MESSAGE @"Message"
#define MESSAGE_CONTEXT @"context"
#define MESSAGE_CONTEXT_TRANS @"contextTranscoding"
#define MESSAGE_DATE @"date"
#define MESSAGE_ROW_ID @"rowID"
#define SENDER @"Sender"
#define SENDER_NAME @"name"
#define SENDER_PHOTOURL @"photoURL"
#define SENDER_IS_LEFT_USER @"isLeftUser"
#define WORD @"Word"
#define WORD_ORG @"org"
#define WORD_TRANS @"trans"

#endif
