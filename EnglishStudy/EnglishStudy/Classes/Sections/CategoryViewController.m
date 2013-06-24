//
//  CategoryViewController.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/21/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "CategoryViewController.h"

#import "DatabaseManager.h"
// The loai ban hat
#import "Category.h"
#import "Singer.h"

#import "CategoryViewCell.h"

#import "HotSongViewController.h"


@interface CategoryViewController ()
{
    __unsafe_unretained IBOutlet UITableView *myTableView;
    SearchControlView *searchControlView;
    NSMutableArray *listItem;
    NSArray *listSearchItem;
    int isSearch;
}

- (void)setupView;

@end

@implementation CategoryViewController

@synthesize categotyType;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
 
    searchControlView = nil;
    listItem = nil;
    myTableView = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIAppDelegate hiddenConnectionView];
}

#pragma mark - Setup View

- (void)setupView
{
    searchControlView = [[[NSBundle mainBundle] loadNibNamed:@"SearchControlView" owner:self options:nil] objectAtIndex:0];
    searchControlView.frame = CGRectMake(0, 0, 320, 39);
    [searchControlView setupView];
    searchControlView.delegate = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = searchControlView;
    myTableView.tableFooterView = footerView;
    isSearch = 0;
    
    if (self.categotyType == kCategoryType_Category)
    {
        DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
        Category *cate = [[Category alloc]init];
        listItem = [cate getCategory:db.database];
        [myTableView reloadData];
    }
    else
    {
        DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
        Singer *singer = [[Singer alloc]init];
        listItem = [singer getSinger:db.database];
        [myTableView reloadData];
    }
    
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
    if (self.categotyType == kCategoryType_Category)
    {
        titleLabel.text = @"Danh Mục";
    }
    else
    {
        titleLabel.text = @"Ca Sĩ";
    }
    
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

#pragma mark - Datasource UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch == 1)
    {
        return [listSearchItem count];
    }
    return [listItem count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    CategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (self.categotyType == kCategoryType_Category)
    {
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryViewCell2" owner:self options:nil] objectAtIndex:0];
        }
        Category *cate = nil;
        if (isSearch == 1)
        {
            cate = [listSearchItem objectAtIndex:indexPath.row];
        }
        else
        {
            cate = [listItem objectAtIndex:indexPath.row];
        }
        [cell setupViewWithCategory:cate];
    }
    else
    {
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        Singer *singer = nil;
        if (isSearch == 1)
        {
            singer = [listSearchItem objectAtIndex:indexPath.row];
        }
        else
        {
            singer = [listItem objectAtIndex:indexPath.row];
        }
        
        [cell setupViewWithSinger:singer];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSongViewController *viewController = [[HotSongViewController alloc] init];
    viewController.type = self.categotyType;
    if (self.categotyType == kCategoryType_Category)
    {
        Category *cate = [listItem objectAtIndex:indexPath.row];
        viewController.typeId = cate.tblID;
    }
    else
    {
        Singer *singer = [listItem objectAtIndex:indexPath.row];
        viewController.typeId = singer.tblID;
    }
    
    [UIAppDelegate showConnectionView];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIBUtton event

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SearchControlView - Delegate

- (void)SearchControlViewWithKeyword:(NSString *)keyword
{
    if (keyword == nil || [keyword isEqualToString:@""] == TRUE)
    {
        isSearch = 0;
        [myTableView reloadData];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS %@ OR SELF.name CONTAINS %@ OR SELF.name CONTAINS %@", keyword, [keyword uppercaseString], [keyword capitalizedString]];
        listSearchItem  = [listItem filteredArrayUsingPredicate:predicate];
        isSearch = 1;
        [myTableView reloadData];
    }
}

@end
