//
//  Singer.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "Singer.h"

@implementation Singer

@synthesize tblID, name, url, num_song, num_view;

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

- (NSMutableArray*)getSinger:(sqlite3*)db
{
    database = db;
    NSString * query;
    NSMutableArray *list = [NSMutableArray array];
    query = @"SELECT * FROM singer";
    
    //NSLog(@"%@", query);
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
    }
    
    while(sqlite3_step(select_statement)==SQLITE_ROW)
    {
        Singer *singer = [[Singer alloc] init];
        const unsigned char* mTblID = sqlite3_column_text(select_statement, 0);
        if (mTblID == NULL)
        {
            singer.tblID = -1;
        }
        else
        {
            singer.tblID = [[NSString stringWithUTF8String:(const char*)mTblID] intValue];
        }
        
        const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
        if (nameChars==NULL)
        {
            singer.name = @"";
        }
        else
        {
            singer.name = [NSString stringWithUTF8String:(const char*)nameChars];
        }
        
        const unsigned char* urlChars = sqlite3_column_text(select_statement, 2);
        if (urlChars==NULL)
        {
            singer.url = @"";
        }
        else
        {
            singer.url = [NSString stringWithUTF8String:(const char*)urlChars];
        }
        
        const unsigned char *numChars = sqlite3_column_text(select_statement, 3);
        if (numChars==NULL)
        {
            singer.num_song = 0;
        }
        else
        {
            singer.num_song = [[NSString stringWithUTF8String:(const char*)numChars] intValue];
        }
        
        const unsigned char *num_viewChars = sqlite3_column_text(select_statement, 4);
        if (num_viewChars==NULL)
        {
            singer.num_view = 0;
        }
        else
        {
            singer.num_view = [[NSString stringWithUTF8String:(const char*)num_viewChars] intValue];
        }
        
        [list addObject:singer];
        singer = nil;
    }
    
    sqlite3_finalize(select_statement);
    
    return list;
}

- (Singer *)getSingerById:(sqlite3*)db
{
    Singer *singer = [[Singer alloc] init];
    database = db;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM singer where id=%d",self.tblID];
    
    //NSLog(@"%@", query);
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
    }
    
    while(sqlite3_step(select_statement)==SQLITE_ROW)
    {
        //
        //         get id
        //
        const unsigned char* idChars = sqlite3_column_text(select_statement, 0);
        if (idChars==NULL)
        {
            singer.tblID = -1;
        }
        else
        {
            singer.tblID = [[NSString stringWithUTF8String:(const char*)idChars] intValue];
        }
        
        //
        //      get name
        //
        const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
        if (nameChars==NULL)
        {
            singer.name = @"";
        }
        else
        {
            singer.name = [NSString stringWithUTF8String:(const char*)nameChars];
        }
        
        //
        //      get url
        //
        const unsigned char* urlChars = sqlite3_column_text(select_statement, 2);
        if (urlChars==NULL)
        {
            singer.url = @"";
        }
        else
        {
            singer.url = [NSString stringWithUTF8String:(const char*)urlChars];
        }
        
        //
        //      get num song
        //
        const unsigned char* numsongChars = sqlite3_column_text(select_statement, 3);
        if (numsongChars==NULL)
        {
            singer.num_song = 0;
        }
        else
        {
            singer.num_song = [[NSString stringWithUTF8String:(const char*)numsongChars] intValue];
        }
        
        //
        //      get num view
        //
        const unsigned char* numViewChars = sqlite3_column_text(select_statement, 4);
        if (numViewChars==NULL)
        {
            singer.num_view = 0;
        }
        else
        {
            singer.num_view = [[NSString stringWithUTF8String:(const char*)numViewChars] intValue];
        }
    }
    sqlite3_finalize(select_statement);
    
    return singer;
}

@end
