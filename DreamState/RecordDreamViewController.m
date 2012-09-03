//
//  RecordDreamViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "RecordDreamViewController.h"
#import "Dream.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DreamNameViewController.h"
#import "SineWaveView.h"
#import "OnOffViewController.h"

@implementation RecordDreamViewController

@synthesize managedObjectContext;
@synthesize recordButton;
@synthesize userDefaults;
@synthesize audioOrVideo;
@synthesize recordSettings;
@synthesize dream;
@synthesize aVAudioRecorder;
@synthesize fileURL;
@synthesize mediaPlayer;
@synthesize diyCam;
@synthesize loadedFromAlarm;
@synthesize nameButton;
@synthesize isRecordingImage;
@synthesize isRecordingImageView;
@synthesize levelTimer;
@synthesize lowPassResults;
@synthesize sineWaveView;
@synthesize sineWaveImageView;
@synthesize onOffViewController;
@synthesize mySwipeUp;
@synthesize mySwipeDown;
@synthesize overlayView;

#pragma mark - Record and play video

-(void)playDream{

    self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
     
    NSString *fileType = [[fileURL absoluteString] substringFromIndex:[[fileURL absoluteString] length] - 3];
    if ([fileType isEqualToString:@"mov"]) {
        [mediaPlayer.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    }
    
    //self.mediaPlayer.controlStyle = MPMovieControlStyleNone;
    [mediaPlayer.view setFrame: CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 30)];

    [self.view insertSubview:mediaPlayer.view atIndex:self.view.subviews.count - 1];
    //[self.view addSubview:mediaPlayer.view];
    mediaPlayer.view.layer.zPosition = -1;
    
    UISwipeGestureRecognizer *mySwipeUpTemp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    mySwipeUp = mySwipeUpTemp;
    mySwipeUp.numberOfTouchesRequired = 1;
    mySwipeUp.delaysTouchesEnded = YES;
    mySwipeUp.direction = (UISwipeGestureRecognizerDirectionUp);
    [mediaPlayer.view addGestureRecognizer:mySwipeUp];
    [mediaPlayer.view addGestureRecognizer:mySwipeDown];
    
    mediaPlayer.shouldAutoplay = NO;
    [mediaPlayer prepareToPlay];
    
  }



- (void)levelTimerCallback:(NSTimer *)timer {
    if (isRecording) {
        [self.aVAudioRecorder updateMeters];

        const double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (0.05 * [self.aVAudioRecorder peakPowerForChannel:0]));
        lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
        sineWaveView.passedInValue = lowPassResults;
        [sineWaveView setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"event : %@", event);
}


