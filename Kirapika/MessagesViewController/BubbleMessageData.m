//
//  BubbleMessageData.m
//  kirakira pikapika
//
//  Created by Justin Jia on 3/24/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "BubbleMessageData.h"

@interface BubbleMessageData()

@end

@implementation BubbleMessageData

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _bubbleContext = [aDecoder decodeObjectForKey:@"contextCoder"];
        _bubbleDate = [aDecoder decodeObjectForKey:@"dateCoder"];
        _bubbleCurrentSender = [[aDecoder decodeObjectForKey:@"whoSentCoder"] boolValue] ? BubbleMessageStyleLeftSender : BubbleMessageStyleRightSender;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_bubbleContext forKey:@"contextCoder"];
    [aCoder encodeObject:_bubbleDate forKey:@"dateCoder"];
    [aCoder encodeObject:[NSNumber numberWithBool:_bubbleCurrentSender] forKey:@"whoSentCoder"];
}

@end
