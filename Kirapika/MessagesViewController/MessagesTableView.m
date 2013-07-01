//
//  MessagesTableView.m
//  Kirapika
//
//  Created by Justin Jia on 4/14/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "MessagesTableView.h"

@interface MessagesTableView()

- (void)setup;

@end

@implementation MessagesTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)reloadDataWithAutoScrolling
{
    [super reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [super insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
    [self scrollToBottomAnimated:YES];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self scrollToBottomAnimated:YES];
}

- (void)deleteRowAtIndexPath:(NSArray *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [super deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
    [self scrollToBottomAnimated:YES];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    [self scrollToBottomAnimated:YES];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger s = [self numberOfSections];
    if (s<1) return;
    NSInteger r = [self numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [self scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

@end
