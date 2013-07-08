//
//  PlayerMusicViewController.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/19/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "PlayerMusicViewController.h"

#import "Category.h"
#import "Singer.h"
#import <Pods/Category/NSData+Base64.h>
#import <Pods/Category/UILabel+Custom.h>
#import "PlayerMusicViewCell.h"
#import "MTZTiltReflectionSlider.h"
#import "LoadMoneyViewController.h"

#define kPlay_Local         1
#define kPlay_Online        2

@interface PlayerMusicViewController ()
{
    __unsafe_unretained IBOutlet UITableView *myTableView;
    __unsafe_unretained IBOutlet UIImageView *backgroundImageView;
    __unsafe_unretained IBOutlet UIView *musicPlayerView;
    __unsafe_unretained IBOutlet UIImageView *musicPlayerBgImageView;
    __unsafe_unretained IBOutlet UIButton *playButton;
    __unsafe_unretained IBOutlet UIButton *expandPlayButton;
    __unsafe_unretained IBOutlet UIButton *downloadButton;
    __unsafe_unretained IBOutlet UIButton *download2Button;
    __unsafe_unretained IBOutlet MTZTiltReflectionSlider *currentTimeSlider;
    __unsafe_unretained IBOutlet UILabel *elapsedTimeLabel;
    __unsafe_unretained IBOutlet UILabel *remainingTimeLabel;
    
    __unsafe_unretained IBOutlet UIButton *expandPauseButton;
    __unsafe_unretained IBOutlet UIButton *pauseButton;
    __unsafe_unretained IBOutlet UILabel *singerLabel;
    __unsafe_unretained IBOutlet UILabel *categoryLabel;
    //
    //          Right menu view
    //
    __unsafe_unretained IBOutlet UIView *rightMenuView;
    __unsafe_unretained IBOutlet UIImageView *enIconImageView;
    __unsafe_unretained IBOutlet UIButton *enIconButton;
    __unsafe_unretained IBOutlet UIImageView *listIconImageView;
    __unsafe_unretained IBOutlet UIButton *listIconButton;
    __unsafe_unretained IBOutlet UIImageView *switchIconImageView;
    __unsafe_unretained IBOutlet UIButton *switchIconButton;
    __unsafe_unretained IBOutlet UIProgressView *progressDownloadBar;
    //
    //          Favorite button clicked
    //
    __unsafe_unretained IBOutlet UIButton *favoriteBgButton;
    __unsafe_unretained IBOutlet UIButton *favoriteButton;
    __unsafe_unretained IBOutlet UILabel *mediaSizeLabel;
    __unsafe_unretained IBOutlet UIScrollView *mainScrollView;
    
    UIScrollView *titleBgView;
    
    NSMutableArray *listItems;
    
    int displayType;
    int displayStyle;
    BOOL canPlay;
    NSString *mediaPath;
    long long currentLength;
    int lastIndex;
    int currentTypeDisplay;
    BOOL isDownloading;
    BOOL isDownloadFinish;
    
    ASIHTTPRequest *mediaRequest;
    
    int autoDownloadFile;
    int fontSize;
    int typePlay;
    int isPlaying;
    double mCurrentTime;
    
    NSTimer *timer;
    AVPlayer *livePlayer;

    
    //
    //      view tung cau
    //
    IBOutlet UIView *tungCauView;
    IBOutlet UILabel *enCau01Label;
    IBOutlet UILabel *vnCau01Label;
    IBOutlet UILabel *enCau02Label;
    IBOutlet UILabel *vnCau02Label;
 
    UIColor *defaultColor;
    UIColor *hoverColor;
}

- (void)setupView;

- (void)setupMusicPlay;
- (void)setupMusicPlayLive;
- (void)updateDisplay;
- (void)updateSliderLabels;
- (void)stopTimer;
- (void)stopPlaying;
- (void)setupNavigationBar;
- (NSInteger)getHeightForCell:(NSDictionary *)dict andIndexPathRow:(int)indexPathRow;
- (NSString*)formattedStringForDuration:(NSTimeInterval)duration;
- (void)animateScrollTitleRight;
- (void)animateScrollTitleLeft;
- (NSString *)byteToMegaByte:(double)size;

- (void)generateViewTungCau;

- (IBAction)playButtonClicked:(id)sender;
- (IBAction)downloadButtonClicked:(id)sender;
- (IBAction)currentTimeSliderValueChanged:(id)sender;
- (IBAction)currentTimeSliderTouchUpInside:(id)sender;
- (IBAction)expandPauseButtonClicked:(id)sender;
- (IBAction)favoriteButtonClicked:(id)sender;
- (IBAction)enIconButtonClicked:(id)sender;
- (IBAction)listIconButtonClicked:(id)sender;
- (IBAction)switchIconButtonClicked:(id)sender;

