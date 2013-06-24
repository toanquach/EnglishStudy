//
//  Singer.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Singer : NSObject
{
    sqlite3*  database;
}

// --------------------------
//      Property
//
@property(nonatomic) int tblID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *url;
@property(nonatomic) int num_view;
@property(nonatomic) int num_song;
// ---------------------------
//      Method
//
- (NSString *)insert:(sqlite3 *)db;
- (NSString*)update:(sqlite3*)db;
- (NSMutableArray*)getSinger:(sqlite3*)db;
- (Singer *)getSingerById:(sqlite3*)db;

@end
