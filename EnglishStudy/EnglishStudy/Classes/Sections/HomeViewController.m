//
//  HomeViewController.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/6/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "HomeViewController.h"

#import "ESButton.h"

#import "HotSongViewController.h"
#import "AccountsViewController.h"
#import "CategoryViewController.h"
#import "PurchaseViewController.h"
#import "FavoritesViewController.h"
#import "SettingsViewController.h"
#import "PlayerMusicViewController.h"
#import "LoadMoneyViewController.h"

#import "DownloadViewController.h"


@interface HomeViewController ()
{
    __unsafe_unretained IBOutlet ESButton *bestSongButton;
    __unsafe_unretained IBOutlet ESButton *accountButton;
    __unsafe_unretained IBOutlet ESButton *favoritesButton;
    __unsafe_unretained IBOutlet ESButton *settingButton;
    __unsafe_unretained IBOutlet ESButton *purchaseButton;
    __unsafe_unretained IBOutlet ESButton *otherAppButton;
    __unsafe_unretained IBOutlet UITextField *searchTextField;
    __unsafe_unretained IBOutlet UIView *containerButtonView;
    __unsafe_unretained IBOutlet UIImageView *bestSongImageView;
    __unsafe_unretained IBOutlet UIImageView *bestSongExpandImageView;
    __unsafe_unretained IBOutlet UIView *bestSongExpandView;
    
    __unsafe_unretained IBOutlet UIButton *hotCategoryButton;
    __unsafe_unretained IBOutlet UIButton *hotSingerButton;
    __unsafe_unretained IBOutlet UIButton *hotSongButton;
    // ----------------------------------------------------
    int singerRadioButtonSelected;
    
    int isBestSongClick;

    __unsafe_unretained IBOutlet UIView *searchBgView;
    __unsafe_unretained IBOutlet UITableView *searchTableView;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *loadingIndicator;
    
    dispatch_time_t delaySearchUntilQueryUnchangedForTimeOffset;
    
    NSMutableArray *listItem;
    
    
    __unsafe_unretained IBOutlet UILabel *noResultLabel;
    
    int songId;
    int songPrice;
}

- (void)setupView;
- (void)sendButtonToBack;
- (void)bringButtonToFront;
- (void)slideOnOffMenuButton:(BOOL)flag;
- (void)searchSongWithText:(NSString *)keyword;
- (BOOL)checkDatabaseExist;

// ------------------------------------------
- (IBAction)bestSongButtonClicked:(id)sender;
- (IBAction)hotCategoryButtonClicked:(id)sender;
- (IBAction)hotSingerButtonClicked:(id)sender;
- (IBAction)hotSongButtonClicked:(id)sender;
- (IBAction)accountButtonClicked:(id)sender;
- (IBAction)favoritesButtonClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;
- (IBAction)purchaseButtonClicked:(id)sender;
- (IBAction)otherAppButtonClicked:(id)sender;

- (IBAction)backgroundButtonClicked:(id)sender;
- (IBAction)clearTextButtonClicked:(id)sender;
@end

@implementation HomeViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self checkDatabaseExist];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIAppDelegate showFooterView];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIAppDelegate hiddenFooterView];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    listItem = nil;
    bestSongButton = nil;
    accountButton = nil;
    favoritesButton = nil;
    settingButton = nil;
    purchaseButton = nil;
    otherAppButton = nil;
    searchTextField = nil;
    containerButtonView = nil;
    bestSongImageView = nil;
    bestSongExpandImageView = nil;
    bestSongExpandView = nil;
    hotCategoryButton = nil;
    hotSingerButton = nil;
    hotSongButton = nil;
    searchBgView = nil;
    searchTableView = nil;
    loadingIndicator = nil;
    noResultLabel = nil;
    [super viewDidUnload];
}


#pragma mark - setup View

