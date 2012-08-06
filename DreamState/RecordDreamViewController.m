//
//  RecordDreamViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "RecordDreamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>



@interface RecordDreamViewController ()
{
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    NSURL *soundFileURL;
    NSDictionary *recordSettings;
    NSURL  *videoURL;
    MPMoviePlayerController *mediaPlayer;
    NSUserDefaults *defaults;
    NSString *audioOrVideo;
        
}
@end



@implementation RecordDreamViewController
@synthesize  recorder, soundFileURL, recordSettings, player, cam, videoURL, mediaPlayer, defaults, audioOrVideo, currentlyRecordingIcon, fileURLAsString;

@synthesize recButton, stopButton, deleteButton;

@synthesize display, fileURL;



-(IBAction)deleteDream{
    [self deleteFile];
}

-(IBAction)stopRecording{
    
    if ([audioOrVideo isEqualToString:@"Video"]) {
        [self stopRecordingVideo];
    }
    else {
        [self stopRecordingAudio];
    }
}

-(IBAction)recordDream
{
    if ([audioOrVideo isEqualToString:@"Video"]) {
        [self recordDreamVideo];
    }
    else {
        [self recordDreamSound];
    }
}

-(void)deleteFile
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath: [NSString stringWithFormat:@"%@", fileURLAsString] error: &error];
    
    if (error) {
        NSLog(@"delete file error : %@", error);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)playDream{
    
    NSURL  *tempfileURL;
    
    if ([audioOrVideo isEqualToString:@"Video"]) {
        tempfileURL = videoURL; 
    }
    else {
        tempfileURL = recorder.url;
    }
    fileURL = tempfileURL;
    
    [cam.preview  removeFromSuperlayer];
    
    MPMoviePlayerController *tempMediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
    self.mediaPlayer = tempMediaPlayer;

    CGRect bounds = CGRectMake(0, 0, display.layer.bounds.size.width, 380);
    
    [mediaPlayer.view setFrame: bounds]; 
    [display addSubview:mediaPlayer.view];
    mediaPlayer.view.layer.zPosition = -1;
    self.mediaPlayer.shouldAutoplay = NO;
        
}





-(void)recordDreamSound
{
    stopButton.hidden = NO;
    deleteButton.hidden = YES;
    recButton.hidden = YES;
    currentlyRecordingIcon.image = [UIImage imageNamed:@"Recording.png"];
    
    NSURL *tempSoundFileURL = [NSURL fileURLWithPath:[self createFileName:@"caf"]];
    soundFileURL = tempSoundFileURL;
    
    NSDictionary *tempRecordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMax],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], 
                                    AVSampleRateKey,
                                    nil];
    
    self.recordSettings = tempRecordSettings;
    
    NSError *error = nil;
    
    AVAudioRecorder *tempAudioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    self.recorder = tempAudioRecorder;
    
    
    if (error){
        NSLog(@"[AVAudioRecorder alloc] error: %@", [error localizedDescription]);
        
    } 
    else {
        [recorder prepareToRecord];
        [recorder record];
    }
}

-(void)stopRecordingAudio
{
    currentlyRecordingIcon.image = [UIImage imageNamed:@"NotRecording.png"];
    //playButton.hidden = NO;
    deleteButton.hidden = NO;
    recButton.hidden = NO;
    stopButton.hidden = YES;
    
    
    [recorder stop];
    [self playDream];
}


-(void)recordDreamVideo
{
    stopButton.hidden = NO;
    deleteButton.hidden = YES;
    recButton.hidden = YES;
    currentlyRecordingIcon.image = [UIImage imageNamed:@"Recording.png"];
    
    [self.view bringSubviewToFront:currentlyRecordingIcon];
    
    [self.view insertSubview:currentlyRecordingIcon atIndex:100];
    currentlyRecordingIcon.frame = CGRectMake(280, 20, 20, 20);
    //currentlyRecordingIcon.
    
    
    DIYCam *tempDIYCam = [[DIYCam alloc] init];
    
    cam = tempDIYCam;
    [[self cam] setDelegate:self];
    [[self cam] setup];
    
    // Preview
    cam.preview.frame       = display.frame;
    [display.layer addSublayer:cam.preview];
    
    CGRect bounds           = CGRectMake(0, 0, display.layer.bounds.size.width, 380);
    cam.preview.bounds      = bounds;
    cam.preview.position    = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    cam.preview.zPosition = -1;
    
    NSString *videoFile = [self createFileName:@"mov"];
    
    NSURL *tempVideoURL = [NSURL fileURLWithPath:videoFile];
    videoURL = tempVideoURL;

    [cam startVideoCapture:videoFile];

}

-(void)stopRecordingVideo
{
    currentlyRecordingIcon.image = [UIImage imageNamed:@"NotRecording.png"];
    stopButton.hidden = YES;
    deleteButton.hidden = NO;
    recButton.hidden = NO;
    [cam stopVideoCapture];
    [self playDream];
}







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)appHasResignedActive
{
    //NSLog(@"UIApplicationWillResignActiveNotification ");
    [cam stopVideoCapture];
}

-(void)appHasEnteredForeground
{
    //NSLog(@"UIApplicationWillEnterForegroundNotification ");
//    isRecording = YES;
//    playButton.hidden = YES;
    
    //[self recordDreamVideo];
    
    [self playDream];
}

- (void)viewDidLoad
{
    self.title = @"Record a dream";

    NSUserDefaults *tempNSUserDefaults = [NSUserDefaults standardUserDefaults];
    defaults = tempNSUserDefaults;
    
    NSString *tempAudioOrVideo = [defaults objectForKey:@"Recording"];
    audioOrVideo = tempAudioOrVideo;
    
    
    BOOL tempAutoRecord = [defaults boolForKey:@"AutoRecord"];
    autoRecord = tempAutoRecord;
    NSLog(@"autoRecord %d", (int)autoRecord);
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasResignedActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasEnteredForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    
    
   
    //isRecording = YES;
    //playButton.hidden = YES;
    //recordStopButton.image = [UIImage imageNamed:@"Recording.png"];
    //[self.view insertSubview:recordStopButton atIndex:10];
    
    
    if (autoRecord) {
        if ([audioOrVideo isEqualToString:@"Video"]) {
            [self recordDreamVideo];
        }
        
        else {
            [self recordDreamSound];
        }
    }
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
       
        [cam stopVideoCapture];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [cam stopVideoCapture];
    self.cam = nil;
    
    [recorder stop];
    self.recorder = nil;
    
    [player stop];
    [mediaPlayer.view removeFromSuperview];
    [cam.preview  removeFromSuperlayer];

}








- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return NO;
}



#pragma mark - Delegate events

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
    
//    if ([[asset objectForKey:@"type"] isEqualToString:@"video"])
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            
//            UIImage *image = [UIImage imageWithContentsOfFile:[asset objectForKey:@"thumbnail"]];
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                thumbnail.image = image;
//            });
//            
//        });
//    }
}


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
    fileURLAsString = fullFilePath;
    return fullFilePath;
}


@end
