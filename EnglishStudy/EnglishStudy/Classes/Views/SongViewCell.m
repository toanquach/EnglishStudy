//
//  SongViewCell.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "SongViewCell.h"

#import "Singer.h"
#import "Song.h"

@implementation SongViewCell

@synthesize delegate;

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

- (void)setupViewWithSong:(Song *)song
{
    songNameLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    singerNameLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    desLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    numViewLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    
    songNameLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:52.0f/255.0f blue:204.0f/255.0f alpha:1.0];
    numViewLabel.textColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0];
    desLabel.textColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0];
    singerNameLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
    NSArray *arr = [song.name componentsSeparatedByString:@"- "];
    if ([arr count] > 1)
    {
        songNameLabel.text = [[arr objectAtIndex:0] uppercaseString];
        singerNameLabel.text = [[arr objectAtIndex:1] uppercaseString];
    }
    
    desLabel.text = song.des;
    numViewLabel.text = [NSString stringWithFormat:@"%d", song.num_view];//Số lượt xem:
    
    purchaseButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [purchaseButton setTitleColor:[UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0] forState:UIControlStateNormal];

    songId = song.tblID;
}

- (void)setPurchaseButtonValue:(int)price andPurcharse:(BOOL)isPurcharse
{
    if (isPurcharse == YES)
    {
        [purchaseButton setBackgroundImage:[UIImage imageNamed:@"btn_Baihatdamua.png"] forState:UIControlStateNormal];
        [purchaseButton setTitle:[NSString stringWithFormat:@"%d",price] forState:UIControlStateNormal];
        [purchaseButton setTitleColor:[UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        purchaseButton.userInteractionEnabled = NO;
    }
    else
    {
        [purchaseButton setBackgroundImage:[UIImage imageNamed:@"btn_Muabaihat.png"] forState:UIControlStateNormal];
        [purchaseButton setTitle:[NSString stringWithFormat:@"%d",price] forState:UIControlStateNormal];
        [purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    songPrice = price;
}

- (void)setupFavoriteButton:(BOOL)flag
{
    favoriteButton.selected = flag;
}

- (IBAction)facebookButtonClicked:(id)sender
{
    [UIAppDelegate checkFBSession];
}

- (IBAction)favoriteButtonClicked:(id)sender
{
    favoriteButton.selected = !favoriteButton.selected;
    [delegate favoriteSongChanged:songId andFlag:favoriteButton.selected];
}

- (IBAction)purchaseButtonClicked:(id)sender
{
    [delegate purcharseSongWithId:songId andPrice:songPrice];
}
@end
