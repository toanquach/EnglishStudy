//
//  AppDelegate.h
//  EnglishStudy
//
//  Created by Toan Quach on 6/6/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationBarDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic) BOOL  isNetworkAvailable;

- (void)showAlertView:(NSString *)title andMessage:(NSString *)message;

- (void)showConnectionView;

- (void)hiddenConnectionView;

- (void)showFooterView;

- (void)hiddenFooterView;

@end
