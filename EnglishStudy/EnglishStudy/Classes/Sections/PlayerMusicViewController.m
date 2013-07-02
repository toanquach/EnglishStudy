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
#import "AudioStreamer.h"

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
    
    ASIHTTPRequest *mediaRequest;
    
    AudioStreamer *streamer;
    
    int autoDownloadFile;
    int fontSize;
    int typePlay;
}
 
@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) NSTimer *timer;
- (void)setupView;

- (void)setupMusicPlay;
- (void)setupMusicPlayLive;
- (void)updateDisplay;
- (void)updateSliderLabels;
- (void)stopTimer;
- (void)stopPlaying;
- (void)setupNavigationBar;
- (NSInteger)getHeightForCell:(NSDictionary *)dict;
- (NSString*)formattedStringForDuration:(NSTimeInterval)duration;
- (void)animateScrollTitleRight;
- (void)animateScrollTitleLeft;
- (NSString *)byteToMegaByte:(double)size;

- (IBAction)playButtonClicked:(id)sender;
- (IBAction)downloadButtonClicked:(id)sender;
- (IBAction)currentTimeSliderValueChanged:(id)sender;
- (IBAction)currentTimeSliderTouchUpInside:(id)sender;
- (IBAction)expandPauseButtonClicked:(id)sender;
- (IBAction)favoriteButtonClicked:(id)sender;
- (IBAction)enIconButtonClicked:(id)sender;
- (IBAction)listIconButtonClicked:(id)sender;
- (IBAction)switchIconButtonClicked:(id)sender;


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag;
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error;

- (void)downloadMediaWithPath:(NSString *)filePath;

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
    [super viewDidUnload];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self stopPlaying];
    [self destroyStreamer];
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
    else if(textSize == kSetting_CoVua)
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
        
        enIconImageView.image = [UIImage imageNamed:@"icon_EN.png"];
        listIconImageView.image = [UIImage imageNamed:@"icon_select_unselect.png"];
        switchIconImageView.image = [UIImage imageNamed:@"icon_status.png"];
    }
    else
    {
        backgroundImageView.hidden = NO;
        singerLabel.textColor = [UIColor whiteColor];
        categoryLabel.textColor = [UIColor whiteColor];
        
        enIconImageView.image = [UIImage imageNamed:@"btn_EN.png"];
        listIconImageView.image = [UIImage imageNamed:@"btn_unselect.png"];
        switchIconImageView.image = [UIImage imageNamed:@"btn_mode.png"];
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
    
    [self setupNavigationBar];
    
    //
    //      check media file exist
    //
    pauseButton.hidden = YES;
    expandPauseButton.hidden = YES;
    
    [currentTimeSlider setThumbImage:[UIImage imageNamed:@"icon_seek.png"] forState:UIControlStateNormal];

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
        typePlay = 1;
        [download2Button setImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateNormal];
        download2Button.userInteractionEnabled = NO;
        downloadButton.userInteractionEnabled = NO;
        canPlay = YES;
        //----------    player --------------------
        [self setupMusicPlay];
    }
    else
    {
        typePlay = 2;
        [download2Button setImage:[UIImage imageNamed:@"icon_download.png"] forState:UIControlStateNormal];
        canPlay = NO;
        isDownloading = NO;
        if (autoDownloadFile == 0)
        {
            // Download file
            [self downloadMediaWithPath:mediaPath];
        }
        
        [self createStreamer];
    }
    progressDownloadBar.progress = 0.0;
    currentTimeSlider.value = 0.0;
    [currentTimeSlider setSize:MTZTiltReflectionSliderSizeSmall];
    mainScrollView.contentSize = CGSizeMake(320*2, mainScrollView.frame.size.height);
}


#pragma mark - AudioStream download

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[self.timer invalidate];
		self.timer = nil;
		
		[streamer stop];
		//[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
    NSString *urlStr = [NSString stringWithFormat:@"%@%d.mp3",kServerMedia,playerSong.tblID];
    
	NSString *escapedValue =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)urlStr,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8));
    
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	self.timer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode: NSRunLoopCommonModes];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:streamer];
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
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(90 - rightMenuImage.size.width/2, 22 -  rightMenuImage.size.height/4, rightMenuImage.size.width/2, rightMenuImage.size.height/2)];
    [rightButton setBackgroundImage:rightMenuImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    //          Add menu right button
    //
    UIView  *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [rightBgView setBackgroundColor:[UIColor clearColor]];
    [rightBgView addSubview:rightButton];
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
    UIButton *coinButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 0,60,44)];
    [coinButton setTitle:userCoin forState:UIControlStateNormal];
    [coinButton addTarget:self action:@selector(showMenuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBgView addSubview:coinButton];
    //
    //      Add line image
    //
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_nav_line.png"]];
    lineImageView.frame = CGRectMake(90 - rightMenuImage.size.width/2 - 8, 13, 2, 18);
    
    [rightBgView addSubview:lineImageView];
    
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
    // Do any additional setup after loading the view, typically from a nib.
    NSURL* url = [[NSURL alloc]initFileURLWithPath:mediaPath];
    NSAssert(url, @"URL is valid.");
    NSError* error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if(!self.player)
    {
        NSLog(@"Error creating player: %@", error);
    }
    self.player.delegate = self;
    [self.player prepareToPlay];
    
    currentTimeSlider.minimumValue = 0.0f;
    currentTimeSlider.maximumValue = self.player.duration;
    
    [self updateDisplay];
}

- (void)setupMusicPlayLive
{
    [self createStreamer];
}

