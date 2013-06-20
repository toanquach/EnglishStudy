//
//  HotSongViewController.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/18/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "HotSongViewController.h"
#import "DatabaseManager.h"

@interface HotSongViewController ()
{
    __unsafe_unretained IBOutlet UITableView *myTableView;
    NSMutableArray *listTableItems;
}

- (void)setupView;

@end

@implementation HotSongViewController

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
    
    [DatabaseManager sharedDatabaseManager];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupView

- (void)setupView
{
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

#pragma mark - Back Button Press

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    myTableView = nil;
    [super viewDidUnload];
}

#pragma mark - UITableViewCell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listTableItems count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
