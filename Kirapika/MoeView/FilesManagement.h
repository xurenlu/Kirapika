//
//  FilesManagement.h
//  Kirapika
//
//  Created by Justin Jia on 5/15/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_TYPE @"kpdatabase"
#define PLIST_TYPE @"kplist"

@interface FilesManagement : NSObject

+ (NSURL *)documentDirectory;
+ (NSArray *)fileURLsInDocumentDirectory;

+ (BOOL)importDatabase:(NSURL *)resourceURL;
+ (BOOL)importPlist:(NSURL *)resourceURL;
+ (BOOL)removeDatabaseFromDocumentDirectory:(NSString *)fileName;
+ (BOOL)removePlistFromDocumentDirectory:(NSString *)fileName;

@end