- (void)setupView
{
    searchTextField.delegate = self;
    
    if (IS_IPHONE_5)
    {
        CGRect frame = containerButtonView.frame;
        frame.origin.y +=44;
        containerButtonView.frame = frame;
    }
    
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    searchTableView.tableFooterView = footerView;
    
    delaySearchUntilQueryUnchangedForTimeOffset = 0.4 * NSEC_PER_SEC;
    
    noResultLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    noResultLabel.textColor = [UIColor whiteColor];
}

- (void)sendButtonToBack
{
    [containerButtonView sendSubviewToBack:accountButton];
}

- (void)bringButtonToFront
{
    [containerButtonView bringSubviewToFront:accountButton];
}

//
//  Slide Expand menu of Hot Music Button
//
- (void)slideOnOffMenuButton:(BOOL)flag
{
    NSString *hotsong = @"btn_icon_hotsongs.png";
    NSString *hotsong_hover = @"btn_hotsong_hover.png";
    bestSongButton.userInteractionEnabled = NO;
    if (bestSongButton.selected == YES)
    {
        [UIView animateWithDuration:0.5 animations:^
         {
             bestSongExpandImageView.frame = CGRectMake(140, 0, 1, 80);
             bestSongExpandView.frame = CGRectMake(0, 0, 153, 80);
             
         }completion:^(BOOL finished)
         {
             bestSongImageView.image = [UIImage imageNamed:hotsong];
             
             bestSongExpandImageView.hidden = YES;
             
             bestSongExpandView.hidden = YES;
             
             bestSongButton.userInteractionEnabled = YES;
             
             [self bringButtonToFront];
             
         }];
    }
    else
    {
        bestSongExpandImageView.hidden = NO;
        bestSongExpandImageView.frame = CGRectMake(140, 0, 1, 80);
        
        bestSongImageView.image = [UIImage imageNamed:hotsong_hover];
        
        bestSongExpandView.hidden = NO;
        bestSongExpandView.frame = CGRectMake(0, 0, 153, 80);
        
        [self sendButtonToBack];
        
        [UIView animateWithDuration:0.5 animations:^
         {
             bestSongExpandImageView.frame = CGRectMake(140, 0, 153, 80);
             bestSongExpandView.frame = CGRectMake(140, 0, 153, 80);
             
         }completion:^(BOOL finished)
         {
             bestSongButton.userInteractionEnabled = YES;
             
         }];
    }
    
    bestSongButton.selected = !bestSongButton.selected;
}

- (BOOL)checkDatabaseExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [NSString stringWithFormat:@"%@data/%@",LIBRARY_CATCHES_DIRECTORY,kDabase_Name];
    if (![fileManager fileExistsAtPath:dbPath])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Chưa có dữ liệu mới nhất. Bạn cần phải cập nhật giữ liệu mới để có thể sử dụng phần mềm." delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:@"Tải", nil];
        alertView.tag = 3;
        [alertView show];
        alertView = nil;
        return NO;
    }
    return YES;
}
#pragma mark - Button Delegate

/*
    Best Song Button Click, slide submenu list button ON/OFF
 */

- (IBAction)bestSongButtonClicked:(id)sender
{
    [self slideOnOffMenuButton:bestSongButton.selected];
}

