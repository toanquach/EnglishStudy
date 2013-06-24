//
//  CategoryViewCell.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/21/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Category.h"
#import "Singer.h"

@interface CategoryViewCell : UITableViewCell
{
    __unsafe_unretained IBOutlet UIImageView *separateLineImageView;
    __unsafe_unretained IBOutlet UILabel *nameLabel;
    __unsafe_unretained IBOutlet UILabel *numSongLabel;
    __unsafe_unretained IBOutlet UILabel *numViewLabel;
    __unsafe_unretained IBOutlet UIImageView *iconImageView;
}

- (void)setupViewWithCategory:(Category *)cate;
- (void)setupViewWithSinger:(Singer *)singer;

@end
