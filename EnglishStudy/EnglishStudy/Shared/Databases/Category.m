//
//  Category.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/19/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize tblID, name, num_song;

static sqlite3_stmt *insert_statement=nil;
static sqlite3_stmt* update_statement=nil;
static sqlite3_stmt* select_statement = nil;
static sqlite3_stmt* delete_statement = nil;

- (NSString *)insert:(sqlite3 *)db
{
    database = db;
    insert_statement=nil;
    if(insert_statement==nil) // create insert query statement
    {
        const char *sql = "insert into category(id,name,num_song)values(?,?,?)";
        
        if(sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL)!=SQLITE_OK)
        {
            NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
            return nil;
        }
        
    }

    //   Filter field
    sqlite3_bind_int(insert_statement, 1, self.tblID);
    sqlite3_bind_text(insert_statement,2,[self.name UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_statement,3,self.num_song);

    int success = sqlite3_step(insert_statement);
    sqlite3_reset(insert_statement);
    
    if(success==SQLITE_DONE)
    {
        return @"SUCCESS";
    }
    
    NSLog(@"Error: failed to insert into database  with message '%s',",sqlite3_errmsg(database));
    return nil;
}

- (NSString*)update:(sqlite3*)db
{
    database = db;
    update_statement = nil;
    const char* sql;
    if (update_statement==nil)
    {
        
        sql = "update category set name=?,num_song=? where id=?";
        
        if (sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL)!=SQLITE_OK)
        {
            
            NSAssert1(0, @"Error while creating update statement :'%s'", sqlite3_errmsg(database));
            
        }
    }

    sqlite3_bind_text(update_statement, 1, [self.name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(update_statement, 2, self.num_song);
    sqlite3_bind_int(update_statement, 3, self.tblID);
    
    if (SQLITE_DONE!=sqlite3_step(update_statement))
    {
        NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
        sqlite3_reset(update_statement);
        return @"FAIL";
    }
    if (update_statement)
        sqlite3_finalize(update_statement);
    sqlite3_finalize(update_statement);
    return @"SUCCESS";
}

- (NSMutableArray*)getCategory:(sqlite3*)db
{
     database = db;
     NSString * query;
     NSMutableArray *list = [NSMutableArray array];
     query = @"SELECT * FROM category";
     
     //NSLog(@"%@", query);
     const char *sql = [query UTF8String];
     
     if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
     {
         NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
     }
     
     while(sqlite3_step(select_statement)==SQLITE_ROW)
     {
         Category *cate = [[Category alloc] init];
         const unsigned char* mTblID = sqlite3_column_text(select_statement, 0);
         if (mTblID == NULL)
         {
             cate.tblID = -1;
         }
         else
         {
             cate.tblID = [[NSString stringWithUTF8String:(const char*)mTblID] intValue];
         }
     
         const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
         if (nameChars==NULL)
         {
             cate.name = @"";
         }
         else
         {
             cate.name = [NSString stringWithUTF8String:(const char*)nameChars];
         }
     
         const unsigned char *numChars = sqlite3_column_text(select_statement, 2);
         if (numChars==NULL)
         {
             cate.num_song = 0;
         }
         else
         {
             cate.num_song = [[NSString stringWithUTF8String:(const char*)numChars] intValue];
         }
     
         [list addObject:cate];
         cate = nil;
     }
    
     sqlite3_finalize(select_statement);
    
    return list;
}

- (Category *)getCategoryById:(sqlite3*)db
{
     Category *cate = [[Category alloc] init];
     database = db;
     NSString * query = [NSString stringWithFormat:@"SELECT * FROM category where id=%d",self.tblID];

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
             cate.tblID = -1;
         }
         else
         {
             cate.tblID = [[NSString stringWithUTF8String:(const char*)idChars] intValue];
         }
     
         const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
         if (nameChars==NULL)
         {
             cate.name = @"";
         }
         else
         {
             cate.name = [NSString stringWithUTF8String:(const char*)nameChars];
         }
     
         const unsigned char* numsongChars = sqlite3_column_text(select_statement, 2);
         if (numsongChars==NULL)
         {
             cate.num_song = 0;
         }
         else
         {
             cate.num_song = [[NSString stringWithUTF8String:(const char*)numsongChars] intValue];
         }
     }
     sqlite3_finalize(select_statement);
     
    return cate;
}

- (NSString *)deleteCategory:(sqlite3 *)db
{
    database = db;
    delete_statement = nil;
    if(delete_statement == nil)
    {
        const char *sql = "delete from category where id=?";
        
        if(sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL)!=SQLITE_OK)
        {
            NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
            return @"NO";
        }
    }
    
    sqlite3_bind_int(delete_statement, 1, self.tblID);
    //int success =
    sqlite3_step(delete_statement);
    sqlite3_reset(delete_statement);
    
    if (SQLITE_DONE!=sqlite3_step(delete_statement))
    {
        NSAssert1(0, @"Error while deteting. '%s'", sqlite3_errmsg(database));
        sqlite3_reset(delete_statement);
        return @"FAIL";
    }
    sqlite3_finalize(update_statement);
    return @"SUCCESS";
}

@end
