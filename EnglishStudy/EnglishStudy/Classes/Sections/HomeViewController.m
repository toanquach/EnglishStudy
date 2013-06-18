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

}

- (void)setupView;
- (void)sendButtonToBack;
- (void)bringButtonToFront;

// ------------------------------------------
- (IBAction)bestSongButtonClicked:(id)sender;
- (IBAction)hotCategoryButtonClicked:(id)sender;
- (IBAction)hotSingerButtonClicked:(id)sender;
- (IBAction)hotSongButtonClicked:(id)sender;
- (IBAction)accountButtonClicked:(id)sender;

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
}

- (void)sendButtonToBack
{
    [containerButtonView sendSubviewToBack:accountButton];
}

- (void)bringButtonToFront
{
    [containerButtonView bringSubviewToFront:accountButton];
}

#pragma mark - Button Delegate

/*
    Best Song Button Click, slide submenu list button ON/OFF
 */

- (IBAction)bestSongButtonClicked:(id)sender
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
             
         }];    }
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

- (IBAction)hotCategoryButtonClicked:(id)sender
{
    HotSongViewController *viewController = [[HotSongViewController alloc]init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)hotSingerButtonClicked:(id)sender
{
    HotSongViewController *viewController = [[HotSongViewController alloc]init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)hotSongButtonClicked:(id)sender
{
    HotSongViewController *viewController = [[HotSongViewController alloc]init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (IBAction)accountButtonClicked:(id)sender
{
    AccountsViewController *viewController = [[AccountsViewController alloc]init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
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
