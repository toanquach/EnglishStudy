//
//  UserDataManager.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/27/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *listFavorites;

@property (nonatomic, strong) NSMutableArray *listPurcharse;

+ (UserDataManager *)sharedManager;

- (BOOL)filterPurcharseSongWithKey:(int)key;

- (BOOL)filterFavoriteSongWithKey:(int)key;

- (int)getCoinUser;

- (void)minusCoinUser:(int)num;

- (void)plusCoinUser:(int)num;

- (void)takeOff;

- (void)insertPurcharseSong:(int)songID;

- (int)getNumSongPurcharse;

- (int)getNumSongFavorite;

@end
