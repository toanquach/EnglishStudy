//
//  SettingsViewController.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/22/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    __unsafe_unretained IBOutlet UILabel *title01Label;
    __unsafe_unretained IBOutlet UILabel *title02Label;
    __unsafe_unretained IBOutlet UILabel *title03Label;
    __unsafe_unretained IBOutlet UILabel *title04Label;
    
    __unsafe_unretained IBOutlet UIButton *dangListButton;
    __unsafe_unretained IBOutlet UIButton *dangTungCauButton;
    __unsafe_unretained IBOutlet UIButton *banNgayButton;
    __unsafe_unretained IBOutlet UIButton *banDemButton;
    __unsafe_unretained IBOutlet UIButton *coNhoTextButton;
    __unsafe_unretained IBOutlet UIButton *coVuaTextButton;
    __unsafe_unretained IBOutlet UIButton *coLonTextButton;
    __unsafe_unretained IBOutlet UIButton *autoDownloadButton;
    __unsafe_unretained IBOutlet UIButton *manualDownloadButton;
    
    __unsafe_unretained IBOutlet UIImageView *dangListImageView;
    __unsafe_unretained IBOutlet UIImageView *dangTungCauImageView;
    __unsafe_unretained IBOutlet UIImageView *banNgayImageView;
    __unsafe_unretained IBOutlet UIImageView *banDemImageView;
    __unsafe_unretained IBOutlet UIImageView *coNhoImageView;
    __unsafe_unretained IBOutlet UIImageView *coVuaImageView;
    __unsafe_unretained IBOutlet UIImageView *coLonImageView;
    __unsafe_unretained IBOutlet UIImageView *autoDownloadImageView;
    __unsafe_unretained IBOutlet UIImageView *manualDownloadImageView;
    
    int displayType;
    int displayStyle;
    int displayTextSizeType;
    int autoDownload;
}

- (void)setupView;
- (IBAction)group01ButtonClicked:(id)sender;
- (IBAction)group02ButtonClicked:(id)sender;
- (IBAction)group03ButtonClicked:(id)sender;
- (IBAction)group04ButtonClicked:(id)sender;

@end

@implementation SettingsViewController

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

#pragma mark - setup View

- (void)setupView
{
    title01Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    title02Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    title03Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    title04Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    
    dangListButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    dangTungCauButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    banNgayButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    banDemButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    coNhoTextButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    coVuaTextButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    coLonTextButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    autoDownloadButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    manualDownloadButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    
    dangListButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    dangTungCauButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    banNgayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    banDemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    coNhoTextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    coVuaTextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    coLonTextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    displayType = [userDefaults integerForKey:kSetting_Display_Type];
    displayStyle = [userDefaults integerForKey:kSetting_Display_Style];
    displayTextSizeType = [userDefaults integerForKey:kSetting_Text_Size];
    autoDownload = [userDefaults integerForKey:kSetting_Auto_Download];
    
    if (displayType == 0)
    {
        dangListImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        dangListButton.selected = YES;
    }
    else
    {
        dangTungCauButton.selected = YES;
        dangTungCauImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
    }
    
    if (displayStyle == 0)
    {
        banNgayImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        banNgayButton.selected = YES;
    }
    else
    {
        banDemImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        banDemButton.selected = YES;
    }
    
    if (displayTextSizeType == 0)
    {
        displayTextSizeType = 2;
    }
    
    if (displayTextSizeType == 1)
    {
        coLonImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coLonTextButton.selected = YES;
    }
    else if(displayTextSizeType == 2)
    {
        coVuaImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coVuaTextButton.selected = YES;
    }
    else if(displayTextSizeType == 3)
    {
        coNhoImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coNhoTextButton.selected = YES;
    }
    
    if (autoDownload == 0)
    {
        autoDownloadImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        autoDownloadButton.selected = YES;
    }
    else
    {
        manualDownloadImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        manualDownloadButton.selected = YES;
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
    titleLabel.text = @"Cài Đặt";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
}

- (IBAction)group01ButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button == dangTungCauButton)
    {
        // set to dang tung cau display
        displayType = kSetting_Display_TungCau;
        dangTungCauButton.selected = YES;
        dangTungCauImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        dangListButton.selected = NO;
        dangListImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else
    {
        displayType = kSetting_Display_List;
        dangTungCauButton.selected = NO;
        dangTungCauImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        dangListButton.selected = YES;
        dangListImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:displayType forKey:kSetting_Display_Type];
    [userDefaults synchronize];
}

- (IBAction)group02ButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button == banDemButton)
    {
        // set to dang tung cau display
        displayStyle = kSetting_BanDem;
        banDemButton.selected = YES;
        banDemImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        banNgayButton.selected = NO;
        banNgayImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else
    {
        displayStyle = kSetting_BanNgay;
        banDemButton.selected = NO;
        banDemImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        banNgayButton.selected = YES;
        banNgayImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:displayStyle forKey:kSetting_Display_Style];
    [userDefaults synchronize];
}

- (IBAction)group03ButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button == coNhoTextButton)
    {
        displayTextSizeType = kSetting_CoNho;
        coNhoTextButton.selected = YES;
        coNhoImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coVuaTextButton.selected = NO;
        coVuaImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        coLonTextButton.selected = NO;
        coLonImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else if(button == coVuaTextButton)
    {
        displayTextSizeType = kSetting_CoVua;
        coVuaTextButton.selected = YES;
        coVuaImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coNhoTextButton.selected = NO;
        coNhoImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        coLonTextButton.selected = NO;
        coLonImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else
    {
        displayTextSizeType = kSetting_CoLon;
        coLonTextButton.selected = YES;
        coLonImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coVuaTextButton.selected = NO;
        coVuaImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        coNhoTextButton.selected = NO;
        coNhoImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:displayTextSizeType forKey:kSetting_Text_Size];
    [userDefaults synchronize];
}

- (IBAction)group04ButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button == autoDownloadButton)
    {
        // set to dang tung cau display
        autoDownload = kSetting_AutoDL;
        autoDownloadImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        autoDownloadButton.selected = YES;
        manualDownloadImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        manualDownloadButton.selected = NO;
    }
    else
    {
        autoDownload = kSetting_ManualDL;
        autoDownloadImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        autoDownloadButton.selected = NO;
        manualDownloadButton.selected = YES;
        manualDownloadImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:autoDownload forKey:kSetting_Auto_Download];
    [userDefaults synchronize];
}

#pragma mark - UIBUtton event

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    title01Label = nil;
    title02Label = nil;
    title02Label = nil;
    title03Label = nil;
    title02Label = nil;
    dangListButton = nil;
    dangTungCauButton = nil;
    banNgayButton = nil;
    banDemButton = nil;
    coNhoTextButton = nil;
    coVuaTextButton = nil;
    coLonTextButton = nil;
    dangListImageView = nil;
    dangTungCauImageView = nil;
    banNgayImageView = nil;
    banDemImageView = nil;
    coNhoImageView = nil;
    coVuaImageView = nil;
    coLonImageView = nil;
    title04Label = nil;
    autoDownloadImageView = nil;
    autoDownloadButton = nil;
    manualDownloadImageView = nil;
    manualDownloadButton = nil;
    [super viewDidUnload];
}

/*
 [6/24/13 12:23:54 PM] Android - Hieu Le Trung: xu = view / 1000 + 10 (chia lay nguyen)
 [6/24/13 12:24:03 PM] Android - Hieu Le Trung: if xu > 100 then xu = 100
 [6/24/13 12:24:09 PM] Android - Hieu Le Trung: --
 */
@end
