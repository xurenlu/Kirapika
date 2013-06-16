//
//  ChatViewController.h
//  Kirapika
//
//  Created by Justin Jia on 1/19/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "CoreDataMessagesViewController.h"
#import "SenderSwitch.h"

@interface ChatViewController : CoreDataMessagesViewController <ToggleViewDelegate>

@property (strong, nonatomic) IBOutlet SenderSwitch *senderSwitch;

@end