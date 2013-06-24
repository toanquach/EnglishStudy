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
#import "SongViewCell.h"

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
    
    dispatch_time_t delaySearchUntilQueryUnchangedForTimeOffset;
    
    NSMutableArray *listItem;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *loadingIndicator;
}

- (void)setupView;
- (void)sendButtonToBack;
- (void)bringButtonToFront;
- (void)slideOnOffMenuButton:(BOOL)flag;
- (void)searchSongWithText:(NSString *)keyword;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    
    delaySearchUntilQueryUnchangedForTimeOffset = 0.4 * NSEC_PER_SEC;
}

- (void)sendButtonToBack
{
    [containerButtonView sendSubviewToBack:accountButton];
}

- (void)bringButtonToFront
{
    [containerButtonView bringSubviewToFront:accountButton];
}

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
    [UIAppDelegate showConnectionView];
    [self slideOnOffMenuButton:YES];
    CategoryViewController *viewController = [[CategoryViewController alloc]init];
    viewController.categotyType = kCategoryType_Category;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)hotSingerButtonClicked:(id)sender
{
    [UIAppDelegate showConnectionView];
    [self slideOnOffMenuButton:YES];
    CategoryViewController *viewController = [[CategoryViewController alloc]init];
    viewController.categotyType = kCategoryType_Singer;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)hotSongButtonClicked:(id)sender
{
    [UIAppDelegate showConnectionView];
    [self slideOnOffMenuButton:YES];
    HotSongViewController *viewController = [[HotSongViewController alloc]init];
    viewController.type = kCategoryType_Song;
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
    [loadingIndicator startAnimating];
    //
    // waiting when user pressing
    //
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySearchUntilQueryUnchangedForTimeOffset);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
   {
       [self searchSongWithText:resultStr];
   });
    
    return YES;
}

- (void)searchSongWithText:(NSString *)keyword
{
    if (keyword == nil || [keyword isEqualToString:@""] == TRUE)
    {
        searchBgView.hidden = YES;
    }
    else
    {
        searchBgView.hidden = NO;
        DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
        Song *song = [[Song alloc] init];
        listItem = [song searchSong:db.database WithText:keyword];
        [searchTableView reloadData];
        //[loadingIndicator stopAnimating];
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
    }
    
    Song *song = nil;
    song = [listItem objectAtIndex:indexPath.row];
    [cell setupViewWithSong:song];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PlayerMusicViewController *viewController = [[PlayerMusicViewController alloc] init];
//    viewController.playerSong = [listTableItems objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:viewController animated:YES];
//    viewController = nil;
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
