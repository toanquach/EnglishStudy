//
//  UserDataManager.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/27/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "UserDataManager.h"

@interface UserDataManager()
{
    int coinUser;
}

@property (nonatomic, strong) NSMutableArray *listFavorites;

@property (nonatomic, strong) NSMutableArray *listPurcharse;

@end

@implementation UserDataManager

+ (UserDataManager *)sharedManager
{
    static dispatch_once_t once;
    static UserDataManager *_sharedInstance;
    dispatch_once(&once, ^ { _sharedInstance = [[UserDataManager alloc] init]; });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //
        //      get list favorites and purcharse
        //
        NSUserDefaults *usersDefault = [NSUserDefaults standardUserDefaults];
        self.listPurcharse = [usersDefault objectForKey:KArray_Purcharse];
        if (self.listPurcharse == nil)
        {
            self.listPurcharse = [NSMutableArray array];
            [usersDefault setObject:self.listPurcharse forKey:KArray_Purcharse];
        }
        
        self.listFavorites = [usersDefault objectForKey:kArray_Favorite];
        if (self.listFavorites == nil)
        {
            self.listFavorites = [NSMutableArray array];
            [usersDefault setObject:self.listFavorites forKey:kArray_Favorite];
        }
        
        NSString *coin = [usersDefault objectForKey:kUser_Coin];
        if (coin == nil)
        {
            coin = @"200";
            [usersDefault setObject:coin forKey:kUser_Coin];
            coinUser = 200;
        }
        
        [usersDefault synchronize];
    }
    
    return self;
}


- (BOOL)filterPurcharseSongWithKey:(int)key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",[NSString stringWithFormat:@"%d",key]];
    NSArray *arr = [self.listPurcharse filteredArrayUsingPredicate:predicate];
    if ([arr count] > 0)
    {
        // having purchase
        return YES;
    }
    
    return NO;
}

- (BOOL)filterFavoriteSongWithKey:(int)key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %d",key];
    NSArray *arr = [self.listFavorites filteredArrayUsingPredicate:predicate];
    if ([arr count] > 0)
    {
        // having purchase
        return YES;
    }
    
    return NO;
}

- (int)getCoinUser
{
    return coinUser;
}

- (void)minusCoinUser:(int)num
{
    coinUser -= num;
    if (coinUser < 0)
    {
        coinUser = 0;
    }
    NSString *coinUserStr = [NSString stringWithFormat:@"%d",coinUser];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:coinUserStr forKey:kUser_Coin];
    [userDefaults synchronize];
}

- (void)plusCoinUser:(int)num
{
    coinUser +=num;
    NSString *coinUserStr = [NSString stringWithFormat:@"%d",coinUser];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:coinUserStr forKey:kUser_Coin];
    [userDefaults synchronize];
}

- (void)takeOff
{
        // init data
}

@end
