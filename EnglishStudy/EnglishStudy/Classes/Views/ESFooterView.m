//
//  ESFooterView.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/11/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "ESFooterView.h"

@implementation ESFooterView

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
    copyRightLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:12];
}

- (IBAction)shareFBButtonClicked:(id)sender
{
    [UIAppDelegate checkFBSession];
    //[UIAppDelegate showAlertView:nil andMessage:@"Share FB Button Clicked"];
}

@end
