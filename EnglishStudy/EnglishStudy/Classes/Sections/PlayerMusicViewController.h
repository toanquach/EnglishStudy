//
//  PlayerMusicViewController.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/19/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

#import <AVFoundation/AVFoundation.h>
#import "ASIHTTPRequest.h"
#import "YLProgressBar.h"

@interface PlayerMusicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

@property (nonatomic, retain) Song *playerSong;

@end
