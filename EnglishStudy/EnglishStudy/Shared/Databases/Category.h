//
//  Category.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/19/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Category : NSObject
{
    sqlite3*  database;
}

@property(nonatomic) int tblID;
@property(nonatomic, retain) NSString *name;
@property(nonatomic) int num_song;

- (NSString *)insert:(sqlite3 *)db;
- (NSString*)update:(sqlite3*)db;
- (NSMutableArray*)getCategory:(sqlite3*)db;
- (Category *)getCategoryById:(sqlite3*)db;

@end