-(void)startRecordingAudio
{
    if (mediaPlayer) {
        [mediaPlayer stop];
        [mediaPlayer.view removeFromSuperview];
    }
    
    isRecording = YES;
    nameButton.hidden = YES;
    /*
    UIImage *image = [UIImage imageNamed: @"Recording.png"];
    isRecordingImage = image;
    UIImageView *currentlyRecordingIcon = [[UIImageView alloc] initWithImage:isRecordingImage];
    isRecordingImageView = currentlyRecordingIcon;
    isRecordingImageView.frame = CGRectMake(280, 20, 20, 20);
    [self.view insertSubview:isRecordingImageView atIndex:100];
    */
    
    fileURL = [NSURL fileURLWithPath:[self createFileName:@"caf"]];
    
    recordSettings=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                                                  [NSNumber numberWithInt:16000.0],AVSampleRateKey,
                                                                  [NSNumber numberWithInt: 1],AVNumberOfChannelsKey,
                                                                  [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                                                  [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                                                  [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                          nil];    


    
    NSError *error = nil;
    
    
    
    AVAudioRecorder *aVAudioRecorderTemp = [[AVAudioRecorder alloc]
                                          initWithURL:fileURL
                                          settings:recordSettings
                                          error:&error];

    self.aVAudioRecorder = aVAudioRecorderTemp;
    self.aVAudioRecorder.meteringEnabled = YES;
    
    if (error){
        NSLog(@"[AVAudioRecorder alloc] error: %@", [error localizedDescription]);
        
    } 
    else {
        [aVAudioRecorder prepareToRecord];
        [aVAudioRecorder record];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        dream = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Dream"
                 inManagedObjectContext:context];
        
        NSDateFormatter *dreamDateFormatter = [[NSDateFormatter alloc] init];
        [dreamDateFormatter setDateFormat: @"dd MMM yyyy"];
        
        NSString *dreamDateAsString = [dreamDateFormatter stringFromDate:[NSDate date]];
        
        dream.name = [dreamDateAsString stringByAppendingString:@" - Audio"];
        dream.fileUrl = [fileURL path];
        dream.date = dreamDateAsString;
        dream.mediaType = @"Audio";
        dream.dateCreated = [NSDate date];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Couldn't save audio dream: %@", [error localizedDescription]);
        }
    }
    
    SineWaveView *swView2 = [[SineWaveView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40)];

    sineWaveView = swView2;
    sineWaveView.backgroundColor = [UIColor blackColor];
    sineWaveView.passedInValue = 0.0f;
    //sineWaveView.layer.zPosition = 100;
    //[self.view addSubview:sineWaveView];
    [self.view insertSubview:sineWaveView atIndex:self.view.subviews.count - 1];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view bringSubviewToFront:overlayView];

}

-(void)stopRecordingAudio
{
    if (isRecordingImageView) {
        [isRecordingImageView removeFromSuperview];
    }
    
    if (sineWaveView) {
        [sineWaveView removeFromSuperview];
    }
    isRecording = NO;
    [aVAudioRecorder stop];   
    [self playDream];
    nameButton.hidden = NO;
    
    [self.view bringSubviewToFront:overlayView];
}






#pragma mark - view methods

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)moc{
    
    if (self = [super init])
    {
        self.managedObjectContext = moc;
        
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Record"];
        UIImage *i = [UIImage imageNamed:@"record.png"];
        [tbi setImage:i];
    }
    
    return self;
}

-(void)record{
    
//        if ([audioOrVideo isEqualToString:@"Video"]) {
//            [self startRecordingVideo];
//        }
//        
//        else {
            [self startRecordingAudio];
//        }
    
}

-(void)stopRecording{
//    if ([audioOrVideo isEqualToString:@"Video"]) {
//        [self stopRecordingVideo];
//    }
//    
//    else {
        [self stopRecordingAudio];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUserDefaults];
    //NSLog(@"autoRecord : %@", autoRecord);
    
    if (autoRecord) {
        if (loadedFromAlarm) {
            [self record];
        }
    }
    
    nameButton.hidden = YES;
    NSTimer *levelTimerTemp = [NSTimer scheduledTimerWithTimeInterval: 0.02 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    
    self.levelTimer = levelTimerTemp;
    
    
    UISwipeGestureRecognizer *mySwipeUpTemp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    mySwipeUp = mySwipeUpTemp;
    mySwipeUp.numberOfTouchesRequired = 1;
    mySwipeUp.delaysTouchesEnded = YES;
    mySwipeUp.direction = (UISwipeGestureRecognizerDirectionUp);
    
    UISwipeGestureRecognizer *mySwipeDownTemp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    mySwipeDown = mySwipeDownTemp;
    mySwipeDown.numberOfTouchesRequired = 1;
    mySwipeDown.delaysTouchesEnded = YES;
    mySwipeDown.direction = (UISwipeGestureRecognizerDirectionDown);
    
    UIView *transparentView1 = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 460.f)];
    overlayView = transparentView1;
    //overlayView.layer.zPosition = 200;
    overlayView.backgroundColor = [UIColor clearColor];
    
    [overlayView addGestureRecognizer:mySwipeUp];
    [overlayView addGestureRecognizer:mySwipeDown];
    [self.view insertSubview:overlayView atIndex:self.view.subviews.count + 1];
    
