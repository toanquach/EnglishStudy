//
//  NavDropDownMenuView.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/24/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavDropDownMenuView : UIView
{
    __unsafe_unretained IBOutlet UIButton *baiHotNhatButton;
    __unsafe_unretained IBOutlet UIButton *baiYeuThichButton;
    __unsafe_unretained IBOutlet UIButton *baiDaMuaButton;
    __unsafe_unretained IBOutlet UIButton *taiKhoanButton;
    __unsafe_unretained IBOutlet UIButton *caiDatButton;
    __unsafe_unretained IBOutlet UIButton *ungDungKhacButton;
    __unsafe_unretained IBOutlet UIButton *backgroundButton;
    
    double animateTime;
}

- (void)setupView;

- (void)setHiddenButton;

- (void)menuAnimateShow;

- (void)menuAnimateHide;

- (IBAction)backgroundButtonClicked:(id)sender;

// --- menu item clicked
- (IBAction)baiHotNhatButtonClicked:(id)sender;
- (IBAction)baiYeuThichButtonClicked:(id)sender;
- (IBAction)baiDaMuaButtonClicked:(id)sender;
- (IBAction)taiKhoanButtonClicked:(id)sender;
- (IBAction)caiDatButtonClicked:(id)sender;
- (IBAction)ungDungKhacButtonClicked:(id)sender;


@end
