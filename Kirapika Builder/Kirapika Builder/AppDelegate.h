//
//  AppDelegate.h
//  Kirapika Builder
//
//  Created by Justin Jia on 5/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSTextField *info;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *inputPath;
@property (weak) IBOutlet NSTextField *outputPath;

- (IBAction)chooseButtonTapped:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
