//
//  LoadMoneyViewController.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/18/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "LoadMoneyViewController.h"

@interface LoadMoneyViewController ()
{
    __unsafe_unretained IBOutlet UILabel *thecaoLabel;
    __unsafe_unretained IBOutlet UILabel *soSeriesLabel;
    __unsafe_unretained IBOutlet UILabel *nhaMangLabel;
    __unsafe_unretained IBOutlet UILabel *emailLabel;
    
    __unsafe_unretained IBOutlet UITextField *theCaoTextField;
    __unsafe_unretained IBOutlet UITextField *soSeriesTextField;
    __unsafe_unretained IBOutlet UIButton *nhaMangButton;
    __unsafe_unretained IBOutlet UITextField *emailTextField;
    __unsafe_unretained IBOutlet UIButton *agreeCheckBoxButton;
    __unsafe_unretained IBOutlet UIWebView *agreeWebView;
    
    __unsafe_unretained IBOutlet UIButton *napXuButton;
    
    
    __unsafe_unretained IBOutlet UIView *pickerBGView;
    __unsafe_unretained IBOutlet UIPickerView *nhaMangPickerView;
    __unsafe_unretained IBOutlet UIScrollView *mainScrollView;
    
    NSMutableArray *listNhaMang;
    int selectNhaMangIndex;
}

- (void)setupView;

- (IBAction)nhaMangButtonClicked:(id)sender;
- (IBAction)soSeriesInfoButtonClicked:(id)sender;
- (IBAction)emailInfoButtonClicked:(id)sender;
- (IBAction)napXuButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)checkArgeeButtonClicked:(id)sender;
@end

@implementation LoadMoneyViewController

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

#pragma mark - Setup View

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
    titleLabel.text = @"Nạp Xu";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor =[UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
    titleLabel = nil;
    
    //
    //          Style for control
    //
    thecaoLabel.font = [UIFont fontWithName:kFont_Klavika_Medium size:16];
    soSeriesLabel.font = [UIFont fontWithName:kFont_Klavika_Medium size:16];
    nhaMangLabel.font = [UIFont fontWithName:kFont_Klavika_Medium size:16];
    emailLabel.font = [UIFont fontWithName:kFont_Klavika_Medium size:16];
    
    theCaoTextField.font = [UIFont fontWithName:kFont_Klavika_Medium size:14];
    soSeriesTextField.font = [UIFont fontWithName:kFont_Klavika_Medium size:14];
    emailTextField.font = [UIFont fontWithName:kFont_Klavika_Medium size:14];
    
    nhaMangButton.titleEdgeInsets = UIEdgeInsetsMake(2, -230, 0, 0);
    nhaMangButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:14];
    
    theCaoTextField.textColor = [UIColor whiteColor];
    soSeriesTextField.textColor = [UIColor whiteColor];
    emailTextField.textColor = [UIColor whiteColor];
    
    theCaoTextField.delegate = self;
    soSeriesTextField.delegate = self;
    emailTextField.delegate = self;
    
    NSString *html = @"<html><head><style type=\"text/css\">body {margin: 0.0px 0.0px 0.0px 0.0px;font: 16.0px Klavika-Medium; color:#fff;}div{line-height:20px; word-spacing:-1px; align:center;text-align:center;} </style></head><body><div>Bạn đồng ý với các <font color=\"#e069f6\" style=\"text-decoration:underline;\">điều khoản nạp thẻ</font></div></body></html>";
    [agreeWebView loadHTMLString:html baseURL:nil];
    [agreeWebView setBackgroundColor:[UIColor clearColor]];
    [agreeWebView setOpaque:NO];
    
    napXuButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    [napXuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    pickerBGView.hidden = YES;
    
    listNhaMang = [NSMutableArray arrayWithObjects:@"Vinaphone",@"Mobiphone",@"Viettel", nil];
    selectNhaMangIndex = 0;
    [nhaMangButton setTitle:@"Vinaphone" forState:UIControlStateNormal];
    [napXuButton setTitle:@"NẠP XU" forState:UIControlStateNormal];
    
    mainScrollView.contentSize = CGSizeMake(320, napXuButton.frame.origin.y + napXuButton.frame.size.height + 110);
    
    mainScrollView.contentSize = CGSizeMake(320, 480);
}

#pragma mark - Keyboard will show

- (void)keyboardWillShow:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^
     {
         UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
         [mainScrollView setContentInset:edgeInsets];
         [mainScrollView setScrollIndicatorInsets:edgeInsets];
     }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^
     {
         UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
         [mainScrollView setContentInset:edgeInsets];
         [mainScrollView setScrollIndicatorInsets:edgeInsets];
     }];
}

#pragma mark - Button Event

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)nhaMangButtonClicked:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    pickerBGView.hidden = NO;
    [nhaMangPickerView reloadComponent:0];
    [nhaMangPickerView selectRow:selectNhaMangIndex inComponent:0 animated:YES];
}

- (IBAction)soSeriesInfoButtonClicked:(id)sender
{
    [UIAppDelegate showAlertView:nil andMessage:@"series button clicked"];
}

- (IBAction)emailInfoButtonClicked:(id)sender
{
    [UIAppDelegate showAlertView:nil andMessage:@"email button clicked"];    
}

- (IBAction)napXuButtonClicked:(id)sender
{
    // Call service
}

- (IBAction)closeButtonClicked:(id)sender
{
    selectNhaMangIndex = [nhaMangPickerView selectedRowInComponent:0];
    pickerBGView.hidden = YES;
    [nhaMangButton setTitle:[listNhaMang objectAtIndex:selectNhaMangIndex] forState:UIControlStateNormal];
}

- (IBAction)checkArgeeButtonClicked:(id)sender
{
    agreeCheckBoxButton.selected = !agreeCheckBoxButton.selected;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    pickerBGView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == theCaoTextField)
    {
        [theCaoTextField resignFirstResponder];
        [soSeriesTextField becomeFirstResponder];
    }
    else if(textField == soSeriesTextField)
    {
        [soSeriesTextField resignFirstResponder];
        [emailTextField becomeFirstResponder];
    }
    else if(emailTextField == textField)
    {
        [emailTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextField Delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [listNhaMang count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [listNhaMang objectAtIndex:row];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
 
    
    thecaoLabel = nil;
    soSeriesLabel = nil;
    nhaMangLabel = nil;
    emailLabel = nil;
    theCaoTextField = nil;
    soSeriesTextField = nil;
    nhaMangButton = nil;
    emailLabel = nil;
    agreeCheckBoxButton = nil;
    emailTextField = nil;
    agreeWebView = nil;
    napXuButton = nil;
    pickerBGView = nil;
    nhaMangPickerView = nil;
    mainScrollView = nil;
    [super viewDidUnload];
}
@end
