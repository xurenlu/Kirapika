//
//  ReplyText.m
//  kirakira pikapika
//
//  Created by Justin Jia on 2/1/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ReplyText.h"

@interface ReplyText()

@property (nonatomic, strong) DegreeOfApproximation *degreeOfApproximation;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *leftSenderMessages;
@property (nonatomic, strong) NSArray *rightSenderMessages;
@property (nonatomic) BOOL load;

@end

@implementation ReplyText
- (void)loadWithManagedObjectContext:(NSManagedObjectContext *)context andLimit:(long)limit
{
    self.degreeOfApproximation = [DegreeOfApproximation new];
    [self.degreeOfApproximation prepare];
    self.context = context;

    self.leftSenderMessages = [[[[[context ofType:@"Message"]
                                  where:@"whoSent.%@",SENDER_IS_LEFT_USER]
                                 orderBy:MESSAGE_ROW_ID]
                                take:limit]
                               toArray];
    self.rightSenderMessages = [[[[[context ofType:@"Message"]
                                   where:@"!whoSent.%@",SENDER_IS_LEFT_USER]
                                  orderBy:MESSAGE_ROW_ID]
                                 take:limit]
                                toArray];
    
    self.load = YES;
}

- (NSArray *)replyWithMessageContext:(NSString *)str andSender:(ReplyTextSender)sender andData:(id)data
{
    if (!self.load) return nil;
    
    NSMutableArray *replys = [NSMutableArray new];
    NSArray *messages;
    
    if (sender == ReplyTextLeftSender) {
        messages = self.leftSenderMessages;
    } else {
        messages = self.rightSenderMessages;
    }
    
    int rowID = NO;
    [self.degreeOfApproximation saveOneString:str];
    for (Message *message in messages) {
        if (rowID) {
            NSArray *reply = [[[[self.context ofType:@"Message"]
                                where:@"%@ BETWEEN {%d,%d}",MESSAGE_ROW_ID, rowID+1, message.rowID.intValue-1]
                               orderBy:MESSAGE_ROW_ID]
                              toArray];
            if (reply.count > 0) [replys addObject:reply];
            rowID = NO;
        }
        double probability = [self.degreeOfApproximation degreeOfApproximationWithStringIncludeLengthCheck:nil andString:message.context];
        if (probability >= 0.5) {
            rowID = message.rowID.intValue;
        }
    }
        
    if (replys.count == 0) {
        Message *message = nil;
        
        if (sender == ReplyTextLeftSender) {
            message = [self.rightSenderMessages lastObject];
        } else {
            message = [self.leftSenderMessages lastObject];
        }
        
        message.date = [NSDate date];
        message.context = str;
        message.rowID = nil;
        [replys addObject:[[NSArray alloc]initWithObjects:message, nil]];
    }

    if (self.replyTextPreference == NormalReply) {
        return [NSArray arrayWithArray:[replys objectAtIndex:arc4random() % replys.count]];
    } else if (self.replyTextPreference == SingleReply) {
        return [NSArray arrayWithArray:[[replys objectAtIndex:arc4random() % replys.count] objectAtIndex:0]];
    } else if (self.replyTextPreference == AllPossibleReply) {
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSArray *array in replys) for (Message *message in array) [tmp addObject:message];
        return tmp;
    }
    
    return nil;
}

- (Message *)replyAnyObjectWithSender:(ReplyTextSender)sender
{
    if (sender == ReplyTextLeftSender) {
        return [self.leftSenderMessages objectAtIndex:rand() % self.leftSenderMessages.count];
    } else {
        return [self.rightSenderMessages objectAtIndex:rand() % self.rightSenderMessages.count];
    }
}

@end
