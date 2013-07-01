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

@property (strong, nonatomic) NSUserDefaults *userDefaults;
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
        [self.userDefaults setValue:[[[url URLByDeletingPathExtension] URLByAppendingPathExtension:@"plist"] lastPathComponent] forKey:CURRENT_PLIST_NAME];
    } else if ([url.pathExtension isEqualToString:DATABASE_TYPE]) {
        [self removeDatabase];
        [FilesManagement importDatabase:url];
        [self.userDefaults setValue:[[url URLByDeletingPathExtension] lastPathComponent] forKey:CURRENT_DATABASE_NAME];
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
    [self.userDefaults setValue:nil forKey:CURRENT_PLIST_NAME];
}

- (void)removeDatabase
{
    [FilesManagement removeFileFromDocumentDirectory:CURRENT_DATABASE_NAME];
    [self.userDefaults setValue:nil forKey:CURRENT_DATABASE_NAME];
}

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) _userDefaults = [NSUserDefaults standardUserDefaults];
    return _userDefaults;
}

#pragma mark - Unload
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPEN_URL_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setUserDefaults:nil];
}

@end
