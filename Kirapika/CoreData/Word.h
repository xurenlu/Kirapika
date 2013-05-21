//
//  WordLibrary.h
//  Kirapika
//
//  Created by Justin Jia on 5/21/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * org;
@property (nonatomic, retain) NSString * trans;

@end