- (void)stopPlaying
{
    [self.player stop];
    [self stopTimer];
    self.player.currentTime = 0;
    [self.player prepareToPlay];
    [self updateDisplay];
}

- (void)downloadMediaWithPath:(NSString *)filePath
{
    isDownloading = YES;
    NSString *url = [NSString stringWithFormat:@"%@%d.mp3",kServerMedia,playerSong.tblID];
    //NSLog(@"File URL: %@", url);
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
    if (typePlay == 1)
    {
        [self.player play];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode: NSRunLoopCommonModes];
    }
    else
    {
        [self downloadMediaWithPath:mediaPath];
        [streamer start];
    }
    
    playButton.hidden = YES;
    expandPlayButton.hidden = YES;
    
    pauseButton.hidden = NO;
    expandPauseButton.hidden = NO;
}

- (IBAction)downloadButtonClicked:(id)sender
{
    if (isDownloading == YES)
    {
        return;
    }
    [self downloadMediaWithPath:mediaPath];
}

- (IBAction)currentTimeSliderValueChanged:(id)sender
{
    if(self.timer)
        [self stopTimer];
    [self updateSliderLabels];
}

- (IBAction)currentTimeSliderTouchUpInside:(id)sender
{
    [self.player stop];
        self.player.currentTime = currentTimeSlider.value;
    [self.player prepareToPlay];
    [self playButtonClicked:self];
}

- (IBAction)expandPauseButtonClicked:(id)sender
{
    [self.player pause];
    [self stopTimer];
    [self updateDisplay];
    
    playButton.hidden = NO;
    expandPlayButton.hidden = NO;
    
    pauseButton.hidden = YES;
    expandPauseButton.hidden = YES;
}

- (IBAction)favoriteButtonClicked:(id)sender
{
    
}

- (IBAction)enIconButtonClicked:(id)sender
{
    if (currentTypeDisplay == kPlayerMusic_ENVN)
    {
        currentTypeDisplay = kPlayerMusic_EN;
    }
    else if(currentTypeDisplay == kPlayerMusic_EN)
    {
        currentTypeDisplay = kPlayerMusic_VN;
    }
    else
    {
        currentTypeDisplay = kPlayerMusic_ENVN;
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
    NSTimeInterval currentTime;
    
    if (typePlay == 1)
    {
        currentTime = self.player.currentTime;
    }
    else
    {
        currentTimeSlider.maximumValue = streamer.duration;
        currentTime = streamer.progress;
    }
    
    currentTimeSlider.value = currentTime;
    [self updateSliderLabels];
    
    //NSLog(@"%f",currentTime);
    NSNumber *timePlay = [NSNumber numberWithFloat:currentTime];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seekTime <= %@",timePlay];
    
    NSArray *arrFilter = [listItems filteredArrayUsingPredicate:predicate];
    //NSLog(@"Filter found >>>>> %@",arrFilter);
    for (int i=lastIndex; i < [arrFilter count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PlayerMusicViewCell *cell = (PlayerMusicViewCell *)[myTableView cellForRowAtIndexPath:indexPath];
        [cell setDetailTextColor:kColor_Purple];
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
        [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)updateSliderLabels
{
    NSTimeInterval currentTime = currentTimeSlider.value;
    NSString* currentTimeString = [self formattedStringForDuration:currentTime];//[NSString stringWithFormat:@"%.02f", currentTime];

    elapsedTimeLabel.text =  currentTimeString;
    remainingTimeLabel.text = [self formattedStringForDuration:self.player.duration - currentTime];
}

- (NSString*)formattedStringForDuration:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

#pragma mark - Timer

- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self updateDisplay];
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		//[self setButtonImageNamed:@"loadingbutton.png"];
	}
	else if ([streamer isPlaying])
	{
		//[self setButtonImageNamed:@"stopbutton.png"];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		//[self setButtonImageNamed:@"playbutton.png"];
	}
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%s successfully=%@", __PRETTY_FUNCTION__, flag ? @"YES"  : @"NO");
    [self stopTimer];
    [self updateDisplay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    [self stopTimer];
    [self updateDisplay];
}

- (NSInteger )getHeightForCell:(NSDictionary *)dict
{
    UILabel *enTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 305, 21)];
    UILabel *vnTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 305, 21)];
    enTextLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:14];
    vnTextLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:14];
    enTextLabel.text = [dict objectForKey:@"en"];
    vnTextLabel.text = [dict objectForKey:@"vn"];
    
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
    return [self getHeightForCell:dict];
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
    [self.player play];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode: NSRunLoopCommonModes];
    
    playButton.hidden = YES;
    expandPlayButton.hidden = YES;
    
    pauseButton.hidden = NO;
    expandPauseButton.hidden = NO;

    
    NSDictionary *dict = [listItems objectAtIndex:indexPath.row];
    self.player.currentTime = [[dict objectForKey:@"seekTime"] doubleValue];
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
        [cell setDetailTextColor:kColor_CustomGray];
    }
}


#pragma mark - ASIHttprequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    mediaSizeLabel.text = [NSString stringWithFormat:@"%@/%@",[self byteToMegaByte:request.contentLength],[self byteToMegaByte:request.contentLength]];
    isDownloading = NO;
    [download2Button setImage:[UIImage imageNamed:@"icon_check.png"] forState:UIControlStateNormal];
    download2Button.userInteractionEnabled = NO;
    downloadButton.userInteractionEnabled = NO;
    canPlay = YES;
    //----------    player --------------------
    typePlay = 1;
    [self setupMusicPlay];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    isDownloading = NO;
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
