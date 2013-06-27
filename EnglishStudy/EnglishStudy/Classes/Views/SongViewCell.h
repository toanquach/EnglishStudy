//
//  SongViewCell.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Song;

@protocol SongViewCellDelegate <NSObject>

@optional

- (void)purcharseSongWithId:(int)tblId andPrice:(int)price;

@end

@interface SongViewCell : UITableViewCell
{
    __unsafe_unretained IBOutlet UILabel *songNameLabel;
    __unsafe_unretained IBOutlet UILabel *singerNameLabel;
    __unsafe_unretained IBOutlet UILabel *numViewLabel;
    __unsafe_unretained IBOutlet UIButton *purchaseButton;
    
    __unsafe_unretained IBOutlet UILabel *desLabel;
    __unsafe_unretained IBOutlet UIButton *favoriteButton;
    
    int songId;
    int songPrice;
    __unsafe_unretained IBOutlet UIButton *facebookButton;
}

@property (nonatomic, assign) id<SongViewCellDelegate> delegate;

- (void)setupViewWithSong:(Song *)song;

- (IBAction)purchaseButtonClicked:(id)sender;

- (void)setPurchaseButtonValue:(int)price andPurcharse:(BOOL)isPurcharse;

- (IBAction)facebookButtonClicked:(id)sender;

- (IBAction)favoriteButtonClicked:(id)sender;

@end
