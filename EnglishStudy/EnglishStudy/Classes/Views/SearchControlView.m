//
//  SearchControlView.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/21/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "SearchControlView.h"

@implementation SearchControlView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setupView
{
    searchTextField.text = @"";
    searchTextField.placeholder = @"Searching...";
    delaySearchUntilQueryUnchangedForTimeOffset = 0.4 * NSEC_PER_SEC;
}

- (IBAction)clearButtonClicked:(id)sender
{
    searchTextField.text = @"";
    [delegate SearchControlViewWithKeyword:@""];
}

#pragma mark - UITextfield Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    searchImageView.image = [UIImage imageNamed:@"bgd_textbox_1.png"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    searchImageView.image = [UIImage imageNamed:@"bgd_textbox_2.png"];    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //
    // waiting when user pressing
    //
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySearchUntilQueryUnchangedForTimeOffset);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [delegate SearchControlViewWithKeyword:resultStr];
    });
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [delegate SearchControlViewWithKeyword:textField.text];
    return YES;
}

@end
