//
//  AppDelegate.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/6/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Reachability.h"

#import "ESFooterView.h"
#import "MBProgressHUD.h"

@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"nav_background.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end

@interface AppDelegate()
{
    ESFooterView *footerView;
    MBProgressHUD *hud;
}

- (void)setupView;

- (void)reachabilityChanged:(NSNotification*)note;

@end

@implementation AppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ------------------------------------------
    //      Check network available
    //
    self.isNetworkAvailable = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           self.isNetworkAvailable = YES;
                       });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           self.isNetworkAvailable = YES;
                       });
    };
    
    [reach startNotifier];
    
    // Override point for customization after application launch.
    // ----------------------------------
    //      Create root view controller
    //
    HomeViewController *viewController = [[HomeViewController alloc] init];
    
    // ----------------------------------
    //      Init Navigation controller
    //
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    // -----------------------------------
    //      Config Navigation
    //
    //self.navigationController.navigationBarHidden = YES;
    //self.navigationController.navigationBar.hidden = YES;
    
    self.window.rootViewController = self.navigationController;
    
    if ([[UINavigationBar class]respondsToSelector:@selector(appearance)])
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_background.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setupView];
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Tải dữ liệu...";
    [hud hide:YES];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - reachabilityChanged

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        self.isNetworkAvailable = YES;
    }
    else
    {
        self.isNetworkAvailable = NO;
    }
}

#pragma mark - SetupView

- (void)setupView
{
    footerView = [[[NSBundle mainBundle] loadNibNamed:@"ESFooterView" owner:self options:nil] objectAtIndex:0];
    [self.navigationController.view addSubview:footerView];
    footerView.frame = CGRectMake(0, kMainScreenHeight - 30, 320, 30);
    [footerView setupView];
}

- (void)showAlertView:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Đồng Ý" otherButtonTitles: nil];
    [alertView show];
    alertView = nil;
}

- (void)showConnectionView
{
    [hud show:YES];
}

- (void)hiddenConnectionView
{
    [hud hide:YES];
}

- (void)showFooterView
{
    footerView.hidden = NO;
}

- (void)hiddenFooterView
{
    footerView.hidden = YES;
}

@end