- (void)downloadMediaWithPath:(NSString *)filePath;
- (void)viewTungCauWithIndex:(int)index;

@end

@implementation PlayerMusicViewController

@synthesize playerSong;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    titleBgView = nil;
    myTableView = nil;
    backgroundImageView = nil;
    musicPlayerView = nil;
    musicPlayerBgImageView = nil;
    playButton = nil;
    expandPlayButton = nil;
    downloadButton = nil;
    download2Button = nil;
    currentTimeSlider = nil;
    elapsedTimeLabel = nil;
    remainingTimeLabel = nil;
    expandPauseButton = nil;
    pauseButton = nil;
    singerLabel = nil;
    categoryLabel = nil;
    progressDownloadBar = nil;
    favoriteBgButton = nil;
    favoriteButton = nil;
    rightMenuView = nil;
    enIconImageView = nil;
    enIconButton = nil;
    listIconImageView = nil;
    listIconButton = nil;
    switchIconImageView = nil;
    switchIconButton = nil;
    mediaSizeLabel = nil;
    mainScrollView = nil;
    currentTimeSlider = nil;
    tungCauView = nil;
    enCau01Label = nil;
    vnCau01Label = nil;
    enCau02Label = nil;
    vnCau02Label = nil;
    [super viewDidUnload];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self stopPlaying];
    [super viewWillDisappear:animated];
}

#pragma mark - Setup View

