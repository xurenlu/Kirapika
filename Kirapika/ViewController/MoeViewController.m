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

@property (nonatomic, strong) NSUserDefaults *userDefaults;
- (void)openURL:(NSNotification *)aNotification;
- (BOOL)importDatabase:(NSURL *)url;
- (BOOL)importPlist:(NSURL *)url;
- (BOOL)removeDatabaseFromDocumentDictionary:(NSString *)name;
- (BOOL)removePlistFromDocumentDictionary:(NSString *)name;

@end

@implementation MoeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.status.text = @"nothing happened";    
}

- (void)openURL:(NSNotification *)aNotification
{
    NSURL *url = aNotification.object;
    
    if ([url.pathExtension isEqualToString:PLIST_TYPE]) {
        [self importPlist:url];
    } else if ([url.pathExtension isEqualToString:DATABASE_TYPE]) {
        [self importDatabase:url];
    }
}

- (IBAction)importButtonTapped:(id)sender
{
    NSURL *url = [[FilesManagement documentDirectory] URLByAppendingPathComponent:self.importFileName.text];
    if ([[url pathExtension] isEqualToString:DATABASE_TYPE]) {
        [self importDatabase:url];
    } else if ([[url pathExtension] isEqualToString:PLIST_TYPE]) {
        [self importPlist:url];
    } else {
        self.status.text = @"wrong file type!";
    }
}

- (IBAction)clearButtonTapped:(id)sender
{
    if (![self removeDatabaseFromDocumentDictionary:self.importFileName.text])
        [self removePlistFromDocumentDictionary:self.importFileName.text];
}

- (BOOL)importDatabase:(NSURL *)url
{
    NSString *name = [[url URLByDeletingPathExtension] lastPathComponent];
    BOOL succeed = [FilesManagement importDatabase:url];
    if (succeed) {
        [self.userDefaults setValue:name forKey:CURRENT_DATABASE_PATH];
        self.status.text = [NSString stringWithFormat:@"successfully import %@",name];
        return YES;
    } else {
        self.status.text = @"failed";
    }
    return NO;
}

- (BOOL)importPlist:(NSURL *)url
{
    NSString *name = [[url URLByDeletingPathExtension] lastPathComponent];
    BOOL succeed = [FilesManagement importPlist:url];
    if (succeed) {
        [self.userDefaults setValue:name forKey:CURRENT_PLIST_PATH];
        self.status.text = [NSString stringWithFormat:@"successfully import %@",name];
        return YES;
    } else {
        self.status.text = @"failed";
    }
    return NO;
}

- (BOOL)removeDatabaseFromDocumentDictionary:(NSString *)name
{
    if (name) {
        BOOL succeed = [FilesManagement removeDatabaseFromDocumentDirectory:name];
        if (succeed) {
            [self.userDefaults setValue:nil forKey:CURRENT_DATABASE_PATH];
            self.status.text = [NSString stringWithFormat:@"successfully remove %@",name];
            return YES;
        } else {
            self.status.text = @"failed";
        }
    }
    return NO;
}

- (BOOL)removePlistFromDocumentDictionary:(NSString *)name
{
    if (name) {
        BOOL succeed = [FilesManagement removePlistFromDocumentDirectory:name];
        if (succeed) {
            [self.userDefaults setValue:nil forKey:CURRENT_PLIST_PATH];
            self.status.text = [NSString stringWithFormat:@"successfully remove %@",name];
            return YES;
        } else {
            self.status.text = @"failed";
        }
    }
    return NO;
}

- (NSUserDefaults *)userDefaults
{
    if (!_userDefaults) _userDefaults = [NSUserDefaults standardUserDefaults];
    return _userDefaults;
}

#pragma mark - Unload
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"openURLNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _userDefaults = nil;
}

@end
