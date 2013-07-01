//
//  PlayerMusicViewCell.h
//  EnglishStudy
//
//  Created by Toan.Quach on 6/24/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerMusicViewCell : UITableViewCell
{
    __unsafe_unretained IBOutlet UILabel *enTextLabel;
    __unsafe_unretained IBOutlet UILabel *vnTextLabel;
    
}

- (void)setupView:(NSDictionary *)dict andDisplayType:(int)displayType;

- (void)setDetailTextColor:(UIColor *)color;

@end
