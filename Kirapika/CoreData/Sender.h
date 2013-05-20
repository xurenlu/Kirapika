//
//  Sender.h
//  Kirapika
//
//  Created by Justin Jia on 5/20/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface Sender : NSManagedObject

@property (nonatomic, retain) NSNumber * isLeftUser;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSSet *messages;
@end

@interface Sender (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
