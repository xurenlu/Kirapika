//
//  ReplyText.h
//  Kirapika
//
//  Created by Justin Jia on 2/1/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "CoreDataConstants.h"
#import "DegreeOfApproximation.h"

typedef enum{
    NormalReply = 0,
    AllPossibleReply = 1,
    SingleReply = 2,
}ReplyTextPreference;

typedef enum {
    ReplyTextRightSender = 0,
    ReplyTextLeftSender = 1
}ReplyTextSender;

@interface ReplyText : NSObject

@property (nonatomic) ReplyTextPreference replyTextPreference;

- (void)loadWithManagedObjectContext:(NSManagedObjectContext *)context andLimit:(long)limit;
- (NSArray *)replysWithText:(NSString *)str andSender:(ReplyTextSender)sender;
- (Message *)replyAnyObjectWithSender:(ReplyTextSender)sender;

@end
