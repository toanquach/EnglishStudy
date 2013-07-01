//
//  HomeViewController.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/6/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongViewCell.h"

@interface HomeViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SongViewCellDelegate>

@end