- (IBAction)hotCategoryButtonClicked:(id)sender
{
    if ([self checkDatabaseExist] == NO)
    {
        return;
    }
    
    [UIAppDelegate showConnectionView];
    [self slideOnOffMenuButton:YES];
    CategoryViewController *viewController = [[CategoryViewController alloc]init];
    viewController.categotyType = kCategoryType_Category;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)hotSingerButtonClicked:(id)sender
{
    if ([self checkDatabaseExist] == NO)
    {
        return;
    }
    
    [UIAppDelegate showConnectionView];
    [self slideOnOffMenuButton:YES];
    CategoryViewController *viewController = [[CategoryViewController alloc]init];
    viewController.categotyType = kCategoryType_Singer;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)hotSongButtonClicked:(id)sender
{
    if ([self checkDatabaseExist] == NO)
    {
        return;
    }
    
    [UIAppDelegate showConnectionView];
    [self slideOnOffMenuButton:YES];
    HotSongViewController *viewController = [[HotSongViewController alloc]init];
    viewController.type = kCategoryType_Song;
    viewController.titleString = @"Danh Sách Bài Hát";
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)accountButtonClicked:(id)sender
{
    AccountsViewController *viewController = [[AccountsViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)favoritesButtonClicked:(id)sender
{
    FavoritesViewController *viewController = [[FavoritesViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)settingsButtonClicked:(id)sender
{
    SettingsViewController *viewController = [[SettingsViewController alloc]init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)purchaseButtonClicked:(id)sender
{
    PurchaseViewController *viewController = [[PurchaseViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)otherAppButtonClicked:(id)sender
{
    //
    //      open other app
    //
}

- (IBAction)backgroundButtonClicked:(id)sender
{
    [searchTextField resignFirstResponder];
    searchBgView.hidden = YES;
}

- (IBAction)clearTextButtonClicked:(id)sender
{
    searchTextField.text = @"";
    [searchTextField becomeFirstResponder];
    searchTableView.hidden = YES;
}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //
    //      Search Item
    //
    [self searchSongWithText:textField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    searchBgView.hidden = NO;
    searchTableView.hidden = YES;
    noResultLabel.hidden = YES;
    [loadingIndicator startAnimating];
    //
    // waiting when user pressing
    //
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySearchUntilQueryUnchangedForTimeOffset);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
   {
       [self searchSongWithText:resultStr];
   });
    //[self searchSongWithText:resultStr];
    return YES;
}

- (void)searchSongWithKeyword:(NSString *)keyword
{
    DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
    Song *song = [[Song alloc] init];
    listItem = [song searchSong:db.database WithText:keyword];
    
    if ([listItem count] > 0)
    {
        noResultLabel.hidden = YES;
        searchTableView.hidden = NO;
    }
    else
    {
        searchTableView.hidden = YES;
        noResultLabel.hidden = NO;
        [loadingIndicator stopAnimating];
    }
    
    [searchTableView reloadData];
}

- (void)searchSongWithText:(NSString *)keyword
{
    if ([self checkDatabaseExist] == NO)
    {
        return;
    }
    
    if (keyword == nil || [keyword isEqualToString:@""] == TRUE)
    {
        searchBgView.hidden = YES;
    }
    else
    {
        searchBgView.hidden = NO;
        [[DatabaseManager databaseQueue] cancelAllOperations];
        NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(searchSongWithKeyword:) object:keyword];
        [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
        //[operation start];
        
        [[DatabaseManager databaseQueue] addOperation:operation];
        operation = nil;
    }
}

#pragma mark - UITableViewCell

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
    {
        [loadingIndicator stopAnimating];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listItem count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    SongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SongViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    Song *song = nil;
    song = [listItem objectAtIndex:indexPath.row];
    [cell setupViewWithSong:song];
    
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
    Song *song = [listItem objectAtIndex:indexPath.row];
    if ([[UserDataManager sharedManager] filterPurcharseSongWithKey:song.tblID] == YES)
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
    
    [searchTableView reloadData];
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
                [searchTableView reloadData];
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
    else if(alertView.tag == 3)
    {
        
        if (buttonIndex == 1)
        {
            DownloadViewController *downloadController = [[DownloadViewController alloc] init];
            [self presentModalViewController:downloadController animated:YES];
        }
    }
}


#pragma mark - Keyboard will show

- (void)keyboardWillShow:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^
     {
         UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
         [searchTableView setContentInset:edgeInsets];
         [searchTableView setScrollIndicatorInsets:edgeInsets];
     }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^
     {
         UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
         [searchTableView setContentInset:edgeInsets];
         [searchTableView setScrollIndicatorInsets:edgeInsets];
     }];
}
@end
