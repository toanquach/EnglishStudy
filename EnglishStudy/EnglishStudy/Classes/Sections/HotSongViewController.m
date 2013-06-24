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

@interface HotSongViewController ()
{
    __unsafe_unretained IBOutlet UITableView *myTableView;
    SearchControlView *searchControlView;
    
    NSMutableArray *listTableItems;
    NSArray *listSearch;
    int isSearch;
}

- (void)setupView;

@end

@implementation HotSongViewController

@synthesize type, typeId;

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
    [UIAppDelegate hiddenConnectionView];
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
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = searchControlView;
    myTableView.tableFooterView = footerView;
    
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
    titleLabel.text = @"Danh Sách Bài Hát";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
 
    searchControlView = nil;
    listTableItems = nil;
    myTableView = nil;
    [super viewDidUnload];
}

- (void)SearchControlViewWithKeyword:(NSString *)keyword
{
    if (keyword == nil || [keyword isEqualToString:@""] == TRUE)
    {
        isSearch = 0;
        [myTableView reloadData];
    }
    else
    {
        if (self.type == kCategoryType_Song)
        {
            DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
            Song *song = [[Song alloc] init];
            listSearch = [song searchSong:db.database WithText:keyword];
            isSearch = 1;
            [myTableView reloadData];
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
    static NSString *cellIdentifier = @"CellIdentifier";
    
    SongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SongViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [cell setupViewWithSong:song];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerMusicViewController *viewController = [[PlayerMusicViewController alloc] init];
    viewController.playerSong = [listTableItems objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
