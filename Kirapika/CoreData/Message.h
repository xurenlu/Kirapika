//
//  Message.h
//  Kirapika
//
//  Created by Justin Jia on 5/20/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

@import CoreData;

@class Sender;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * context;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * rowID;
@property (nonatomic, retain) NSString * contextTranscoding;
@property (nonatomic, retain) Sender *whoSent;

@end
