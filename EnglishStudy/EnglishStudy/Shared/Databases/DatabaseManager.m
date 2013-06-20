//
//  DatabaseManager.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/19/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "DatabaseManager.h"

@interface DatabaseManager()

- (void) createEditableCopyOfDataBaseIfNeeded;
- (NSString *) getDBPath;

@end

@implementation DatabaseManager

+ (DatabaseManager *)sharedDatabaseManager
{
    static dispatch_once_t once;
    static DatabaseManager *_sharedDatabaseManager = nil;
    dispatch_once(&once, ^
      {
          
          _sharedDatabaseManager = [[DatabaseManager alloc] init];
          
      });
    
    return _sharedDatabaseManager;
}

- (id)init
{
    self = [super init];
	if(self)
	{
        [self createEditableCopyOfDataBaseIfNeeded];
		NSString *path = [self getDBPath];
		NSLog(@"%@",path);
		if(sqlite3_open([path UTF8String], &database)==SQLITE_OK)
		{
			NSLog(@"Database Connected");
		}
		else
        {
			sqlite3_close(database);
			NSLog(@"Failed to opend database");
		}
		
	}
	return self;
}

- (void) createEditableCopyOfDataBaseIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success)
    {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDabase_Name];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) getDBPath
{
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	//NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *cacheDir = LIBRARY_CATCHES_DIRECTORY;
    NSLog(@"%@",cacheDir);
	return [cacheDir stringByAppendingPathComponent:kDabase_Name];
}

@end
