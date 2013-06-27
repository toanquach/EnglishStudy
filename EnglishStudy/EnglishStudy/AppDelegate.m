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
    Facebook *facebook;
}

@property (nonatomic, strong) Facebook *facebook;
- (void)setupView;

- (void)reachabilityChanged:(NSNotification*)note;

- (void)feedDialogButtonClicked;

@end

@implementation AppDelegate

static NSString* kAppId = @"145698732230891";

@synthesize navigationController;
@synthesize navDropDownMenu;
@synthesize isMenuShow;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    NSString *mediaFolder = [NSString stringWithFormat:@"%@/Media",LIBRARY_CATCHES_DIRECTORY];
    [fileManager fileExistsAtPath:mediaFolder isDirectory:&isDir];
    if (!isDir)
    {
        [fileManager createDirectoryAtPath:mediaFolder withIntermediateDirectories:NO attributes:nil error:nil];
    }
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
    
    // Initialize Facebook
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
        }
    }
    
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
    [[self facebook] extendAccessTokenIfNeeded];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.facebook handleOpenURL:url];
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
    
    self.navDropDownMenu = [[[NSBundle mainBundle] loadNibNamed:@"NavDropDownMenuView" owner:self options:nil] objectAtIndex:0];
    [self.navDropDownMenu setupView];
    if (IS_IPHONE_5)
    {
        self.navDropDownMenu.frame = CGRectMake(0, 0, 320, 480 + 88);
    }
    else
    {
        self.navDropDownMenu.frame = CGRectMake(0, 0, 320, 480);
    }
    [self.navigationController.view addSubview:self.navDropDownMenu];

    self.navDropDownMenu.hidden = YES;
    self.isMenuShow = 0;
    
    [[UserDataManager sharedManager] takeOff];
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

#pragma mark - FBDelegate

- (void)checkFBSession
{
    if (![facebook isSessionValid])
    {
        [facebook fbDialogLogin:@"" expirationDate:nil];
    }
    else
    {
        [self feedDialogButtonClicked];
    }
}

// Method that gets called when the feed dialog button is pressed
- (void)feedDialogButtonClicked
{
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
           @"Testing Feed Dialog", @"name",
            @"Feed Dialogs are Awesome.", @"caption",
            @"Check out how to use Facebook Dialogs.", @"description",
            @"http://www.example.com/", @"link",
            @"http://fbrell.com/f8.jpg", @"picture",
            nil];
    [facebook dialog:@"feed"
        andParams:params
        andDelegate:self];
}


- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    
}


- (void)fbSessionInvalidated
{
}
- (void)fbDidLogin
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    // show form post to fb
    [self feedDialogButtonClicked];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    //NSlog
}

- (void)fbDidLogout
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"])
    {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}


// FBDialogDelegate
- (void)dialogDidComplete:(FBDialog *)dialog
{
    NSLog(@"dialog completed successfully");
}

@end
