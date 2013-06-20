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
    if(insert_statement==nil)
        
    {
        const char *sql = "insert into users(userid,username,useremail,userpassword,userimage,lname,gender,birthday,usermobile)values(?,?,?,?,?,?,?,?,?)";
        
        if(sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL)!=SQLITE_OK)
        {
            NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
            return nil;
        }
        
    }

    //    int userID = [self.ID intValue];
//    NSLog(@"insert to userId=%d",userID);
//    NSLog(@"self.id=%@",self.ID);
//    sqlite3_bind_int(insert_statement, 1, userID);
//    sqlite3_bind_text(insert_statement,2,[self.name UTF8String],-1,SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,3,[self.email UTF8String],-1,SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,4,[self.password UTF8String],-1,SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,5,[self.image UTF8String],-1,SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,6,[self.lName UTF8String],-1,SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,7,[self.gender UTF8String],-1,SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,8,[self.birthday UTF8String],-1,SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,9,[self.mobile UTF8String],-1,SQLITE_TRANSIENT);
    
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
    if (update_statement==nil) {
        
        sql = "update users set username=?,useremail=?,userpassword=?,userimage=?,lname=?,gender=?,birthday=?,usermobile=? where userid=?";
        
        if (sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL)!=SQLITE_OK) {
            
            NSAssert1(0, @"Error while creating update statement :'%s'", sqlite3_errmsg(database));
            
        }
        
    }
//    int userID = [self.ID intValue];
//    NSLog(@"update to userId=%d",userID);
//    NSLog(@"self.id=%@",self.ID);
//    sqlite3_bind_text(update_statement, 1, [self.name UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(update_statement, 2, [self.email UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(update_statement, 3, [self.password UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(update_statement, 4, [self.image UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(update_statement, 5, [self.lName UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(update_statement, 6, [self.gender UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(update_statement, 7, [self.birthday UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(update_statement, 8, [self.mobile UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_int(update_statement, 9, userID);
    
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
     
     NSLog(@"%@", query);
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
             cate.num_song = -1;
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
    /*
     User* user = [[User alloc] init];
     database = db;
     NSString * query = [NSString stringWithFormat:@"SELECT * FROM users where userid=%@",self.ID];
     //sort by productname"
     
     NSLog(@"%@", query);
     const char *sql = [query UTF8String];
     
     if(sqlite3_prepare_v2(database,sql,-1,&select_statement,NULL)!=SQLITE_OK)
     {
     NSLog(@"Error: failed to prepare statement with message '%s',",sqlite3_errmsg(database));
     }
     
     while(sqlite3_step(select_statement)==SQLITE_ROW)
     {
     const unsigned char* idChars = sqlite3_column_text(select_statement, 0);
     if (idChars==NULL) {
     user.ID = @"NO";
     }
     else {
     user.ID = [NSString stringWithUTF8String:(const char*)idChars];
     }
     
     
     
     const unsigned char* nameChars = sqlite3_column_text(select_statement, 1);
     if (nameChars==NULL) {
     user.name = @"NO";
     }
     else {
     user.name = [NSString stringWithUTF8String:(const char*)nameChars];
     }
     
     const unsigned char* emailChars = sqlite3_column_text(select_statement, 2);
     if (emailChars==NULL) {
     user.email = @"NO";
     }
     else {
     
     user.email = [NSString stringWithUTF8String:(const char*)emailChars];
     
     }
     
     const unsigned char* pwdChars = sqlite3_column_text(select_statement, 3);
     if (pwdChars==NULL) {
     user.password = @"NO";
     }
     else {
     
     user.password = [NSString stringWithUTF8String:(const char*)pwdChars];
     
     }
     
     const unsigned char* imageChars = sqlite3_column_text(select_statement, 4);
     if (pwdChars==NULL) {
     user.image = @"NO";
     }
     else {
     
     user.image = [NSString stringWithUTF8String:(const char*)imageChars];
     
     }
     
     const unsigned char* lnameChars = sqlite3_column_text(select_statement, 5);
     if (lnameChars==NULL) {
     user.lName = @"NO";
     }
     else {
     
     user.lName = [NSString stringWithUTF8String:(const char*)lnameChars];
     
     }
     
     const unsigned char* genderChars = sqlite3_column_text(select_statement, 6);
     if (genderChars==NULL) {
     user.gender = @"NO";
     }
     else {
     
     user.gender = [NSString stringWithUTF8String:(const char*)genderChars];
     
     }
     
     const unsigned char* birthChars = sqlite3_column_text(select_statement, 7);
     if (birthChars==NULL) {
     user.birthday = @"NO";
     }
     else {
     
     user.birthday = [NSString stringWithUTF8String:(const char*)birthChars];
     
     }
     
     const unsigned char* mobileChars = sqlite3_column_text(select_statement, 8);
     if (mobileChars==NULL) {
     user.mobile = @"NO";
     }
     else {
     
     user.mobile = [NSString stringWithUTF8String:(const char*)mobileChars];
     
     }
     }
     sqlite3_finalize(select_statement);
     
     user.listSharing = [self getSharing:db];
     user.listFollowing = [self getFollowing:db];
     
     return user;
     */
}

/*
 
 */
@end
