//
//  Song.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize tblID, name, des, num_view, category_id, singer_id, english, vietnamese, explanation, done;

//static sqlite3_stmt *insert_statement=nil;
//static sqlite3_stmt* update_statement=nil;
static sqlite3_stmt* select_statement = nil;
//static sqlite3_stmt* delete_statement = nil;

- (NSString *)insert:(sqlite3 *)db
{
    return @"";
}

- (NSString*)update:(sqlite3*)db
{
    return @"";
}

- (NSMutableArray*)getSong:(sqlite3*)db
{
    database = db;
    NSString * query;
    NSMutableArray *list = [NSMutableArray array];
    query = @"SELECT * FROM song_encode LIMIT 50";
    
   // NSLog(@"%@", query);
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
    }
    
    while(sqlite3_step(select_statement)==SQLITE_ROW)
    {
        Song *song = [[Song alloc] init];
        const unsigned char* mTblID = sqlite3_column_text(select_statement, 0);
        if (mTblID == NULL)
        {
            song.tblID = -1;
        }
        else
        {
            song.tblID = [[NSString stringWithUTF8String:(const char*)mTblID] intValue];
        }
        
        const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
        if (nameChars==NULL)
        {
            song.name = @"";
        }
        else
        {
            song.name = [NSString stringWithUTF8String:(const char*)nameChars];
        }
        
        const unsigned char* desChars = sqlite3_column_text(select_statement, 2);
        if (desChars==NULL)
        {
            song.des = @"";
        }
        else
        {
            song.des = [NSString stringWithUTF8String:(const char*)desChars];
        }
        
        const unsigned char *numChars = sqlite3_column_text(select_statement, 3);
        if (numChars==NULL)
        {
            song.num_view = 0;
        }
        else
        {
            song.num_view = [[NSString stringWithUTF8String:(const char*)numChars] intValue];
        }
        
        const unsigned char *cateIdChars = sqlite3_column_text(select_statement, 4);
        if (cateIdChars==NULL)
        {
            song.category_id = 0;
        }
        else
        {
            song.category_id = [[NSString stringWithUTF8String:(const char*)cateIdChars] intValue];
        }
        
        const unsigned char *singerIdChars = sqlite3_column_text(select_statement, 5);
        if (singerIdChars == NULL)
        {
            song.singer_id = 0;
        }
        else
        {
            song.singer_id = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        const unsigned char* engChars = sqlite3_column_text(select_statement, 6);
        if (engChars==NULL)
        {
            song.english = @"";
        }
        else
        {
            song.english = [NSString stringWithUTF8String:(const char*)engChars];
        }
        
        const unsigned char* vnChars = sqlite3_column_text(select_statement, 7);
        if (vnChars==NULL)
        {
            song.vietnamese = @"";
        }
        else
        {
            song.vietnamese = [NSString stringWithUTF8String:(const char*)vnChars];
        }
        
        const unsigned char* explanationChars = sqlite3_column_text(select_statement, 8);
        if (explanationChars == NULL)
        {
            song.explanation = @"";
        }
        else
        {
            song.explanation = [NSString stringWithUTF8String:(const char*)explanationChars];
        }
        
        const unsigned char *doneChars = sqlite3_column_text(select_statement, 9);
        if (doneChars == NULL)
        {
            song.done = 0;
        }
        else
        {
            song.done = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        [list addObject:song];
        song = nil;
    }
    
    sqlite3_finalize(select_statement);
    
    return list;
}

- (NSMutableArray*)getSongByCategoryId:(sqlite3*)db
{
    database = db;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM song_encode where category_id=%d",self.category_id];
    NSMutableArray *list = [NSMutableArray array];
    
    //NSLog(@"%@", query);
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
    }
    
    while(sqlite3_step(select_statement)==SQLITE_ROW)
    {
        Song *song = [[Song alloc] init];
        const unsigned char* mTblID = sqlite3_column_text(select_statement, 0);
        if (mTblID == NULL)
        {
            song.tblID = -1;
        }
        else
        {
            song.tblID = [[NSString stringWithUTF8String:(const char*)mTblID] intValue];
        }
        
        const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
        if (nameChars==NULL)
        {
            song.name = @"";
        }
        else
        {
            song.name = [NSString stringWithUTF8String:(const char*)nameChars];
        }
        
        const unsigned char* desChars = sqlite3_column_text(select_statement, 2);
        if (desChars==NULL)
        {
            song.des = @"";
        }
        else
        {
            song.des = [NSString stringWithUTF8String:(const char*)desChars];
        }
        
        const unsigned char *numChars = sqlite3_column_text(select_statement, 3);
        if (numChars==NULL)
        {
            song.num_view = 0;
        }
        else
        {
            song.num_view = [[NSString stringWithUTF8String:(const char*)numChars] intValue];
        }
        
        const unsigned char *cateIdChars = sqlite3_column_text(select_statement, 4);
        if (cateIdChars==NULL)
        {
            song.category_id = 0;
        }
        else
        {
            song.category_id = [[NSString stringWithUTF8String:(const char*)cateIdChars] intValue];
        }
        
        const unsigned char *singerIdChars = sqlite3_column_text(select_statement, 5);
        if (singerIdChars == NULL)
        {
            song.singer_id = 0;
        }
        else
        {
            song.singer_id = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        const unsigned char* engChars = sqlite3_column_text(select_statement, 6);
        if (engChars==NULL)
        {
            song.english = @"";
        }
        else
        {
            song.english = [NSString stringWithUTF8String:(const char*)engChars];
        }
        
        const unsigned char* vnChars = sqlite3_column_text(select_statement, 7);
        if (vnChars==NULL)
        {
            song.vietnamese = @"";
        }
        else
        {
            song.vietnamese = [NSString stringWithUTF8String:(const char*)vnChars];
        }
        
        const unsigned char* explanationChars = sqlite3_column_text(select_statement, 8);
        if (explanationChars == NULL)
        {
            song.explanation = @"";
        }
        else
        {
            song.explanation = [NSString stringWithUTF8String:(const char*)explanationChars];
        }
        
        const unsigned char *doneChars = sqlite3_column_text(select_statement, 9);
        if (doneChars == NULL)
        {
            song.done = 0;
        }
        else
        {
            song.done = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        [list addObject:song];
        song = nil;
    }
    
    sqlite3_finalize(select_statement);
    
    return list;
}

- (NSMutableArray*)getSongBySingerId:(sqlite3*)db
{
    database = db;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM song_encode where singer_id=%d",self.singer_id];
    NSMutableArray *list = [NSMutableArray array];
    
    //NSLog(@"%@", query);
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
    }
    
    while(sqlite3_step(select_statement)==SQLITE_ROW)
    {
        Song *song = [[Song alloc] init];
        const unsigned char* mTblID = sqlite3_column_text(select_statement, 0);
        if (mTblID == NULL)
        {
            song.tblID = -1;
        }
        else
        {
            song.tblID = [[NSString stringWithUTF8String:(const char*)mTblID] intValue];
        }
        
        const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
        if (nameChars==NULL)
        {
            song.name = @"";
        }
        else
        {
            song.name = [NSString stringWithUTF8String:(const char*)nameChars];
        }
        
        const unsigned char* desChars = sqlite3_column_text(select_statement, 2);
        if (desChars==NULL)
        {
            song.des = @"";
        }
        else
        {
            song.des = [NSString stringWithUTF8String:(const char*)desChars];
        }
        
        const unsigned char *numChars = sqlite3_column_text(select_statement, 3);
        if (numChars==NULL)
        {
            song.num_view = 0;
        }
        else
        {
            song.num_view = [[NSString stringWithUTF8String:(const char*)numChars] intValue];
        }
        
        const unsigned char *cateIdChars = sqlite3_column_text(select_statement, 4);
        if (cateIdChars==NULL)
        {
            song.category_id = 0;
        }
        else
        {
            song.category_id = [[NSString stringWithUTF8String:(const char*)cateIdChars] intValue];
        }
        
        const unsigned char *singerIdChars = sqlite3_column_text(select_statement, 5);
        if (singerIdChars == NULL)
        {
            song.singer_id = 0;
        }
        else
        {
            song.singer_id = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        const unsigned char* engChars = sqlite3_column_text(select_statement, 6);
        if (engChars==NULL)
        {
            song.english = @"";
        }
        else
        {
            song.english = [NSString stringWithUTF8String:(const char*)engChars];
        }
        
        const unsigned char* vnChars = sqlite3_column_text(select_statement, 7);
        if (vnChars==NULL)
        {
            song.vietnamese = @"";
        }
        else
        {
            song.vietnamese = [NSString stringWithUTF8String:(const char*)vnChars];
        }
        
        const unsigned char* explanationChars = sqlite3_column_text(select_statement, 8);
        if (explanationChars == NULL)
        {
            song.explanation = @"";
        }
        else
        {
            song.explanation = [NSString stringWithUTF8String:(const char*)explanationChars];
        }
        
        const unsigned char *doneChars = sqlite3_column_text(select_statement, 9);
        if (doneChars == NULL)
        {
            song.done = 0;
        }
        else
        {
            song.done = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        [list addObject:song];
        song = nil;
    }
    
    sqlite3_finalize(select_statement);
    
    return list;
}


- (Song *)getSongById:(sqlite3*)db
{
    database = db;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM song_encode where id=%d",self.tblID];
    
    //NSLog(@"%@", query);
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
    }
    
    Song *song = [[Song alloc] init];
    
    while(sqlite3_step(select_statement)==SQLITE_ROW)
    {
        const unsigned char* mTblID = sqlite3_column_text(select_statement, 0);
        if (mTblID == NULL)
        {
            song.tblID = -1;
        }
        else
        {
            song.tblID = [[NSString stringWithUTF8String:(const char*)mTblID] intValue];
        }
        
        const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
        if (nameChars==NULL)
        {
            song.name = @"";
        }
        else
        {
            song.name = [NSString stringWithUTF8String:(const char*)nameChars];
        }
        
        const unsigned char* desChars = sqlite3_column_text(select_statement, 2);
        if (desChars==NULL)
        {
            song.des = @"";
        }
        else
        {
            song.des = [NSString stringWithUTF8String:(const char*)desChars];
        }
        
        const unsigned char *numChars = sqlite3_column_text(select_statement, 3);
        if (numChars==NULL)
        {
            song.num_view = 0;
        }
        else
        {
            song.num_view = [[NSString stringWithUTF8String:(const char*)numChars] intValue];
        }
        
        const unsigned char *cateIdChars = sqlite3_column_text(select_statement, 4);
        if (cateIdChars==NULL)
        {
            song.category_id = 0;
        }
        else
        {
            song.category_id = [[NSString stringWithUTF8String:(const char*)cateIdChars] intValue];
        }
        
        const unsigned char *singerIdChars = sqlite3_column_text(select_statement, 5);
        if (singerIdChars == NULL)
        {
            song.singer_id = 0;
        }
        else
        {
            song.singer_id = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        const unsigned char* engChars = sqlite3_column_text(select_statement, 6);
        if (engChars==NULL)
        {
            song.english = @"";
        }
        else
        {
            song.english = [NSString stringWithUTF8String:(const char*)engChars];
        }
        
        const unsigned char* vnChars = sqlite3_column_text(select_statement, 7);
        if (vnChars==NULL)
        {
            song.vietnamese = @"";
        }
        else
        {
            song.vietnamese = [NSString stringWithUTF8String:(const char*)vnChars];
        }
        
        const unsigned char* explanationChars = sqlite3_column_text(select_statement, 8);
        if (explanationChars == NULL)
        {
            song.explanation = @"";
        }
        else
        {
            song.explanation = [NSString stringWithUTF8String:(const char*)explanationChars];
        }
        
        const unsigned char *doneChars = sqlite3_column_text(select_statement, 9);
        if (doneChars == NULL)
        {
            song.done = 0;
        }
        else
        {
            song.done = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
    }
    
    sqlite3_finalize(select_statement);
    
    return song;
}

- (NSMutableArray *)searchSong:(sqlite3*)db WithText:(NSString *)keyword
{
    database = db;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM song_encode where name LIKE '%%%@%%'",keyword];
    NSMutableArray *list = [NSMutableArray array];
    
    //NSLog(@"%@", query);
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
    }
    
    while(sqlite3_step(select_statement)==SQLITE_ROW)
    {
        Song *song = [[Song alloc] init];
        const unsigned char* mTblID = sqlite3_column_text(select_statement, 0);
        if (mTblID == NULL)
        {
            song.tblID = -1;
        }
        else
        {
            song.tblID = [[NSString stringWithUTF8String:(const char*)mTblID] intValue];
        }
        
        const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
        if (nameChars==NULL)
        {
            song.name = @"";
        }
        else
        {
            song.name = [NSString stringWithUTF8String:(const char*)nameChars];
        }
        
        const unsigned char* desChars = sqlite3_column_text(select_statement, 2);
        if (desChars==NULL)
        {
            song.des = @"";
        }
        else
        {
            song.des = [NSString stringWithUTF8String:(const char*)desChars];
        }
        
        const unsigned char *numChars = sqlite3_column_text(select_statement, 3);
        if (numChars==NULL)
        {
            song.num_view = 0;
        }
        else
        {
            song.num_view = [[NSString stringWithUTF8String:(const char*)numChars] intValue];
        }
        
        const unsigned char *cateIdChars = sqlite3_column_text(select_statement, 4);
        if (cateIdChars==NULL)
        {
            song.category_id = 0;
        }
        else
        {
            song.category_id = [[NSString stringWithUTF8String:(const char*)cateIdChars] intValue];
        }
        
        const unsigned char *singerIdChars = sqlite3_column_text(select_statement, 5);
        if (singerIdChars == NULL)
        {
            song.singer_id = 0;
        }
        else
        {
            song.singer_id = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        const unsigned char* engChars = sqlite3_column_text(select_statement, 6);
        if (engChars==NULL)
        {
            song.english = @"";
        }
        else
        {
            song.english = [NSString stringWithUTF8String:(const char*)engChars];
        }
        
        const unsigned char* vnChars = sqlite3_column_text(select_statement, 7);
        if (vnChars==NULL)
        {
            song.vietnamese = @"";
        }
        else
        {
            song.vietnamese = [NSString stringWithUTF8String:(const char*)vnChars];
        }
        
        const unsigned char* explanationChars = sqlite3_column_text(select_statement, 8);
        if (explanationChars == NULL)
        {
            song.explanation = @"";
        }
        else
        {
            song.explanation = [NSString stringWithUTF8String:(const char*)explanationChars];
        }
        
        const unsigned char *doneChars = sqlite3_column_text(select_statement, 9);
        if (doneChars == NULL)
        {
            song.done = 0;
        }
        else
        {
            song.done = [[NSString stringWithUTF8String:(const char*)singerIdChars] intValue];
        }
        
        [list addObject:song];
        song = nil;
    }
    
    sqlite3_finalize(select_statement);
    
    return list;
}

@end
