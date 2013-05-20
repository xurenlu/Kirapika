//
//  FilesManagement.m
//  Kirapika
//
//  Created by Justin Jia on 5/15/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import "FilesManagement.h"

@implementation FilesManagement

+ (NSURL *)documentDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
}

+ (NSArray *)fileURLsInDocumentDirectory
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[self documentDirectory] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
}

+ (BOOL)importDatabase:(NSURL *)resourceURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [resourceURL lastPathComponent];
    BOOL isRightType = [[fileName pathExtension] isEqualToString:DATABASE_TYPE];
    NSURL *dic = [[[self documentDirectory] URLByAppendingPathComponent:[[resourceURL URLByDeletingPathExtension] lastPathComponent]] URLByAppendingPathComponent:@"StoreContent"];
    if (isRightType && [fileManager fileExistsAtPath:[resourceURL path]] && ![fileManager fileExistsAtPath:[dic path]]) {
        NSURL *url = [dic URLByAppendingPathComponent:@"persistentStore"];
        if ([fileManager createDirectoryAtURL:dic withIntermediateDirectories:YES attributes:nil error:nil])
            return [fileManager moveItemAtURL:resourceURL toURL:url error:nil];
    }
    return NO;
}

+ (BOOL)importPlist:(NSURL *)resourceURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [resourceURL lastPathComponent];
    BOOL isRightType = [[fileName pathExtension] isEqualToString:PLIST_TYPE];
        
    NSURL *url = [[[self documentDirectory] URLByAppendingPathComponent:[[resourceURL URLByDeletingPathExtension] lastPathComponent]] URLByAppendingPathExtension:@"plist"];
    if (isRightType && [fileManager fileExistsAtPath:[resourceURL path]] && ![fileManager fileExistsAtPath:[url path]]) {
        return [fileManager moveItemAtURL:resourceURL toURL:url error:nil];
    }
    return NO;
}

+ (BOOL)removeDatabaseFromDocumentDirectory:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isRightType = [[fileName pathExtension] isEqualToString:DATABASE_TYPE];
    NSURL *dic = [[[self documentDirectory] URLByAppendingPathComponent:fileName] URLByDeletingPathExtension];
    if (isRightType) return [fileManager removeItemAtURL:dic error:nil];
    return NO;
}

+ (BOOL)removePlistFromDocumentDirectory:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isRightType = [[fileName pathExtension] isEqualToString:PLIST_TYPE];
    NSURL *dic = [[[[self documentDirectory] URLByAppendingPathComponent:fileName] URLByDeletingPathExtension] URLByAppendingPathExtension:@"plist"];
    if (isRightType) return [fileManager removeItemAtURL:dic error:nil];
    return NO;
}

@end
