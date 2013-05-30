//
//  MoeViewController.h
//  Kirapika
//
//  Created by Justin Jia on 1/19/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ViewController.h"

@interface MoeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *status;
- (void)openURL:(NSNotification *)aNotification;
- (IBAction)clearButtonTapped:(id)sender;

@end
