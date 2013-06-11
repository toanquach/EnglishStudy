//
//  ESFooterView.h
//  EnglishStudy
//
//  Created by Toan.Quach on 6/11/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESFooterView : UIView
{
    __unsafe_unretained IBOutlet UILabel *copyRightLabel;
    
}

- (void)setupView;

- (IBAction)shareFBButtonClicked:(id)sender;

@end
