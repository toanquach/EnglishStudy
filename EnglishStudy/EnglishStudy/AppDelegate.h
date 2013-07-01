//
//  AppDelegate.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/6/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavDropDownMenuView.h"
#import "FBConnect.h"
#import "Facebook.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationBarDelegate, FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic) BOOL isNetworkAvailable;

@property (nonatomic) int isMenuShow;

@property (nonatomic, strong) NavDropDownMenuView *navDropDownMenu;

- (void)showAlertView:(NSString *)title andMessage:(NSString *)message;

- (void)showConnectionView;

- (void)hiddenConnectionView;

- (void)showFooterView;

- (void)hiddenFooterView;

- (void)checkFBSession;

@end
