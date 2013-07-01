//
//  HotSongViewController.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/18/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "HotSongViewController.h"

#import "DatabaseManager.h"
#import "Song.h"

#import "PlayerMusicViewController.h"
#import "LoadMoneyViewController.h"

@interface HotSongViewController ()
{
    __unsafe_unretained IBOutlet UITableView *myTableView;
    SearchControlView *searchControlView;
    
    NSMutableArray *listTableItems;
    NSArray *listSearch;
    int isSearch;
    __unsafe_unretained IBOutlet UIView *loadingBgView;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *loadingIndicator;
    int songId;
    int songPrice;
}

- (void)setupView;

@end

@implementation HotSongViewController

@synthesize type, typeId, titleString;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
    Song *song = [[Song alloc] init];
    if (self.type == kCategoryType_Song)
    {
        listTableItems = [song getSong:db.database];
    }
    else if(self.type == kCategoryType_Singer)
    {
        song.singer_id = typeId;
        listTableItems = [song getSongBySingerId:db.database];
    }
    else
    {
        song.category_id = typeId;
        listTableItems = [song getSongByCategoryId:db.database];
    }
    [myTableView reloadData];
    if ([listTableItems count] == 0)
    {
        [UIAppDelegate hiddenConnectionView];   
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupView

- (void)setupView
{
    
    searchControlView = [[[NSBundle mainBundle] loadNibNamed:@"SearchControlView" owner:self options:nil] objectAtIndex:0];
    searchControlView.frame = CGRectMake(0, 0, 320, 39);
    [searchControlView setupView];
    searchControlView.delegate = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    isSearch = 0;
    [loadingIndicator stopAnimating];
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = searchControlView;
    myTableView.tableFooterView = footerView;
    
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
    titleLabel.text = titleString;//@"Danh Sách Bài Hát";
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

#pragma mark - Keyboard will show

- (void)keyboardWillShow:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^
     {
         UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
         [myTableView setContentInset:edgeInsets];
         [myTableView setScrollIndicatorInsets:edgeInsets];
     }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^
     {
         UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
         [myTableView setContentInset:edgeInsets];
         [myTableView setScrollIndicatorInsets:edgeInsets];
     }];
}

#pragma mark - Back Button Press

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
 
    searchControlView = nil;
    listTableItems = nil;
    myTableView = nil;
    loadingIndicator = nil;
    loadingBgView = nil;
    [super viewDidUnload];
}

- (void)searchSongWithKeyword:(NSString *)keyword
{
    DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
    Song *song = [[Song alloc] init];
    listSearch = [song searchSong:db.database WithText:keyword];
    isSearch = 1;
    [myTableView reloadData];
}

- (void)SearchControlViewWithKeyword:(NSString *)keyword
{
    if (keyword == nil || [keyword isEqualToString:@""] == TRUE)
    {
        [loadingIndicator stopAnimating];
        isSearch = 0;
        [myTableView reloadData];
    }
    else
    {
        [loadingIndicator startAnimating];
        
        if (self.type == kCategoryType_Song)
        {
            loadingBgView.hidden = NO;
            [[DatabaseManager databaseQueue] cancelAllOperations];
            NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(searchSongWithKeyword:) object:keyword];
            [[DatabaseManager databaseQueue] addOperation:operation];
            operation = nil;
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS %@ OR SELF.name CONTAINS %@ OR SELF.name CONTAINS %@",keyword, [keyword uppercaseString], [keyword capitalizedString]];
            listSearch = [listTableItems filteredArrayUsingPredicate:predicate];
            isSearch = 1;
            [myTableView reloadData];
        }
    }
}

#pragma mark - UITableViewCell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch == 1)
    {
        return [listSearch count];
    }
    return [listTableItems count];
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
    
    Song *song = nil;
    if (isSearch == 1)
    {
        song = [listSearch objectAtIndex:indexPath.row];
    }
    else
    {
        song = [listTableItems objectAtIndex:indexPath.row];
    }
    

    
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

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
    {
        if (self.type == kCategoryType_Song)
        {
            loadingBgView.hidden = YES;
        }
        [UIAppDelegate hiddenConnectionView];
        [loadingIndicator stopAnimating];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Song *song;
    if (isSearch == 0)
    {
        song = [listTableItems objectAtIndex:indexPath.row];
    }
    else
    {
        song = [listSearch objectAtIndex:indexPath.row];
    }
    
    if ([[UserDataManager sharedManager] filterPurcharseSongWithKey:song.tblID] == YES)
    {
        PlayerMusicViewController *viewController = [[PlayerMusicViewController alloc] init];
        
        if (isSearch == 0)
        {
            viewController.playerSong = [listTableItems objectAtIndex:indexPath.row];
        }
        else
        {
            viewController.playerSong = [listSearch objectAtIndex:indexPath.row];
        }
        
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
