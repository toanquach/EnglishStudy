//
//  Song.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Song : NSObject
{
    sqlite3*  database;
}

@property(nonatomic) int tblID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *des;
@property(nonatomic) int num_view;
@property(nonatomic) int category_id;
@property(nonatomic) int singer_id;
@property(nonatomic, retain) NSString *english;
@property(nonatomic, retain) NSString *vietnamese;
@property(nonatomic, retain) NSString *explanation;
@property(nonatomic) int done;

// ---------------------------
//      Method
//
- (NSString *)insert:(sqlite3 *)db;
- (NSString*)update:(sqlite3*)db;
- (NSMutableArray*)getSong:(sqlite3*)db;
- (NSMutableArray*)getSongByCategoryId:(sqlite3*)db;
- (NSMutableArray*)getSongBySingerId:(sqlite3*)db;
- (Song *)getSongById:(sqlite3*)db;
- (NSMutableArray *)searchSong:(sqlite3*)db WithText:(NSString *)keyword;
@end
