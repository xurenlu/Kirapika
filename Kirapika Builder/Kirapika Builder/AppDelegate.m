//
//  AppDelegate.m
//  Kirapika Builder
//
//  Created by Justin Jia on 5/22/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataConstants.h"
#import "TBXML.h"
#import "NSString+Transcode.h"

@interface AppDelegate()

@property (nonatomic) int rowID;
- (void)load;

@end

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)chooseButtonTapped:(id)sender
{
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    
    NSArray *fileTypesArray = [NSArray arrayWithObjects:@"xml", nil];
    
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:NO];
    
    if (openDlg.runModal == NSOKButton) {
        self.inputPath.stringValue = openDlg.URL.path;
        self.outputPath.stringValue = [[[[openDlg URL] URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite"] path];
        [self load];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (void)load
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.inputPath.stringValue]];
    TBXML *tbxml = [[TBXML alloc]initWithXMLData:data error:nil];
    
    // Obtain root element
    TBXMLElement *root = tbxml.rootXMLElement;
    
    // If TBXML found a root node, process element and iterate all children
    if (root) {
        // search for the first author element within the root element's children
        TBXMLElement *message = [TBXML childElementNamed:@"message" parentElement:root error:nil];
        while (message) {
            NSString *messageContext = [TBXML textForElement:[TBXML childElementNamed:@"text" parentElement:message]];
            NSString *messageContextTrans = [messageContext transcode:self.managedObjectContext save:YES];
            NSNumber *rowID = [NSNumber numberWithInt:self.rowID];
#warning wrong Date
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[TBXML textForElement:[TBXML childElementNamed:@"date" parentElement:message]] intValue]];
            BOOL isLeftUser = [[TBXML textForElement:[TBXML childElementNamed:@"is_from_me" parentElement:message]] intValue];
#warning data
            NSString *senderName = isLeftUser ? @"LEFT_SENDER_NAME" : @"RIGHT_SENDER_NAME";
            NSString *senderURL = isLeftUser ? @"LEFT_SENDER_URL" : @"RIGHT_SENDER_URL";
            
            NSMutableDictionary *anMessageDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 messageContext, MESSAGE_CONTEXT,
                                                 messageContextTrans, MESSAGE_CONTEXT_TRANS,
                                                 date, MESSAGE_DATE,
                                                 rowID, MESSAGE_ROW_ID,
                                                 senderName, SENDER_NAME,
                                                 senderURL, SENDER_PHOTOURL,
                                                 isLeftUser, SENDER_IS_LEFT_USER, nil];
            
            [Message messageWithData:anMessageDic inManagedObjectContext:self.managedObjectContext];
            
            message = [TBXML nextSiblingNamed:@"message" searchFromElement:message];
            NSLog(@"%d", rowID.intValue);
        }
    }
    
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"Error while saving");
    }
    
    //rename
    NSURL *oldURL = [NSURL fileURLWithPath:self.outputPath.stringValue];
    NSURL *newURL = [[oldURL URLByDeletingPathExtension] URLByAppendingPathComponent:@"kpdatabase"];
    
    [[NSFileManager defaultManager] moveItemAtURL:oldURL toURL:newURL error:nil];
    
    NSLog(@"Finished.");
}

#pragma mark - Data
// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "Jacinth.Kirapika_Builder" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"Jacinth.Kirapika_Builder"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"kirakira pikapika" withExtension:@"momd"];
#warning buggy
//    NSURL *modelURL = [NSURL fileURLWithPath:[[self.outputPath.stringValue stringByDeletingPathExtension] stringByAppendingPathExtension:@"momd"]];
    NSLog(@"%@",modelURL);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
//    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"kirapika_Builder.storedata"];
    NSURL *url = [NSURL fileURLWithPath:self.outputPath.stringValue];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

- (int)rowID
{
    _rowID++;
    return _rowID;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

#pragma mark - Terminate
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        
        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}

@end
