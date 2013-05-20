//
//  UserDefaultsKeys.h
//  Kirapika
//
//  Created by Justin Jia on 5/16/13.
//  Copyright (c) 2013 Justin Jia. All rights reserved.
//

#ifndef Kirapika_UserDefaultsKeys_h
#define Kirapika_UserDefaultsKeys_h

#define IMPORT_DATABASE_PATH @"import database path key"
#define IMPORT_PLIST_PATH @"import plist path key"

#define CURRENT_DATABASE_PATH @"current database path key"
#define CURRENT_PLIST_PATH @"current plist path key"

#define MESSAGES_ARRAY_KEY [NSString stringWithFormat:@"messages array key %@", NSStringFromClass([self class])]
#define CURRENT_SENDER_KEY [NSString stringWithFormat:@"is left user bool key %@", NSStringFromClass([self class])]
#define DATA_LIMIT_NUMBER_KEY [NSString stringWithFormat:@"data limit number %@", NSStringFromClass([self class])]
#define DATA_LIMIT_NUMBER_DEFAULT 5000
#define CURRENT_SECTION_INDEX_KEY [NSString stringWithFormat:@"current section index %@", NSStringFromClass([self class])]

#endif
