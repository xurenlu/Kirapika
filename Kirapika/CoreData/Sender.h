//
//  Sender.h
//  Kirapika
//
//  Created by Justin Jia on 5/21/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

@import CoreData;

@class Message;

@interface Sender : NSManagedObject

@property (nonatomic, retain) NSNumber * isLeftUser;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSSet *messages;
@end

@interface Sender (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
