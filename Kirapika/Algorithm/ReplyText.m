//
//  ReplyText.m
//  Kirapika
//
//  Created by Justin Jia on 2/1/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ReplyText.h"
#import "NSString+Transcode.h"

#define PROBABILITY_THRESHOLD 0.5

@interface ReplyText()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *leftSenderMessages;
@property (nonatomic, strong) NSArray *rightSenderMessages;
@property (nonatomic) BOOL load;
- (id)anyObject:(NSArray *)array;

@end

@implementation ReplyText
- (void)loadWithManagedObjectContext:(NSManagedObjectContext *)context andLimit:(long)limit
{
    self.context = context;

    self.leftSenderMessages = [[[[[context ofType:@"Message"]
                                  where:[NSString stringWithFormat:@"whoSent.%@ = 1",SENDER_IS_LEFT_USER]]
                                 orderBy:MESSAGE_ROW_ID]
                                take:limit]
                               toArray];
    self.rightSenderMessages = [[[[[context ofType:@"Message"]
                                   where:[NSString stringWithFormat:@"whoSent.%@ = 0",SENDER_IS_LEFT_USER]]
                                  orderBy:MESSAGE_ROW_ID]
                                 take:limit]
                                toArray];

    self.load = YES;
}

- (NSArray *)replyWithMessageContext:(NSString *)str andSender:(ReplyTextSender)sender andData:(id)data
{
    if (!self.load) return nil;
    
    NSMutableArray *replys = [NSMutableArray new];
    NSArray *messages = (sender == ReplyTextLeftSender) ? self.leftSenderMessages : self.rightSenderMessages;
    str = [str transcode:self.context save:NO withEightDigitNumberPool:nil];
    
    int rowID = NO;
    int extra = [DegreeOfApproximation extraCost:[str mutableCopy]];
    for (Message *message in messages) {
        if (rowID) {
            NSArray *reply = [[[[self.context ofType:@"Message"]
                                where:@"%K BETWEEN {%d,%d}",MESSAGE_ROW_ID, rowID+1, message.rowID.intValue-1]
                               orderBy:MESSAGE_ROW_ID]
                              toArray];
            if (reply.count > 0) [replys addObject:reply];
            rowID = NO;
        }
        double probability = [DegreeOfApproximation degreeOfApproximation:str :message.contextTranscoding withExtra:extra];
        if (probability >= PROBABILITY_THRESHOLD) rowID = message.rowID.intValue;
    }
        
    if (!replys.count) return nil;

    if (self.replyTextPreference == NormalReply) {
        return [replys objectAtIndex:arc4random() % replys.count];
    } else if (self.replyTextPreference == SingleReply) {
        return [[replys objectAtIndex:arc4random() % replys.count] objectAtIndex:0];
    } else if (self.replyTextPreference == AllPossibleReply) {
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSArray *array in replys) for (Message *message in array) [tmp addObject:message];
        return tmp;
    }
    
    return nil;
}

- (Message *)replyAnyObjectWithSender:(ReplyTextSender)sender
{
    return [self anyObject:(sender == ReplyTextLeftSender) ? self.leftSenderMessages : self.rightSenderMessages];
}

- (id)anyObject:(NSArray *)array
{
    return [array objectAtIndex:rand() % array.count];
}

@end
