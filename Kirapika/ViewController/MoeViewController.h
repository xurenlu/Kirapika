//
//  MoeViewController.h
//  Kirapika
//
//  Created by Justin Jia on 1/19/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "ViewController.h"

@interface MoeViewController : UIViewController

- (IBAction)importButtonTapped:(id)sender;
- (IBAction)clearButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UITextField *importFileName;

@end
