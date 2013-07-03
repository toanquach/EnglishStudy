//
//  DownloadViewController.m
//  EnglishStudy
//
//  Created by Toan Quach on 6/30/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "DownloadViewController.h"
#import "SSZipArchive.h"

@interface DownloadViewController ()
{
    __unsafe_unretained IBOutlet UIProgressView *downloadProgressBar;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *loadingView;
    __unsafe_unretained IBOutlet UIButton *closeButton;
 
    ASIHTTPRequest *dbRequest;
    BOOL isDownloading;
    
    double currentLength;
    __unsafe_unretained IBOutlet UILabel *mediaSizeLabel;
}

- (IBAction)closeButtonClicked:(id)sender;
- (void)setupView;

@end

@implementation DownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupView
{
    mediaSizeLabel.font = [UIFont fontWithName:kFont_Klavika_Regular size:15];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *filePath = [NSString stringWithFormat:@"%@loidich_v1.zip",LIBRARY_CATCHES_DIRECTORY];
    
    dbRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kServerDatabase]];
	[dbRequest setDownloadDestinationPath:filePath];
	[dbRequest setDownloadProgressDelegate:self];
    [dbRequest setShowAccurateProgress:YES];
    dbRequest.delegate = self;
    [dbRequest startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    downloadProgressBar = nil;
    loadingView = nil;
    closeButton = nil;
    mediaSizeLabel = nil;
    [super viewDidUnload];
}

- (BOOL)checkDatabaseExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [NSString stringWithFormat:@"%@data/%@",LIBRARY_CATCHES_DIRECTORY,kDabase_Name];
    if (![fileManager fileExistsAtPath:dbPath])
    {
        return NO;
    }
    return YES;
}

- (void)dismissView
{
    if ([self checkDatabaseExist] == YES)
    {
        mediaSizeLabel.text = @"Giải nén thành công.";
        [self closeButtonClicked:nil];
    }
    else
    {
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.0];
    }
}

- (IBAction)closeButtonClicked:(id)sender
{
    if ([dbRequest isExecuting] == YES)
    {
        [dbRequest cancel];        
    }

    [self dismissModalViewControllerAnimated:YES];
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

#pragma mark - ASIHttprequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    isDownloading = NO;
    mediaSizeLabel.text = @"Đang giải nén file";
    //closeButton.userInteractionEnabled = NO;
    NSString *zipPath = [NSString stringWithFormat:@"%@loidich_v1.zip",LIBRARY_CATCHES_DIRECTORY];
    NSString *destinationPath = LIBRARY_CATCHES_DIRECTORY;
    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
    
    [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.0];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    isDownloading = NO;
    [UIAppDelegate showAlertView:nil andMessage:@"Lỗi trong quá trình tải. Vui lòng thử lại!"];
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
    downloadProgressBar.progress = newProgress;
}
@end
