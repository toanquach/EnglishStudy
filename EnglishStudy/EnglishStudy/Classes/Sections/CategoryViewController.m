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

@interface CategoryViewController ()
{
    __unsafe_unretained IBOutlet UITableView *myTableView;
    SearchControlView *searchControlView;
    NSMutableArray *listItem;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{    
    myTableView = nil;
    [super viewDidUnload];
}

#pragma mark - Setup View

- (void)setupView
{
    searchControlView = [[[NSBundle mainBundle] loadNibNamed:@"SearchControlView" owner:self options:nil] objectAtIndex:0];
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = searchControlView;
    if (self.categotyType == kCategoryType_Category)
    {
        DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
        Category *cate = [[Category alloc]init];
        listItem = [cate getCategory:db.database];
        [myTableView reloadData];
    }
    else
    {
        
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
        titleLabel.text = @"Thể Loại";
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

#pragma mark - Datasource UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listItem count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Category *cate = [listItem objectAtIndex:indexPath.row];
    cell.textLabel.text = cate.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",cate.num_song];
    
    return cell;
}

@end
