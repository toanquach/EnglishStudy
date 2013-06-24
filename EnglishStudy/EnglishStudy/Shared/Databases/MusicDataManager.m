//
//  MusicDataManager.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/24/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "MusicDataManager.h"
@interface MusicDataManager()

@property (strong) NSOperationQueue *stationDownloadQueue;

@end

@implementation MusicDataManager

+ (MusicDataManager *)sharedMusicDataManager
{
    static dispatch_once_t once;
    static MusicDataManager *_sharedInstance;
    dispatch_once(&once, ^ { _sharedInstance = [[MusicDataManager alloc] init]; });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.stationDownloadQueue = [[NSOperationQueue alloc] init];
        self.stationDownloadQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

@end
