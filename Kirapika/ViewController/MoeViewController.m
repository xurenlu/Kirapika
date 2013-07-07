//
//  MoeViewController.m
//  Kirapika
//
//  Created by Justin Jia on 1/19/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "MoeViewController.h"
#import "FilesManagement.h"
#import "UserDefaultsKeys.h"

@interface MoeViewController ()

- (void)removePlist;
- (void)removeDatabase;

@end

@implementation MoeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)openURL:(NSNotification *)aNotification
{
    NSURL *url = aNotification.object;
    if ([url.pathExtension isEqualToString:PLIST_TYPE]) {
        [self removePlist];
        [FilesManagement importPlist:url];
        [[NSUserDefaults standardUserDefaults] setValue:[[[url URLByDeletingPathExtension] URLByAppendingPathExtension:@"plist"] lastPathComponent] forKey:CURRENT_PLIST_NAME];
    } else if ([url.pathExtension isEqualToString:DATABASE_TYPE]) {
        [self removeDatabase];
        [FilesManagement importDatabase:url];
        [[NSUserDefaults standardUserDefaults] setValue:[[url URLByDeletingPathExtension] lastPathComponent] forKey:CURRENT_DATABASE_NAME];
    }
    self.status.text = NSLocalizedString(@"imported", @"setting view status");
}

- (IBAction)clearButtonTapped:(id)sender
{
    [self removeFiles];
    self.status.text = NSLocalizedString(@"cleared", @"setting view status");
}

- (void)removeFiles
{
    [self removePlist];
    [self removeDatabase];
}

- (void)removePlist
{
    [FilesManagement removeFileFromDocumentDirectory:CURRENT_PLIST_NAME];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:CURRENT_PLIST_NAME];
}

- (void)removeDatabase
{
    [FilesManagement removeFileFromDocumentDirectory:CURRENT_DATABASE_NAME];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:CURRENT_DATABASE_NAME];
}

#pragma mark - Unload
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPEN_URL_NOTIFICATION object:nil];
    [super viewDidDisappear:animated];
}

@end
