//
//  MessagesTableView.h
//  Kirapika
//
//  Created by Justin Jia on 4/14/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesTableView : UITableView

- (void)reloadDataWithAutoScrolling;
- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)scrollToBottomAnimated:(BOOL)animated;

@end
