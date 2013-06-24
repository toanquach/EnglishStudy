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
    
    __unsafe_unretained IBOutlet UIButton *dangListButton;
    __unsafe_unretained IBOutlet UIButton *dangTungCauButton;
    __unsafe_unretained IBOutlet UIButton *banNgayButton;
    __unsafe_unretained IBOutlet UIButton *banDemButton;
    __unsafe_unretained IBOutlet UIButton *coNhoTextButton;
    __unsafe_unretained IBOutlet UIButton *coVuaTextButton;
    __unsafe_unretained IBOutlet UIButton *coLonTextButton;
    
    __unsafe_unretained IBOutlet UIImageView *dangListImageView;
    __unsafe_unretained IBOutlet UIImageView *dangTungCauImageView;
    __unsafe_unretained IBOutlet UIImageView *banNgayImageView;
    __unsafe_unretained IBOutlet UIImageView *banDemImageView;
    __unsafe_unretained IBOutlet UIImageView *coNhoImageView;
    __unsafe_unretained IBOutlet UIImageView *coVuaImageView;
    __unsafe_unretained IBOutlet UIImageView *coLonImageView;
    
    int displayType;
    int displayStyle;
    int displayTextSizeType;
    
}

- (void)setupView;
- (IBAction)group01ButtonClicked:(id)sender;
- (IBAction)group02ButtonClicked:(id)sender;
- (IBAction)group03ButtonClicked:(id)sender;

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
    
    dangListButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    dangTungCauButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    banNgayButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    banDemButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    coNhoTextButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    coVuaTextButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    coLonTextButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    
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
        coLonImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coLonTextButton.selected = YES;
    }
    else if(displayTextSizeType == 1)
    {
        coVuaImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coVuaTextButton.selected = YES;
    }
    else
    {
        coNhoImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coNhoTextButton.selected = YES;
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
    if (displayType == 0)
    {
        // set to dang tung cau display
        displayType = 1;
        dangTungCauButton.selected = YES;
        dangTungCauImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        dangListButton.selected = NO;
        dangListImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else
    {
        displayType = 0;
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
    if (displayStyle == 0)
    {
        // set to dang tung cau display
        displayStyle = 1;
        banDemButton.selected = YES;
        banDemImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        banNgayButton.selected = NO;
        banNgayImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else
    {
        displayStyle = 0;
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
        displayTextSizeType = 2;
        coNhoTextButton.selected = YES;
        coNhoImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coVuaTextButton.selected = NO;
        coVuaImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        coLonTextButton.selected = NO;
        coLonImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else if(button == coVuaTextButton)
    {
        displayTextSizeType = 1;
        coVuaTextButton.selected = YES;
        coVuaImageView.image = [UIImage imageNamed:kRadio_Checked_Image];
        coNhoTextButton.selected = NO;
        coNhoImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
        coLonTextButton.selected = NO;
        coLonImageView.image = [UIImage imageNamed:kRadio_UnChecked_Image];
    }
    else
    {
        displayTextSizeType = 0;
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

#pragma mark - UIBUtton event

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
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
    [super viewDidUnload];
}

/*
 [6/24/13 12:23:54 PM] Android - Hieu Le Trung: xu = view / 1000 + 10 (chia lay nguyen)
 [6/24/13 12:24:03 PM] Android - Hieu Le Trung: if xu > 100 then xu = 100
 [6/24/13 12:24:09 PM] Android - Hieu Le Trung: --
 */
@end
