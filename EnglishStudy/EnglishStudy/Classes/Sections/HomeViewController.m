//
//  HomeViewController.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/6/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "HomeViewController.h"
#import "ESButton.h"

@interface HomeViewController ()
{
    __unsafe_unretained IBOutlet UIImageView *headerTextImageView;
    __unsafe_unretained IBOutlet UIImageView *mainBGImageView;
    __unsafe_unretained IBOutlet ESButton *bestSongButton;
    __unsafe_unretained IBOutlet ESButton *accountButton;
    __unsafe_unretained IBOutlet ESButton *favoritesButton;
    __unsafe_unretained IBOutlet ESButton *settingButton;
    __unsafe_unretained IBOutlet ESButton *purchaseButton;
    __unsafe_unretained IBOutlet ESButton *otherAppButton;
    __unsafe_unretained IBOutlet UITextField *searchTextField;
    __unsafe_unretained IBOutlet UIButton *searchButton;
    __unsafe_unretained IBOutlet UIButton *singerRadioButton;
    __unsafe_unretained IBOutlet UIImageView *singerRadioImageView;
    __unsafe_unretained IBOutlet UIImageView *songRadioImageView;
    __unsafe_unretained IBOutlet UIButton *songRadioButton;
    
    __unsafe_unretained IBOutlet UIView *containerButtonView;
    // ----------------------------------------------------
    int singerRadioButtonSelected;
    
    __unsafe_unretained IBOutlet UIImageView *bestSongExpandView;
    int isBestSongClick;
}

- (void)setupView;

// ------------------------------------------
- (IBAction)bestSongButtonClicked:(id)sender;
- (IBAction)singerRadioButtonClicked:(id)sender;
- (IBAction)songRadioButtonClicked:(id)sender;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    headerTextImageView = nil;
    mainBGImageView = nil;
    bestSongButton = nil;
    accountButton = nil;
    favoritesButton = nil;
    settingButton = nil;
    purchaseButton = nil;
    otherAppButton = nil;
    searchTextField = nil;
    searchButton = nil;
    singerRadioButton = nil;
    singerRadioImageView = nil;
    songRadioImageView = nil;
    songRadioButton = nil;
    containerButtonView = nil;
    bestSongExpandView = nil;
    [super viewDidUnload];
}

#pragma mark - setup View

- (void)setupView
{
    singerRadioButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    songRadioButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchTextField.delegate = self;
    //
    //      Set Singer Radio Button Selected
    //
    singerRadioButtonSelected = kRadioButton_Singer;
    singerRadioImageView.image = [UIImage imageNamed:kRadion_Checked_Image];
    
    if (IS_IPHONE_5)
    {
        CGRect frame = containerButtonView.frame;
        frame.origin.y +=44;
        containerButtonView.frame = frame;
    }
}

#pragma mark - Button Delegate

- (IBAction)bestSongButtonClicked:(id)sender
{
    if (bestSongButton.selected == YES)
    {
        [bestSongButton setBackgroundImage:[UIImage imageNamed:@"btn_hotsong_hover.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^
         {
             bestSongExpandView.frame = CGRectMake(154, 4, 0, 80);             
         }
         completion:^(BOOL finished)
         {
             bestSongExpandView.hidden = YES;
             [bestSongButton setBackgroundImage:[UIImage imageNamed:@"btn_icon_hotsongs.png"] forState:UIControlStateNormal];
         }];
    }
    else
    {
        // btn_hotsong_hover.png
        bestSongExpandView.hidden = NO;
        bestSongExpandView.frame = CGRectMake(154, 4, 0, 80);
        [bestSongButton setBackgroundImage:[UIImage imageNamed:@"btn_icon_hotsongs.png"] forState:UIControlStateSelected];
        
        [UIView animateWithDuration:0.5 animations:^
        {
            bestSongExpandView.frame = CGRectMake(154, 4, 154, 80);
        }
        completion:^(BOOL finished)
        {
            [bestSongButton setBackgroundImage:[UIImage imageNamed:@"btn_hotsong_hover.png"] forState:UIControlStateSelected];
        }];
        
    }
    
    bestSongButton.selected = !bestSongButton.selected;
}

- (IBAction)singerRadioButtonClicked:(id)sender
{
    singerRadioButtonSelected = kRadioButton_Singer;
    singerRadioImageView.image = [UIImage imageNamed:kRadion_Checked_Image];
    songRadioImageView.image = [UIImage imageNamed:kRadion_UnChecked_Image];
}

- (IBAction)songRadioButtonClicked:(id)sender
{
    singerRadioButtonSelected = kRadioButton_Song;
    songRadioImageView.image = [UIImage imageNamed:kRadion_Checked_Image];
    singerRadioImageView.image = [UIImage imageNamed:kRadion_UnChecked_Image];
}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //
    //      Search Item
    //
    return YES;
}

@end
