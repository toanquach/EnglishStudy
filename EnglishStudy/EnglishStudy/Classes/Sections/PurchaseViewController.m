//
//  PurchaseViewController.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PlayerMusicViewController.h"
#import "LoadMoneyViewController.h"

@interface PurchaseViewController ()
{
    __unsafe_unretained IBOutlet UITableView *myTableView;
    int songId;
    int songPrice;
}
- (void)setupView;

@end

@implementation PurchaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [myTableView reloadData];
}

#pragma mark - setup View

- (void)setupView
{
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    // -----------------------
    //      Set Back Button
    //
    self.navigationItem.hidesBackButton = YES;
    UIImage *backButtonImage = [UIImage imageNamed:@"nav_back_button.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonBar = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonBar;
    
    backButtonImage = nil;
    backButton = nil;
    backButtonBar = nil;
    
    //  -----------------------
    //      custom title label
    //
    UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"Bài Hát Đã Mua";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    // add right button
    
    UIImage *rightMenuImage = [UIImage imageNamed:@"icon_menu.png"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rightMenuImage.size.width/2, rightMenuImage.size.height/2)];
    [rightButton setBackgroundImage:rightMenuImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonBar;
    
    rightMenuImage = nil;
    rightButton = nil;
    rightButtonBar = nil;
}


#pragma mark - UIBUtton event

- (void)backButtonPressed:(id)sender
{
    if (UIAppDelegate.isMenuShow == 1)
    {
        UIAppDelegate.isMenuShow = 0;
        UIAppDelegate.navDropDownMenu.hidden = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMenuButtonClicked:(id)sender
{
    if (UIAppDelegate.isMenuShow == 0)
    {
        UIAppDelegate.navDropDownMenu.hidden = NO;
        [UIAppDelegate.navDropDownMenu menuAnimateShow];
        UIAppDelegate.isMenuShow = 1;
    }
    else
    {
        [UIAppDelegate.navDropDownMenu menuAnimateHide];
        UIAppDelegate.isMenuShow = 0;
    }
}

- (void)viewDidUnload
{
    myTableView = nil;
    [super viewDidUnload];
}


#pragma mark - UITable Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[UserDataManager sharedManager] getNumSongPurcharse];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier2";
    
    SongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SongViewCell" owner:self options:nil] objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    Song *song = [[Song alloc] init];
    song.tblID = [[[UserDataManager sharedManager].listPurcharse objectAtIndex:indexPath.row] intValue];
    song = [song getSongById:[DatabaseManager sharedDatabaseManager].database];
    
    int xu = song.num_view/1000 + 10;
    if (xu > 100)
    {
        xu = 100;
    }
    [cell setupViewWithSong:song];
    if ([[UserDataManager sharedManager] filterPurcharseSongWithKey:song.tblID] == YES)
    {
        [cell setPurchaseButtonValue:xu andPurcharse:YES];
    }
    else
    {
        [cell setPurchaseButtonValue:xu andPurcharse:NO];
    }
    //
    //      Check favorite item
    //
    if ([[UserDataManager sharedManager] filterFavoriteSongWithKey:song.tblID] == YES)
    {
        [cell setupFavoriteButton:YES];
    }
    else
    {
        [cell setupFavoriteButton:NO];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tblId = [[[[UserDataManager sharedManager] listPurcharse] objectAtIndex:indexPath.row] intValue];
    Song *song = [[Song alloc] init];
    song.tblID = tblId;
    song = [song getSongById:[DatabaseManager sharedDatabaseManager].database];
    
    if ([[UserDataManager sharedManager] filterPurcharseSongWithKey:song.tblID] == YES || 1)
    {
        PlayerMusicViewController *viewController = [[PlayerMusicViewController alloc] init];
        
        viewController.playerSong = song;
        
        [self.navigationController pushViewController:viewController animated:YES];
        viewController = nil;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        int xu = song.num_view/1000 + 10;
        if (xu > 100)
        {
            xu = 100;
        }
        songId = song.tblID;
        songPrice = xu;
        NSString *title = [NSString stringWithFormat:kAlert_Message_Purcharse_Title,songPrice];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:kAlert_Message_Purcharse_Message delegate:self cancelButtonTitle:@"Không" otherButtonTitles:@"Có", nil];
        alertView.tag = 1;
        [alertView show];
        alertView= nil;
    }
}

#pragma mark - song view cell delegate

- (void)purcharseSongWithId:(int)tblId andPrice:(int)price
{
    songId = tblId;
    songPrice = price;
    NSString *title = [NSString stringWithFormat:kAlert_Message_Purcharse_Title,price];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:kAlert_Message_Purcharse_Message delegate:self cancelButtonTitle:@"Không" otherButtonTitles:@"Có", nil];
    alertView.tag = 1;
    [alertView show];
    alertView= nil;
}

- (void)favoriteSongChanged:(int)tblId andFlag:(BOOL)flag
{
    if (flag == YES)
    {
        // add new item
        [[UserDataManager sharedManager] insertFavoriteSong:tblId];
    }
    else
    {
        // remove item
        [[UserDataManager sharedManager] deleteFavoriteSong:tblId];
    }
    
    [myTableView reloadData];
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
                NSString *message = [NSString stringWithFormat:kAlert_Message_Enough_Coin,songPrice,[[UserDataManager sharedManager] getCoinUser]];
                UIAlertView *mAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Nạp Xu",@"Share Facebook", nil];
                mAlertView.tag = 2;
                [mAlertView show];
                mAlertView = nil;
            }
            else
            {
                //
                //      Insert song to  UserDataManager
                //
                [[UserDataManager sharedManager] insertPurcharseSong:songId];
                [[UserDataManager sharedManager] minusCoinUser:songPrice];
                [myTableView reloadData];
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