- (void)setupView
{
    currentTypeDisplay = kPlayerMusic_ENVN;
    //
    //  load setting from userdefaults
    //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    displayType = [userDefaults integerForKey:kSetting_Display_Type];
    displayStyle = [userDefaults integerForKey:kSetting_Display_Style];
    autoDownloadFile = [userDefaults integerForKey:kSetting_Auto_Download];
    int textSize = [userDefaults integerForKey:kSetting_Text_Size];
    
    //
    //      font size of text
    //
    if (textSize == kSetting_CoLon)
    {
        fontSize = 20;
    }
    else if(textSize == kSetting_CoVua || textSize == 0)
    {
        fontSize = 15;
    }
    else
    {
        fontSize = 12;
    }
    //
    // style display ban ngay hay ban dem
    //
    if (displayStyle == kSetting_BanNgay)
    {
        backgroundImageView.hidden = YES;
        singerLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        categoryLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        
        vnCau01Label.textColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        vnCau02Label.textColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        enCau01Label.textColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        enCau02Label.textColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        
        enIconImageView.image = [UIImage imageNamed:@"icon_EV.png"];
        listIconImageView.image = [UIImage imageNamed:@"icon_select_unselect.png"];
        switchIconImageView.image = [UIImage imageNamed:@"icon_status.png"];
        
        defaultColor = [UIColor colorWithRed:111.0f/255.0f green:109.0f/255.0f blue:109.0f/255.0f alpha:1.0];
        hoverColor = kColor_Purple;
    }
    else
    {
        backgroundImageView.hidden = NO;
        singerLabel.textColor = [UIColor whiteColor];
        categoryLabel.textColor = [UIColor whiteColor];
        
        vnCau01Label.textColor = [UIColor whiteColor];
        vnCau02Label.textColor = [UIColor whiteColor];
        enCau01Label.textColor = [UIColor whiteColor];
        enCau02Label.textColor = [UIColor whiteColor];
        
        enIconImageView.image = [UIImage imageNamed:@"btn_EV.png"];
        listIconImageView.image = [UIImage imageNamed:@"btn_unselect.png"];
        switchIconImageView.image = [UIImage imageNamed:@"btn_mode.png"];
        
        defaultColor = [UIColor whiteColor];
        hoverColor = kColor_Purple;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    myTableView.tableFooterView = footerView;
    footerView = nil;

    //
    //      set delegate for tableview
    //
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    //
    //      load singer
    //
    DatabaseManager *db = [DatabaseManager sharedDatabaseManager];
    Category *cate = [[Category alloc] init];
    Singer *singer = [[Singer alloc] init];

    cate.tblID = playerSong.category_id;
    cate = [cate getCategoryById:db.database];
    
    singer.tblID = playerSong.singer_id;
    singer = [singer getSingerById:db.database];
    
    singerLabel.text = [NSString stringWithFormat:@"Sáng tác: %@",singer.name];
    categoryLabel.text= [NSString stringWithFormat:@"Thể loại: %@", cate.name];
    
    singerLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    categoryLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
    
    remainingTimeLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    elapsedTimeLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:10];
    
    int num = playerSong.category_id % kKEY1 + playerSong.tblID % kKEY2 + kKEY3;
    NSString *enSongEncodeStr = [playerSong.english substringFromIndex:num];
    NSData *enSongEncodeData = [NSData dataFromBase64String:enSongEncodeStr];
    NSString *enSongDecodeStr = [[NSString alloc] initWithData:enSongEncodeData encoding:NSUTF8StringEncoding];
    
    NSString *vnSongEncodeStr = [playerSong.vietnamese substringFromIndex:num];
    NSData *vnSongEncodeData = [NSData dataFromBase64String:vnSongEncodeStr];
    NSString *vnSongDecodeStr = [[NSString alloc] initWithData:vnSongEncodeData encoding:NSUTF8StringEncoding];
    
    NSArray *arrEn = [enSongDecodeStr componentsSeparatedByString:@"\n"];
    NSArray *arrVn = [vnSongDecodeStr componentsSeparatedByString:@"\n"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF !=''"];
    arrEn = [arrEn filteredArrayUsingPredicate:predicate];
    arrVn = [arrVn filteredArrayUsingPredicate:predicate];
    
    //
    //      khoi tao list cau hat
    //
    listItems = [NSMutableArray array];
    for (int i = 0; i < [arrEn count]; i++)
    {
        NSString *vnStr = (i >= [arrVn count])? @"":[arrVn objectAtIndex:i];
        NSString *enStr = [arrEn objectAtIndex:i];
        
        NSArray *arr = [enStr componentsSeparatedByString:@"]"];
        NSString *seekTime = @"";
        NSString *enSplitStr = @"";
        
        if ([arr count] > 1)
        {
            seekTime = [[arr objectAtIndex:0] substringFromIndex:1];
            enSplitStr = [arr objectAtIndex:1];
        }
        else if([arr count] > 0)
        {
            enSplitStr = [arr objectAtIndex:0];
        }
        NSNumber *number;
        NSArray *arrSeekTime = [seekTime componentsSeparatedByString:@":"];
        if  ([arrSeekTime count] > 1)
        {
            float timePlay = [[arrSeekTime objectAtIndex:0] floatValue]*60 + [[arrSeekTime objectAtIndex:1] floatValue];
            seekTime = [NSString stringWithFormat:@"%f",timePlay];
            
            number = [NSNumber numberWithFloat:timePlay];
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              enSplitStr, @"en",
                              vnStr, @"vn",
                              number, @"seekTime",
                              [NSString stringWithFormat:@"%d",i],@"id",
                               nil];
        [listItems addObject:dict];
    }
    [myTableView reloadData];
    //
    //      set text for view tung cau
    //
    if ([listItems count] > 1)
    {
        NSDictionary *dict = [listItems objectAtIndex:0];
        enCau01Label.text = [dict objectForKey:@"en"];
        vnCau01Label.text = [dict objectForKey:@"vn"];
        
        dict = [listItems objectAtIndex:1];
        enCau02Label.text = [dict objectForKey:@"en"];
        vnCau02Label.text = [dict objectForKey:@"vn"];
    }
    
    [self setupNavigationBar];
    
    //
    //      check media file exist
    //
    pauseButton.hidden = YES;
    expandPauseButton.hidden = YES;
    
    //[currentTimeSlider setThumbImage:[UIImage imageNamed:@"icon_seek.png"] forState:UIControlStateNormal];

    // ***********************************
    //      Check media file exist
    //
    mediaPath = [NSString stringWithFormat:@"%@%@/%d.mp3",LIBRARY_CATCHES_DIRECTORY,@"Media",playerSong.tblID];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // ***********************************************************
    //          check play local or live
    //
    if ([fileManager fileExistsAtPath:mediaPath])
    {
        typePlay = kPlay_Local;
        [download2Button setImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateNormal];
        download2Button.userInteractionEnabled = NO;
        downloadButton.userInteractionEnabled = NO;
        canPlay = YES;
        isDownloading = NO;
        //----------    player --------------------
        [self setupMusicPlay];
    }
    else
    {
        [download2Button setImage:[UIImage imageNamed:@"icon_download.png"] forState:UIControlStateNormal];
        typePlay = kPlay_Online;
        canPlay = NO;
        isDownloading = NO;
        //
        //      auto download file mp3
        //
        if (autoDownloadFile == 0)
        {
            // Download file
            [self downloadMediaWithPath:mediaPath];
        }

        [self setupMusicPlayLive];
    }
    
    isDownloadFinish = NO;
    isPlaying = 0;
    progressDownloadBar.progress = 0.0;
    currentTimeSlider.value = 0.0;
    [currentTimeSlider setSize:MTZTiltReflectionSliderSizeSmall];
    mainScrollView.contentSize = CGSizeMake(320*2, mainScrollView.frame.size.height);
    
    tungCauView.frame = CGRectMake(320, 0, 320, 300);
    
    enCau01Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:fontSize];
    vnCau01Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:fontSize];
    enCau02Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:fontSize];
    vnCau02Label.font = [UIFont fontWithName:kFont_Klavika_Regular size:fontSize];
    
    [mainScrollView addSubview:tungCauView];
    [self generateViewTungCau];
    //
    //      check favorite button
    //

    if ([[UserDataManager sharedManager] filterFavoriteSongWithKey:playerSong.tblID] == YES)
    {
        favoriteButton.selected = YES;
    }
    else
    {
        favoriteButton.selected = NO;
    }
    
    if (displayType == kSetting_Display_List)
    {
        switchIconButton.selected = YES;
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else
    {
        switchIconButton.selected = NO;
        [mainScrollView setContentOffset:CGPointMake(320, 0) animated:NO];
    }
    
}