//    [self.view addGestureRecognizer:mySwipeUp];
//    [self.view addGestureRecognizer:mySwipeDown];
    
    
    
    //NSLog(@"self.view.subviews.count : %d", self.view.subviews.count);
    
}

- (void) swipedScreen:(UISwipeGestureRecognizer*)swipeGesture {
    //NSLog(@"swipeGesture : %@", swipeGesture);
    
    if ([swipeGesture direction] == UISwipeGestureRecognizerDirectionUp) {
        [self record];
    }
    
    if ([swipeGesture direction] == UISwipeGestureRecognizerDirectionDown) {
        [self stopRecording];
    }
    
}



- (void) viewWillAppear:(BOOL)animated
{
    [self getUserDefaults];
    [self handleAppWhenActiveOrNot];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillAppear:animated];
}


-(void) viewWillDisappear:(BOOL)animated {
//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        
//        [diyCam stopVideoCapture];
//    }
    
    [super viewWillDisappear:animated];
    
    if (aVAudioRecorder) {
        [self stopRecordingAudio];
        //self.aVAudioRecorder = nil;
    }
   
    if (mediaPlayer) {
        [mediaPlayer stop];
        [mediaPlayer.view removeFromSuperview];
    }
    
//    if (isRecording) {
//        if (showVideoPreview) {
//            NSLog(@"diyCam : %@", diyCam);
//            if (diyCam.preview) {
//                [diyCam.preview  removeFromSuperlayer];
//            }
//            
//        }
//    }
    
    
    if (isRecordingImageView) {
        [isRecordingImageView removeFromSuperview];
    }

    isRecording = NO;
    
    [self performSelector:@selector(doHighlight:) withObject:recordButton afterDelay:0];

    nameButton.hidden = YES;
//    if (diyCam) {
//        [diyCam stopVideoCapture];
//    }
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //[diyCam stopVideoCapture];
    self.diyCam = nil;
    
    [aVAudioRecorder stop];
    self.aVAudioRecorder = nil;
    
    [mediaPlayer stop];
    [mediaPlayer.view removeFromSuperview];
//    if (showVideoPreview) {
//        [diyCam.preview  removeFromSuperlayer];
//    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)getUserDefaults{
    userDefaults = [NSUserDefaults standardUserDefaults];
    //audioOrVideo = [userDefaults objectForKey:@"Recording"];
    autoRecord = [userDefaults boolForKey:@"AutoRecord"];
    //showVideoPreview = [userDefaults boolForKey:@"VideoPreview"];
}



-(void)handleAppWhenActiveOrNot{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasResignedActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasEnteredForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
}

-(void)appHasResignedActive
{
    //[diyCam stopVideoCapture];
}

-(void)appHasEnteredForeground
{
    [self playDream];
}


- (void)doHighlight:(UIButton*)b {
    
    if (isRecording){
        [b setHighlighted:YES];
    }
    else {
        [b setHighlighted:NO];
    }
}




#pragma mark - IBActions

-(IBAction)recordButtonTapped:(id)sender{
   
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
       
    
    
//   if ([audioOrVideo isEqualToString:@"Video"]) {
//       if (isRecording) {
//           [self stopRecordingVideo];
//       }
//       else {
//           [self startRecordingVideo];
//       }
//   }
//   else {
       if (isRecording) {
           [self stopRecordingAudio];
       }
       else {
           [self startRecordingAudio];
       }
//   } 
}

-(IBAction)nameDreamButtonTapped{
    DreamNameViewController *dreamNameViewController = [[DreamNameViewController alloc] init];
    dreamNameViewController.managedObjectContext = [self managedObjectContext];
    dreamNameViewController.existingDream = dream;
    [self.navigationController pushViewController:dreamNameViewController animated:YES];
    
}



#pragma mark - Cam Delegate events

- (void)camReady:(DIYCam *)cam
{
    NSLog(@"cam Ready");
}

