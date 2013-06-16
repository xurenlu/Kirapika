//
//  BubbleTypingCell.h
//  Kirapika
//
//  Created by Justin Jia on 5/31/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "BubbleView.h"

@interface BubbleTypingCell : UITableViewCell

- (void)setStyle:(BubbleMessageStyle)style;
- (id)initWithBubbleStyle:(BubbleMessageStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
+ (CGFloat)height;

@end