- (void)setupNavigationBar
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
    titleLabel.text = playerSong.name;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:20];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textColor =[UIColor whiteColor];
    [UILabel setWidthForLabel:titleLabel widthLimit:0 isCenter:NO];
    
    CGRect frame = titleLabel.frame;
    frame.origin.y = 22 - frame.size.height/2;
    titleLabel.frame = frame;
    if (frame.size.width > 160)
    {
        titleLabel.textAlignment = UITextAlignmentLeft;
    }
    else
    {
        titleLabel.textAlignment = UITextAlignmentCenter;
    }
    
    titleBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleBgView.backgroundColor = [UIColor clearColor];
    [titleBgView addSubview:titleLabel];
    
    titleBgView.showsHorizontalScrollIndicator = NO;
    titleBgView.showsVerticalScrollIndicator = NO;
    titleBgView.scrollEnabled = NO;
    
    titleBgView.contentSize = CGSizeMake(titleLabel.frame.size.width, 44);
    
    self.navigationItem.titleView = titleBgView;
    
    // add right button
    
    UIImage *rightMenuImage = [UIImage imageNamed:@"icon_menu.png"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(70 - rightMenuImage.size.width, 0, rightMenuImage.size.width + 20, 44)];
    [rightButton setImage:rightMenuImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    //          Add menu right button
    //
    UIView  *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [rightBgView setBackgroundColor:[UIColor clearColor]];
    
    //
    //          Add Coin Icon
    //
    UIImageView *coinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_coin.png"]];
    coinImageView.frame = CGRectMake(0, 15, 15, 15);
    [rightBgView addSubview:coinImageView];
    //
    //          Add coin button
    //
    NSString *userCoin = [NSString stringWithFormat:@"%d",[[UserDataManager sharedManager] getCoinUser]];
    UIButton *coinButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,70,44)];
    [coinButton setTitle:userCoin forState:UIControlStateNormal];
    [coinButton addTarget:self action:@selector(showLoadMoney:) forControlEvents:UIControlEventTouchUpInside];
    [rightBgView addSubview:coinButton];

    //
    //      Add line image
    //
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_nav_line.png"]];
    lineImageView.frame = CGRectMake(85 - rightMenuImage.size.width/2 - 8, 13, 2, 18);
    
    [rightBgView addSubview:lineImageView];

    [rightBgView addSubview:rightButton];
    
    UIBarButtonItem *rightButtonBar = [[UIBarButtonItem alloc] initWithCustomView:rightBgView];
    self.navigationItem.rightBarButtonItem = rightButtonBar;
    
    rightMenuImage = nil;
    rightButton = nil;
    rightButtonBar = nil;
    
    //
    //      update scroll view
    //
    [self animateScrollTitleRight];
}

- (void)setupMusicPlay
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:mediaPath])
    {
        DLog(@" media path ko ton tai");
        return;
    }
 
    if (livePlayer != nil)
    {
        [livePlayer pause];
        livePlayer = nil;
    }
    //
    //      create player item
    //

    AVPlayerItem *playItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:mediaPath]];
    
    livePlayer = [[AVPlayer alloc]initWithPlayerItem:playItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[livePlayer currentItem]];
    [livePlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    
    typePlay = kPlay_Local;

    [self updateDisplay];
}