- (void)camDidFail:(DIYCam *)cam withError:(NSError *)error
{
    NSLog(@" camDidFail Error: %@", error);
}

- (void)camCaptureStarted:(DIYCam *)cam
{
    NSLog(@"Capture started");
}

- (void)camCaptureStopped:(DIYCam *)cam
{
    NSLog(@"Capture stopped");
}

- (void)camCaptureProcessing:(DIYCam *)cam
{
    NSLog(@"Capture Processing...");
}

- (void)camCaptureComplete:(DIYCam *)cam withAsset:(NSDictionary *)asset
{
     NSLog(@"Capture complete");
}


#pragma mark - file handlers

-(NSString*)createFileName:(NSString*)fileType
{
    NSArray *documentDirectoryPaths;
    NSString *documentDirectory;
    
    documentDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectory = [documentDirectoryPaths objectAtIndex:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *theFileName = [NSString stringWithFormat: @"%@.%@", [formatter stringFromDate:[NSDate date]], fileType];
    NSString *fullFilePath = [documentDirectory stringByAppendingPathComponent:theFileName];
   // fileURLAsString = fullFilePath;
    return fullFilePath;
}

#pragma mark - video controls
-(void)startRecordingVideo
{
    nameButton.hidden = YES;
    isRecording = YES;
    UIImage *image = [UIImage imageNamed: @"Recording.png"];
    isRecordingImage = image;
    UIImageView *currentlyRecordingIcon = [[UIImageView alloc] initWithImage:isRecordingImage];
    isRecordingImageView = currentlyRecordingIcon;
    isRecordingImageView.frame = CGRectMake(280, 20, 20, 20);
    [self.view insertSubview:isRecordingImageView atIndex:100];
    
    
    DIYCam *tempDIYCam = [[DIYCam alloc] init];
    
    diyCam = tempDIYCam;
    [[self diyCam] setDelegate:self];
    [[self diyCam] setup];
    
    if (showVideoPreview) {
        diyCam.preview.frame       = self.view.frame;
        //diyCam.preview.transform= CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);
        CGRect bounds           = CGRectMake(0, 0, self.view.layer.bounds.size.width, 380);
        diyCam.preview.bounds      = bounds;
        diyCam.preview.position    = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        diyCam.preview.zPosition = -1;
        
        [self.view.layer addSublayer:diyCam.preview];
    }
    
    NSString *videoFile = [self createFileName:@"mov"];
    
    NSURL *fileURLTemp = [NSURL fileURLWithPath:videoFile];
    fileURL = fileURLTemp;
    
    [diyCam startVideoCapture:videoFile];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    dream = [NSEntityDescription
             insertNewObjectForEntityForName:@"Dream"
             inManagedObjectContext:context];
    
    NSDateFormatter *dreamDateFormatter = [[NSDateFormatter alloc] init];
    [dreamDateFormatter setDateFormat: @"dd MMM yyyy"];
    
    NSString *dreamDateAsString = [dreamDateFormatter stringFromDate:[NSDate date]];
    
    dream.name = [dreamDateAsString stringByAppendingString:@" - Video"];
    dream.fileUrl = videoFile;
    dream.date = dreamDateAsString;
    dream.mediaType = @"Video";
    dream.dateCreated = [NSDate date];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    //    OnOffViewController *onOffViewControllerTemp = [[OnOffViewController alloc] init];
    //    onOffViewController = onOffViewControllerTemp;
    //    onOffViewControllerTemp.view.frame = CGRectMake(50, 200, 150, 150);
    //    [self.view addSubview:onOffViewController.view];
    
    
}

-(void)stopRecordingVideo
{
    if (isRecordingImageView) {
        [isRecordingImageView removeFromSuperview];
    }
    if (showVideoPreview) {
        [diyCam.preview removeFromSuperlayer];
    }
    isRecording = NO;
    //nameButton.hidden = NO;
    [diyCam stopVideoCapture];
    [self playDream];
}

@end
