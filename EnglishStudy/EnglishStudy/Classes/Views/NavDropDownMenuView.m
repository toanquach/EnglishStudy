//
//  NavDropDownMenuView.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/24/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "NavDropDownMenuView.h"

#import "HotSongViewController.h"
#import "AccountsViewController.h"
#import "CategoryViewController.h"
#import "PurchaseViewController.h"
#import "FavoritesViewController.h"
#import "SettingsViewController.h"
#import "PlayerMusicViewController.h"

@implementation NavDropDownMenuView

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
    baiHotNhatButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:13];
    taiKhoanButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:13];
    baiYeuThichButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:13];
    caiDatButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:13];
    baiDaMuaButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:13];
    ungDungKhacButton.titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:13];
    
    baiHotNhatButton.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    taiKhoanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    baiYeuThichButton.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    caiDatButton.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    baiDaMuaButton.titleEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
    ungDungKhacButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    animateTime = 0.025;
}

- (void)setHiddenButton
{
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            ((UIButton *)subView).hidden = YES;
        }
    }
    
    [self viewWithTag:110].hidden = NO;
}

- (void)menuAnimateShow
{
    [self setHiddenButton];
    
    baiHotNhatButton.hidden = NO;
    CGRect rect = baiHotNhatButton.frame;
    rect.size.height = 1;
    baiHotNhatButton.frame = rect;
    // Bai Hot Nhat > Bai Yeu Thick > Bai Da Mua > Tai Khoan > Cai Dat > Ung dung khac
    //
    //      set anime Hot Button
    //
    [UIView animateWithDuration:animateTime animations:^{
        CGRect rect = baiHotNhatButton.frame;
        rect.size.height = 31;
        baiHotNhatButton.frame = rect;
    }completion:^(BOOL finished){
        //
        //      set anime Account Button
        //
        baiYeuThichButton.hidden = NO;
        CGRect rect = baiYeuThichButton.frame;
        rect.size.height = 1;
        baiYeuThichButton.frame = rect;
        [UIView animateWithDuration:animateTime animations:^{
            CGRect rect = baiYeuThichButton.frame;
            rect.size.height = 31;
            baiYeuThichButton.frame = rect;
        }completion:^(BOOL finished){
            //
            //      set anime Favorite Button
            //
            baiDaMuaButton.hidden = NO;
            CGRect rect = baiDaMuaButton.frame;
            rect.size.height = 1;
            baiDaMuaButton.frame = rect;
            [UIView animateWithDuration:animateTime animations:^{
                CGRect rect = baiDaMuaButton.frame;
                rect.size.height = 31;
                baiDaMuaButton.frame = rect;
            }completion:^(BOOL finished){
                //
                //      set anime Account Button
                //
                taiKhoanButton.hidden = NO;
                CGRect rect = taiKhoanButton.frame;
                rect.size.height = 1;
                taiKhoanButton.frame = rect;
                [UIView animateWithDuration:animateTime animations:^{
                    CGRect rect = taiKhoanButton.frame;
                    rect.size.height = 31;
                    taiKhoanButton.frame = rect;
                }completion:^(BOOL finished){
                    //
                    //      set anime CaiDat Button
                    //
                    caiDatButton.hidden = NO;
                    CGRect rect = caiDatButton.frame;
                    rect.size.height = 1;
                    caiDatButton.frame = rect;
                    [UIView animateWithDuration:animateTime animations:^{
                        CGRect rect = caiDatButton.frame;
                        rect.size.height = 31;
                        caiDatButton.frame = rect;
                    }completion:^(BOOL finished){
                        //
                        //      set anime Ung dung khac Button
                        //
                        ungDungKhacButton.hidden = NO;
                        CGRect rect = ungDungKhacButton.frame;
                        rect.size.height = 1;
                        ungDungKhacButton.frame = rect;
                        [UIView animateWithDuration:animateTime animations:^{
                            CGRect rect = ungDungKhacButton.frame;
                            rect.size.height = 32;
                            ungDungKhacButton.frame = rect;
                        }completion:^(BOOL finished)
                        {
                            //
                            //      set anime Account Button
                            //
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)menuAnimateHide
{
    // Bai Hot Nhat > Bai Yeu Thick > Bai Da Mua > Tai Khoan > Cai Dat > Ung dung khac
    //
    //      set anime Hot Button
    //
    [UIView animateWithDuration:animateTime animations:^{
        CGRect rect = ungDungKhacButton.frame;
        rect.size.height = 1;
        ungDungKhacButton.frame = rect;
    }completion:^(BOOL finished){
        //
        //      set anime ung dung khac Button
        //
        ungDungKhacButton.hidden = YES;
        [UIView animateWithDuration:animateTime animations:^{
            CGRect rect = caiDatButton.frame;
            rect.size.height = 1;
            caiDatButton.frame = rect;
        }completion:^(BOOL finished){
            //
            //      set anime cai dat Button
            //
            caiDatButton.hidden = YES;
            [UIView animateWithDuration:animateTime animations:^{
                CGRect rect = taiKhoanButton.frame;
                rect.size.height = 1;
                taiKhoanButton.frame = rect;
            }completion:^(BOOL finished){
                //
                //      set anime Account Button
                //
                taiKhoanButton.hidden = YES;
                [UIView animateWithDuration:animateTime animations:^{
                    CGRect rect = baiDaMuaButton.frame;
                    rect.size.height = 1;
                    baiDaMuaButton.frame = rect;
                }completion:^(BOOL finished){
                    //
                    //      set anime CaiDat Button
                    //
                    baiDaMuaButton.hidden = YES;
                    [UIView animateWithDuration:animateTime animations:^{
                        CGRect rect = baiYeuThichButton.frame;
                        rect.size.height = 1;
                        baiYeuThichButton.frame = rect;
                    }completion:^(BOOL finished){
                        //
                        //      set anime Ung dung khac Button
                        //
                        baiYeuThichButton.hidden = YES;
                        [UIView animateWithDuration:animateTime animations:^{
                            CGRect rect = baiHotNhatButton.frame;
                            rect.size.height = 1;
                            baiHotNhatButton.frame = rect;
                        }completion:^(BOOL finished)
                         {
                             //
                             //      set anime Account Button
                             //
                             baiHotNhatButton.hidden = YES;
                             self.hidden = YES;
                         }];
                    }];
                }];
            }];
        }];
    }];
}

- (IBAction)backgroundButtonClicked:(id)sender
{
    if (UIAppDelegate.isMenuShow == 0)
    {
        UIAppDelegate.navDropDownMenu.hidden = NO;
        [UIAppDelegate.navDropDownMenu menuAnimateShow];
        UIAppDelegate.isMenuShow = 1;
    }
    else
    {
        [UIAppDelegate.navDropDownMenu menuAnimateHide];
        UIAppDelegate.isMenuShow = 0;
    }
}

- (IBAction)baiHotNhatButtonClicked:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Bài Hot Nhầt" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:@"Tên Ca Sĩ", @"Danh Mục", @"Tên Bài Hát", nil];
    [alertView show];
    alertView= nil;
}

- (IBAction)baiYeuThichButtonClicked:(id)sender
{
    if ([UIAppDelegate.navigationController.topViewController isKindOfClass:[FavoritesViewController class]])
    {
        return;
    }
    
    [UIAppDelegate.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)baiDaMuaButtonClicked:(id)sender
{
    if ([UIAppDelegate.navigationController.topViewController isKindOfClass:[PurchaseViewController class]])
    {
        return;
    }
    
    [UIAppDelegate.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)taiKhoanButtonClicked:(id)sender
{
    if ([UIAppDelegate.navigationController.topViewController isKindOfClass:[AccountsViewController class]])
    {
        return;
    }
    
    [UIAppDelegate.navigationController popToRootViewControllerAnimated:NO];
    AccountsViewController *viewController = [[AccountsViewController alloc]init];
    [UIAppDelegate.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
    UIAppDelegate.isMenuShow = 0;
    self.hidden = YES;
}

- (IBAction)caiDatButtonClicked:(id)sender
{
    if ([UIAppDelegate.navigationController.topViewController isKindOfClass:[SettingsViewController class]])
    {
        return;
    }
    
    [UIAppDelegate.navigationController popToRootViewControllerAnimated:NO];
    SettingsViewController *viewController = [[SettingsViewController alloc] init];
    [UIAppDelegate.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
    
    UIAppDelegate.isMenuShow = 0;
    self.hidden = YES;
}

- (IBAction)ungDungKhacButtonClicked:(id)sender
{
    // Ung dung khac button clicked
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index: %d",buttonIndex);
    if (buttonIndex == 1)
    {
        // Ten Ca si
    }
    else if(buttonIndex == 2)
    {
        // Danh Muc
    }
    else if(buttonIndex == 3)
    {
        // Bai Hat
    }
    else
    {
        // Huy
    }
}
@end
