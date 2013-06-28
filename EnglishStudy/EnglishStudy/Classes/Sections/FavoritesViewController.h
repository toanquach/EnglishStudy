//
//  FavoritesViewController.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongViewCell.h"
#import "Song.h"

@interface FavoritesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SongViewCellDelegate>

@end
