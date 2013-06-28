//
//  AccountsViewController.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/18/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "AccountsViewController.h"
#import "LoadMoneyViewController.h"

@interface AccountsViewController ()
{
    __unsafe_unretained IBOutlet UILabel *title01Label;
    __unsafe_unretained IBOutlet UILabel *title011Label;
    __unsafe_unretained IBOutlet UILabel *title02Label;
    __unsafe_unretained IBOutlet UILabel *title03Label;
    
    __unsafe_unretained IBOutlet UIButton *loadMoneyButton;
    __unsafe_unretained IBOutlet UIWebView *shareFacebookWebview;
    __unsafe_unretained IBOutlet UIWebView *loadMoneyWebView;
    
    __unsafe_unretained IBOutlet UIScrollView *mainScrollView;
}

- (void)setupView;

- (IBAction)loadMoneyButtonClicked:(id)sender;

- (IBAction)shareFacebookButtonClicked:(id)sender;
@end

@implementation AccountsViewController

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
}

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
    titleLabel.text = @"Tài Khoản";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    titleLabel = nil;
    
    // ---------------------------
    //      Custom style control
    //
    title011Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:17];
    title01Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:17];
    title02Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:17];
    title03Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:17];
    
    title011Label.textColor = [UIColor colorWithRed:255.0f/255.0f green:211.0f/255.0f blue:3.0f/255.0f alpha:1];
    title011Label.text = [NSString stringWithFormat:@"%dxu",[[UserDataManager sharedManager] getCoinUser]];
    title02Label.text = [NSString stringWithFormat:@"Bạn đã mua %d bài hát",[[UserDataManager sharedManager] getNumSongPurcharse]];
    
    loadMoneyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    loadMoneyButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    [loadMoneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *html = @"<html><head><style type=\"text/css\">body {margin: 0.0px 0.0px 0.0px 0.0px;font: 12.0px Klavika-Regular; min-height: 20.0px; color:#fff;}div{line-height:20px; word-spacing:-1px;} </style></head><body><div>Share Facebook cho bài hát, mỗi lần share Facebook bạn được cộng <font color=\"#ffd303\">100 xu</font> (mỗi ngày bạn chỉ được share Facebook một lần)</div></body></html>";
    [shareFacebookWebview loadHTMLString:html baseURL:nil];
    
    [shareFacebookWebview setBackgroundColor:[UIColor clearColor]];
    [shareFacebookWebview setOpaque:NO];
    
    for(UIView *mView in shareFacebookWebview.subviews)
    {
        if ([mView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)mView).scrollEnabled = NO;
        }
    }
    
    NSString *html2 = @"<html><head><style type=\"text/css\">body {margin: 0.0px 0.0px 0.0px 0.0px;font: 12.0px Klavika-Regular; min-height: 20.0px; color:#fff;}div{line-height:20px; word-spacing:-1px; align:center;text-align:center;} </style></head><body><div>Nạp thẻ cào, bạn có thể dùng thẻ Mobifone, Vinaphone, Viettel tất cả mệnh giá. Nạp <font color=\"#ffd303\">1000 đồng</font>  bạn sẽ được <font color=\"#ffd303\">100 xu</font></div></body></html>";
    [loadMoneyWebView loadHTMLString:html2 baseURL:nil];
    [loadMoneyWebView setBackgroundColor:[UIColor clearColor]];
    [loadMoneyWebView setOpaque:NO];
    
    for(UIView *mView in loadMoneyWebView.subviews)
    {
        if ([mView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)mView).scrollEnabled = NO;
        }
    }
    
    mainScrollView.contentSize = CGSizeMake(320, 460);
}


#pragma mark - Back Button Press

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loadMoneyButtonClicked:(id)sender
{
    LoadMoneyViewController *viewController = [[LoadMoneyViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)shareFacebookButtonClicked:(id)sender
{
    [UIAppDelegate checkFBSession];
}

- (void)viewDidUnload
{
    title01Label = nil;
    title011Label = nil;
    title02Label = nil;
    loadMoneyButton = nil;
    title03Label = nil;
    shareFacebookWebview = nil;
    loadMoneyWebView = nil;
    mainScrollView = nil;
    [super viewDidUnload];
}
@end
