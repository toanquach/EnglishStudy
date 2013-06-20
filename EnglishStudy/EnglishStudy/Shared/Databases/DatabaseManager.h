//
//  DatabaseManager.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/19/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject
{
    sqlite3 * database;
}

+ (DatabaseManager *)sharedDatabaseManager;

@end
