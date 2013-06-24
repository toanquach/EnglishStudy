//
//  CategoryViewCell.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/21/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "CategoryViewCell.h"

@implementation CategoryViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupViewWithCategory:(Category *)cate
{
    nameLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    numSongLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    
    nameLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:52.0f/255.0f blue:204.0f/255.0f alpha:1.0];
    numSongLabel.textColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0];

    nameLabel.text = cate.name;
    numSongLabel.text = [NSString stringWithFormat:@"Số bài hát: %d - Code: %d",cate.num_song, cate.tblID];
}

- (void)setupViewWithSinger:(Singer *)singer
{
    nameLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    numSongLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    numViewLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    
    nameLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:52.0f/255.0f blue:204.0f/255.0f alpha:1.0];
    numSongLabel.textColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0];
    numViewLabel.textColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0];
    
    nameLabel.text = singer.name;
    numSongLabel.text = [NSString stringWithFormat:@"Số bài hát: %d - Code: %d",singer.num_song, singer.tblID];
    numViewLabel.text = [NSString stringWithFormat:@"Số lượt xem: %d",singer.num_view];
}

@end
