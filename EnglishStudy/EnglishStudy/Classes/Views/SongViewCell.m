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

//#import "AccountsViewController.h"
#import "LoadMoneyViewController.h"

@implementation SongViewCell

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
    
    //------------------------------------------------ get singer id
    //DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
    //Singer *singer = [[Singer alloc] init];
    //singer.tblID = song.singer_id;
    //singer = [singer getSingerById:db.database];
    //singerNameLabel.text = [singer.name uppercaseString];
    desLabel.text = song.des;
    numViewLabel.text = [NSString stringWithFormat:@"Số lượt xem: %d", song.num_view];
    
    purchaseButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [purchaseButton setTitleColor:[UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
//    
    //singer = nil;
    
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
    price = 201;
    songPrice = price;
}

- (IBAction)purchaseButtonClicked:(id)sender
{
    //[UIAppDelegate.listPurcharse addObject:[NSString stringWithFormat:@"%d",songId]];
    NSString *title = [NSString stringWithFormat:@"Bài này giá %d xu",songPrice];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"Bạn có muốn mua không?" delegate:self cancelButtonTitle:@"Không" otherButtonTitles:@"Có", nil];
    alertView.tag = 1;
    [alertView show];
    alertView= nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            int coinUser = [[UserDataManager sharedManager] getCoinUser];
            if ((coinUser - songPrice) < 0)
            {
                UIAlertView *mAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Bài này giá 100 xu\nTài khoản của bạn còn 50 xu do đó bạn chưa đủ xu để mua. Để nạp xu bạn có thể nạp thẻ cào mobi, vina, viettel hoặc share facebook bài hát này" delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Nạp Xu",@"Share Facebook", nil];
                mAlertView.tag = 2;
                [mAlertView show];
                mAlertView = nil;
            }
        }
    }
    else if(alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            LoadMoneyViewController *viewController = [[LoadMoneyViewController alloc] init];
            [UIAppDelegate.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            // share facebook
        }
    }
}

@end
