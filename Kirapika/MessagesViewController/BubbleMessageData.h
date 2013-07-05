//
//  BubbleMessageData.h
//  Kirapika
//
//  Created by Justin Jia on 3/24/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

@interface BubbleMessageData : NSObject <NSCoding>

typedef enum {
    BubbleMessageStyleRightSender = 0,
    BubbleMessageStyleLeftSender = 1
} BubbleMessageStyle;

@property (nonatomic, strong) NSString *bubbleContext;
@property (nonatomic, strong) NSDate *bubbleDate;
@property (nonatomic) BubbleMessageStyle bubbleCurrentSender;

@end
