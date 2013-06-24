//
//  HotSongViewController.h
//  EnglishStudy
//
//  Created by Toan.Quach on 6/18/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchControlView.h"
#import "SongViewCell.h"

#import "Song.h"

@interface HotSongViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SearchControlViewDelegate>

@property (nonatomic) int type;
@property (nonatomic) int typeId;

@end