- (void)setupMusicPlayLive
{
    NSString *urlString = [NSString stringWithFormat:@"%@%d.mp3",kServerMedia,playerSong.tblID];
    
    livePlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:urlString]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[livePlayer currentItem]];
    [livePlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (NSTimeInterval) availableDuration;
{
    NSArray *loadedTimeRanges = [[livePlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == livePlayer && [keyPath isEqualToString:@"status"])
    {
        if (livePlayer.status == AVPlayerStatusFailed)
        {
            NSLog(@"AVPlayer Failed");
            
        } else if (livePlayer.status == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            
        } else if (livePlayer.status == AVPlayerItemStatusUnknown)
        {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    
    //  code here to play next sound file
    
}


- (void)stopPlaying
{
    [livePlayer pause];
    livePlayer = nil;
    [self stopTimer];
    [self updateDisplay];
}

- (void)downloadMediaWithPath:(NSString *)filePath
{
    isDownloading = YES;
    canPlay = YES;
    isDownloadFinish = NO;
    
    NSString *url = [NSString stringWithFormat:@"%@%d.mp3",kServerMedia,playerSong.tblID];
	mediaRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	[mediaRequest setDownloadDestinationPath:filePath];
	[mediaRequest setDownloadProgressDelegate:self];
    [mediaRequest setShowAccurateProgress:YES];
    mediaRequest.delegate = self;
    [mediaRequest startAsynchronous];
}

- (NSString *)byteToMegaByte:(double)value
{
    double convertedValue = value;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

#pragma mark - Button Clicked

- (void)showLoadMoney:(id)sender
{
    LoadMoneyViewController *viewController = [[LoadMoneyViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController = nil;
}

- (void)backButtonPressed:(id)sender
{
    if (UIAppDelegate.isMenuShow == 1)
    {
        UIAppDelegate.isMenuShow = 0;
        UIAppDelegate.navDropDownMenu.hidden = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMenuButtonClicked:(id)sender
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

- (IBAction)playButtonClicked:(id)sender
{
    if (canPlay == NO)
    {
        [UIAppDelegate showAlertView:nil andMessage:@"Vui lòng tải file trước để thực hiện thao tác này."];
        return;
    }
    if (typePlay == kPlay_Local)
    {
        [livePlayer play];
        
        if ([timer isValid])
        {
            [timer invalidate];
            timer = nil;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode: NSRunLoopCommonModes];
    }
    else
    {
        [livePlayer play];
        
        if ([timer isValid])
        {
            [timer invalidate];
            timer = nil;
        }

        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode: NSRunLoopCommonModes];
    }
    
    playButton.hidden = YES;
    expandPlayButton.hidden = YES;
    
    pauseButton.hidden = NO;
    expandPauseButton.hidden = NO;
    isPlaying = 1;
}

- (IBAction)downloadButtonClicked:(id)sender
{
    if (isDownloading == YES)
    {
        [UIAppDelegate showAlertView:nil andMessage:@"Bạn đang tải, vui lòng chờ."];
        return;
    }
    [self downloadMediaWithPath:mediaPath];
}

- (IBAction)currentTimeSliderValueChanged:(id)sender
{
    if(timer)
        [self stopTimer];
    [self updateSliderLabels];
}

- (IBAction)currentTimeSliderTouchUpInside:(id)sender
{
    if (isDownloading == YES)
    {
        if ([timer isValid])
        {
            [timer invalidate];
            timer = nil;
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode: NSRunLoopCommonModes];
        
        return;
    }
    
    if (typePlay == kPlay_Online)
    {
        if (isDownloading == NO)
        {
            
        }
        
        if (isDownloadFinish == YES)
        {
            //NSLog(@"Time current: %f",CMTimeGetSeconds(livePlayer.currentItem.currentTime));
            
            //mCurrentTime = CMTimeGetSeconds(livePlayer.currentItem.currentTime);
            
            mCurrentTime = currentTimeSlider.value;
            
            if (livePlayer != nil)
            {
                [livePlayer pause];
                livePlayer = nil;
            }
            
            AVPlayerItem *playItem = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:mediaPath]];
            
            livePlayer = [[AVPlayer alloc]initWithPlayerItem:playItem];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[livePlayer currentItem]];
            [livePlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
            
            [livePlayer seekToTime:CMTimeMake((mCurrentTime * CMTimeGetSeconds(livePlayer.currentItem.duration))/100, 1.0)];
            
            [livePlayer play];
            
            NSLog(@"aa: %f",(mCurrentTime * CMTimeGetSeconds(livePlayer.currentItem.duration))/100);
            //currentTimeSlider.value = (mCurrentTime * CMTimeGetSeconds(livePlayer.currentItem.duration))/100;
            
            NSLog(@" min: %f - max: %f",currentTimeSlider.minimumValue, currentTimeSlider.maximumValue);
            NSLog(@" current: %f",currentTimeSlider.value);
            
            typePlay = kPlay_Local;
            
            if ([timer isValid])
            {
                [timer invalidate];
                timer = nil;
            }
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
            
            [[NSRunLoop mainRunLoop] addTimer:timer forMode: NSRunLoopCommonModes];
        }
    }
    else
    {
        [livePlayer pause];
        
        [livePlayer seekToTime:CMTimeMake((currentTimeSlider.value * CMTimeGetSeconds(livePlayer.currentItem.duration))/100, 1)];
        
        //[livePlayer play];
        lastIndex = 0;
        [self playButtonClicked:self];
    }
}

- (IBAction)expandPauseButtonClicked:(id)sender
{
    [livePlayer pause];
    
    [livePlayer pause];
    
    [self stopTimer];
    [self updateDisplay];
    
    playButton.hidden = NO;
    expandPlayButton.hidden = NO;
    
    pauseButton.hidden = YES;
    expandPauseButton.hidden = YES;
    isPlaying = 0;
}

- (IBAction)favoriteButtonClicked:(id)sender
{
    favoriteButton.selected = !favoriteButton.selected;
    if (favoriteButton.selected == YES)
    {
        // add new item
        [[UserDataManager sharedManager] insertFavoriteSong:playerSong.tblID];
    }
    else
    {
        // remove item
        [[UserDataManager sharedManager] deleteFavoriteSong:playerSong.tblID];
    }
}

- (IBAction)enIconButtonClicked:(id)sender
{
    if (currentTypeDisplay == kPlayerMusic_ENVN)
    {
        currentTypeDisplay = kPlayerMusic_EN;
        if (displayStyle == kSetting_BanNgay)
        {
            enIconImageView.image = [UIImage imageNamed:@"icon_EN.png"];
        }
        else
        {
            enIconImageView.image = [UIImage imageNamed:@"btn_EN.png"];
        }

    }
    else if(currentTypeDisplay == kPlayerMusic_EN)
    {
        currentTypeDisplay = kPlayerMusic_VN;
        if (displayStyle == kSetting_BanNgay)
        {
            enIconImageView.image = [UIImage imageNamed:@"icon_VN.png"];
        }
        else
        {
            enIconImageView.image = [UIImage imageNamed:@"btn_VN.png"];
        }
    }
    else
    {
        currentTypeDisplay = kPlayerMusic_ENVN;
        if (displayStyle == kSetting_BanNgay)
        {
            enIconImageView.image = [UIImage imageNamed:@"icon_EV.png"];
        }
        else
        {
            enIconImageView.image = [UIImage imageNamed:@"btn_EV.png"];
        }
        
    }
    
    [myTableView reloadData];
}

- (IBAction)listIconButtonClicked:(id)sender
{
    
}

- (IBAction)switchIconButtonClicked:(id)sender
{
    if (switchIconButton.selected == YES)
    {
        [mainScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    }
    else
    {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    switchIconButton.selected = !switchIconButton.selected;
}

#pragma mark - Display Update


- (void)animateScrollTitleRight
{
    int distance = titleBgView.contentSize.width - titleBgView.frame.size.width + 2;
    if (distance <= 0)
    {
        return;
    }
    double time = distance/30;
    [UIView animateWithDuration:time animations:^{
        titleBgView.contentOffset = CGPointMake(distance, 0);
    }completion:^(BOOL finished)
     {
         [self performSelector:@selector(animateScrollTitleLeft) withObject:nil afterDelay:1.0];
     }];
}

- (void)animateScrollTitleLeft
{
    int distance = titleBgView.contentSize.width - titleBgView.frame.size.width;
    if (distance <= 0)
    {
        return;
    }
    double time = distance/30;
    [UIView animateWithDuration:time animations:^{
        titleBgView.contentOffset = CGPointMake(0, 0);
    }completion:^(BOOL finished)
     {
         [self performSelector:@selector(animateScrollTitleRight) withObject:nil afterDelay:1.0];
     }];
}

- (void)updateDisplay
{
    NSTimeInterval currentTime = 0.0;

    currentTime = CMTimeGetSeconds(livePlayer.currentItem.currentTime);
    
    currentTimeSlider.value = (currentTime * 100)/CMTimeGetSeconds(livePlayer.currentItem.duration);

    
    
    [self updateSliderLabels];
    
    NSNumber *timePlay = [NSNumber numberWithFloat:currentTime];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seekTime <= %@",timePlay];
    
    NSArray *arrFilter = [listItems filteredArrayUsingPredicate:predicate];
    //NSLog(@"Filter found >>>>> %@",arrFilter);
    for (int i = 0; i < [arrFilter count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PlayerMusicViewCell *cell = (PlayerMusicViewCell *)[myTableView cellForRowAtIndexPath:indexPath];
        [cell setDetailTextColor:kColor_Purple];
    }
    
    for (int i=[arrFilter count]; i < [listItems count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PlayerMusicViewCell *cell = (PlayerMusicViewCell *)[myTableView cellForRowAtIndexPath:indexPath];
        if (displayStyle == kSetting_BanNgay)
        {
            [cell setDetailTextColor:kColor_CustomGray];
        }
        else
        {
            [cell setDetailTextColor:[UIColor whiteColor]];
        }
    
    }
    
    if ([arrFilter count] > lastIndex)
    {
        lastIndex = [arrFilter count];
        int index = [arrFilter count];
        
        if (index > 0)
        {
            index = [arrFilter count]-1;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        CGRect cellRect = [myTableView rectForRowAtIndexPath:indexPath];
        cellRect = [myTableView convertRect:cellRect toView:myTableView.superview];
        BOOL completelyVisible = CGRectContainsRect(myTableView.frame, cellRect);
        if  (!completelyVisible)
        {
            [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
    else
    {
    
    }
    
    [self viewTungCauWithIndex:lastIndex];
}

- (void)updateSliderLabels
{
    NSTimeInterval currentTime = 0.0;
    
    currentTime = (currentTimeSlider.value * CMTimeGetSeconds(livePlayer.currentItem.duration))/100;
    
    NSString* currentTimeString = [self formattedStringForDuration:currentTime];

    elapsedTimeLabel.text =  currentTimeString;

    remainingTimeLabel.text = [self formattedStringForDuration:CMTimeGetSeconds(livePlayer.currentItem.duration) - currentTime];
}

- (NSString*)formattedStringForDuration:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

- (void)viewTungCauWithIndex:(int)index
{
    if (index <= 0)
    {
        return;
    }
    NSDictionary *dict = [listItems objectAtIndex:index - 1];
    NSDictionary *dict2;
    
    enCau01Label.textColor = defaultColor;
    enCau02Label.textColor = defaultColor;
    vnCau01Label.textColor = defaultColor;
    vnCau02Label.textColor = defaultColor;
    
    NSLog(@" Last index: %d",lastIndex);
    
    if (index < [listItems count] - 1)
    {
        if (index  > [listItems count] - 1)
        {
            return;
        }
         dict2 = [listItems objectAtIndex:index];
    }
    
    if (currentTypeDisplay == kPlayerMusic_ENVN)
    {
        enCau01Label.hidden = NO;
        enCau02Label.hidden = NO;
        vnCau01Label.hidden = NO;
        vnCau02Label.hidden = NO;
    }
    else if(currentTypeDisplay == kPlayerMusic_EN)
    {
        vnCau01Label.hidden = YES;
        vnCau02Label.hidden = YES;
        enCau01Label.hidden = NO;
        enCau02Label.hidden = NO;
    }
    else
    {
        enCau01Label.hidden = YES;
        enCau02Label.hidden = YES;
        vnCau01Label.hidden = NO;
        vnCau02Label.hidden = NO;
    }
    
    if (lastIndex%2 ==0)
    {
        if ([[UserDataManager sharedManager] filterPurcharseSongWithKey:playerSong.tblID] == YES)
        {
            enCau01Label.text = [dict objectForKey:@"en"];
            vnCau01Label.text = [dict objectForKey:@"vn"];
        }
        else
        {
            enCau01Label.text = kMessage_Mua_Bai_Hat_EN;
            vnCau01Label.text = kMessage_Mua_Bai_Hat_VN;
        }

        enCau01Label.textColor = hoverColor;
        vnCau01Label.textColor = hoverColor;

        enCau02Label.text = [dict2 objectForKey:@"en"];
        vnCau02Label.text = [dict2 objectForKey:@"vn"];
    }
    else
    {
        
        if ([[UserDataManager sharedManager] filterPurcharseSongWithKey:playerSong.tblID] == YES)
        {
            enCau02Label.text = [dict objectForKey:@"en"];
            vnCau02Label.text = [dict objectForKey:@"vn"];
        }
        else
        {
            enCau02Label.text = kMessage_Mua_Bai_Hat_EN;
            vnCau02Label.text = kMessage_Mua_Bai_Hat_VN;
        }

        enCau02Label.textColor = hoverColor;
        vnCau02Label.textColor = hoverColor;
        
        enCau01Label.text = [dict2 objectForKey:@"en"];
        vnCau01Label.text = [dict2 objectForKey:@"vn"];
    }
    
    [self generateViewTungCau];
}

- (void)generateViewTungCau
{
    [UILabel setHeightForLabel:enCau01Label];
    [UILabel setHeightForLabel:vnCau01Label];
    CGRect rect = vnCau01Label.frame;
    rect.origin.y = enCau01Label.frame.origin.y + enCau01Label.frame.size.height;
    vnCau01Label.frame = rect;
    
    [UILabel setHeightForLabel:enCau02Label];
    [UILabel setHeightForLabel:vnCau02Label];
    rect = vnCau02Label.frame;
    rect.origin.y = enCau02Label.frame.origin.y + enCau02Label.frame.size.height;
    vnCau02Label.frame = rect;
}

#pragma mark - Timer

- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
    [self updateDisplay];
}


- (NSInteger )getHeightForCell:(NSDictionary *)dict andIndexPathRow:(int)indexPathRow
{
    UILabel *enTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 305, 21)];
    UILabel *vnTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 305, 21)];
    enTextLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:fontSize];
    vnTextLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:fontSize];
    
    if ([[UserDataManager sharedManager] filterPurcharseSongWithKey:playerSong.tblID] == YES)
    {
        enTextLabel.text = [dict objectForKey:@"en"];
        vnTextLabel.text = [dict objectForKey:@"vn"];
    }
    else
    {
        if (indexPathRow > 15)
        {
            enTextLabel.text = kMessage_Mua_Bai_Hat_EN;
            vnTextLabel.text = kMessage_Mua_Bai_Hat_VN;
        }
        else
        {
            enTextLabel.text = [dict objectForKey:@"en"];
            vnTextLabel.text = [dict objectForKey:@"vn"];
        }
    }
    
    enTextLabel.numberOfLines = 0;
    [enTextLabel sizeToFit];
    
    CGRect frame = vnTextLabel.frame;
    frame.origin.y = enTextLabel.frame.origin.y + enTextLabel.frame.size.height + 5;
    vnTextLabel.frame = frame;
    
    vnTextLabel.numberOfLines = 0;
    [vnTextLabel sizeToFit];
    
    int Height = 0;
    if (currentTypeDisplay == kPlayerMusic_ENVN)
    {
        Height = vnTextLabel.frame.origin.y + vnTextLabel.frame.size.height + 10;
    }
    else if(currentTypeDisplay == kPlayerMusic_EN)
    {
        Height = enTextLabel.frame.origin.y + enTextLabel.frame.size.height + 10;
    }
    else
    {
        Height = 0 + vnTextLabel.frame.size.height + 10;
    }
    
    enTextLabel = nil;
    vnTextLabel = nil;
    
    return Height;
    
}
#pragma mark - UITableViewCell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [listItems objectAtIndex:indexPath.row];
    return [self getHeightForCell:dict andIndexPathRow:indexPath.row];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listItems count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    PlayerMusicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlayerMusicViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = [listItems objectAtIndex:indexPath.row];
    
    cell.indexPathRow = indexPath.row;
    cell.songId = playerSong.tblID;
    cell.fontSize = fontSize;
    
    [cell setupView:dict andDisplayType:currentTypeDisplay];
    if (displayStyle == kSetting_BanNgay)
    {
        [cell setDetailTextColor:kColor_CustomGray];
    }
    else
    {
        [cell setDetailTextColor:[UIColor whiteColor]];
    }

    if (indexPath.row < lastIndex)
    {
        [cell setDetailTextColor:kColor_Purple];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //  Hien tai nhac chua dc play
    //
    if (isPlaying == 0)
    {
        return;
    }
    
    [livePlayer pause];
    
    playButton.hidden = YES;
    expandPlayButton.hidden = YES;
    
    pauseButton.hidden = NO;
    expandPauseButton.hidden = NO;

    
    NSDictionary *dict = [listItems objectAtIndex:indexPath.row];
    
    [livePlayer seekToTime:CMTimeMake([[dict objectForKey:@"seekTime"] doubleValue],1)];

    [livePlayer play];
    
    int extraIndex = lastIndex;
    
    lastIndex = [[dict objectForKey:@"id"] intValue];
  
    for (int i = 0; i < lastIndex; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PlayerMusicViewCell *cell = (PlayerMusicViewCell *)[myTableView cellForRowAtIndexPath:indexPath];
        [cell setDetailTextColor:kColor_Purple];
    }
    
    for (int i = lastIndex; i < extraIndex; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PlayerMusicViewCell *cell = (PlayerMusicViewCell *)[myTableView cellForRowAtIndexPath:indexPath];
        if (displayStyle == kSetting_BanNgay)
        {
            [cell setDetailTextColor:kColor_CustomGray];
        }
        else
        {
            [cell setDetailTextColor:[UIColor whiteColor]];
        }
    }
    
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode: NSRunLoopCommonModes];
}


#pragma mark - ASIHttprequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    mediaSizeLabel.text = [NSString stringWithFormat:@"%@/%@",[self byteToMegaByte:request.contentLength],[self byteToMegaByte:request.contentLength]];
    
    isDownloading = NO;
    isDownloadFinish = YES;
    
    [download2Button setImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateNormal];
    download2Button.userInteractionEnabled = NO;
    downloadButton.userInteractionEnabled = NO;
    
    canPlay = YES;
    //----------    player --------------------
    typePlay = kPlay_Online;
    //
    //      khoi tao de play local
    //
    
    if (isPlaying == 1)
    {
        //
        //      play live online
        //
    }
    else
    {
        [self setupMusicPlay];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    canPlay = NO;
    isDownloading = NO;
    
    if (isPlaying == 1)
    {
        [livePlayer pause];
    }
    
    [UIAppDelegate showAlertView:nil andMessage:@"Lỗi trong quá trình tải. Vui lòng thử lại!"];
    NSLog(@"%@",request.error.description);
}

// Download file delegate

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{

}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    currentLength += bytes;
    mediaSizeLabel.text = [NSString stringWithFormat:@"%@/%@",[self byteToMegaByte:currentLength],[self byteToMegaByte:request.contentLength]];
}

- (void)setProgress:(float)newProgress
{
    progressDownloadBar.progress = newProgress;
}

@end
