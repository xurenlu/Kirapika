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
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
}

+ (NSArray *)fileURLsInDocumentDirectory
{
    return [self fileURLs:[self documentDirectory] options:NSDirectoryEnumerationSkipsSubdirectoryDescendants];
}

+ (NSArray *)fileURLs:(NSURL *)url options:(NSDirectoryEnumerationOptions)options
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:options error:nil];
}

+ (BOOL)importDatabase:(NSURL *)resourceURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[resourceURL URLByDeletingPathExtension] lastPathComponent];
    NSURL *dic = [[[self documentDirectory] URLByAppendingPathComponent:fileName] URLByAppendingPathComponent:@"StoreContent"];
    if ([fileManager fileExistsAtPath:resourceURL.path] && ![fileManager fileExistsAtPath:dic.path])
        if ([fileManager createDirectoryAtURL:dic withIntermediateDirectories:YES attributes:nil error:nil])
            return [fileManager moveItemAtURL:resourceURL toURL:[dic URLByAppendingPathComponent:@"persistentStore"] error:nil];
    return NO;
}

+ (BOOL)importPlist:(NSURL *)resourceURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[[resourceURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"plist"] lastPathComponent];
    NSURL *url = [[self documentDirectory] URLByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:resourceURL.path] && ![fileManager fileExistsAtPath:url.path])
        return [fileManager moveItemAtURL:resourceURL toURL:url error:nil];
    return NO;
}

+ (BOOL)removeFileFromDocumentDirectory:(NSString *)fileName
{
    return [self removeFile:[[self documentDirectory] URLByAppendingPathComponent:fileName]];
}

+ (BOOL)removeFile:(NSURL *)url
{
    return [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
}

@end
