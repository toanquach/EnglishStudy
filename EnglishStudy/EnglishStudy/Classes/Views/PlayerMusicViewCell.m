//
//  PlayerMusicViewCell.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/24/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "PlayerMusicViewCell.h"

@implementation PlayerMusicViewCell

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

- (void)setupView:(NSDictionary *)dict andDisplayType:(int)displayType
{
    enTextLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:14];
    vnTextLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:14];
    enTextLabel.text = [dict objectForKey:@"en"];
    vnTextLabel.text = [dict objectForKey:@"vn"];
    
    enTextLabel.numberOfLines = 0;
    [enTextLabel sizeToFit];
    
    CGRect frame = vnTextLabel.frame;
    frame.origin.y = enTextLabel.frame.origin.y + enTextLabel.frame.size.height + 5;
    vnTextLabel.frame = frame;
    
    vnTextLabel.numberOfLines = 0;
    [vnTextLabel sizeToFit];
    
    if (displayType == kPlayerMusic_EN)
    {
        vnTextLabel.hidden = YES;
    }
    else if(displayType == kPlayerMusic_VN)
    {
        frame = vnTextLabel.frame;
        frame.origin.y = 5;
        vnTextLabel.frame = frame;
        enTextLabel.hidden = YES;
    }
}

- (void)setDetailTextColor:(UIColor *)color
{
    enTextLabel.textColor = color;
    
    vnTextLabel.textColor = color;
}
@end
