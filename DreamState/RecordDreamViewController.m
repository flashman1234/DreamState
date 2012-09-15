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
#import "SineWaveView.h"
#import "UITextFieldNoMenu.h"

@implementation RecordDreamViewController

@synthesize managedObjectContext;
@synthesize userDefaults;
@synthesize audioOrVideo;
@synthesize recordSettings;
@synthesize dream;
@synthesize aVAudioRecorder;
@synthesize fileURL;
@synthesize mediaPlayer;
@synthesize diyCam;
@synthesize loadedFromAlarm;
@synthesize isRecordingImage;
@synthesize isRecordingImageView;
@synthesize levelTimer;
@synthesize lowPassResults;
@synthesize sineWaveView;
@synthesize sineWaveImageView;
@synthesize overlayView;
@synthesize audioPlayer;
@synthesize segmentedControl;
@synthesize dreamNameTextField;


#pragma mark - textfield

-(void)addTextField{
    UITextFieldNoMenu *textField = [[UITextFieldNoMenu alloc] initWithFrame:CGRectMake(10, 170, 300, 30)];
    dreamNameTextField = textField;
    
    dreamNameTextField.backgroundColor = [UIColor blackColor];
    [dreamNameTextField setFont:[UIFont fontWithName:@"Solari" size:20]];
    dreamNameTextField.textColor = [UIColor whiteColor];
    dreamNameTextField.borderStyle = UITextBorderStyleBezel;
    dreamNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    dreamNameTextField.returnKeyType = UIReturnKeyDone;
    
    CGFloat myWidth = 26.0f;
    CGFloat myHeight = 30.0f;
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myWidth, myHeight)];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateHighlighted];
    
    [myButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    
    dreamNameTextField.rightView = myButton;
    dreamNameTextField.rightViewMode = UITextFieldViewModeAlways;
    
    dreamNameTextField.text = dream.name;
    dreamNameTextField.delegate = self;
    [self.view addSubview:dreamNameTextField];
    [dreamNameTextField becomeFirstResponder];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)iTextField {
    [iTextField selectAll:self];
}



-(void)doClear:(id)sender{
    dreamNameTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    dream.name = dreamNameTextField.text;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save audio dream: %@", [error localizedDescription]);
    }
    
    [theTextField resignFirstResponder];
    
    [self.tabBarController setSelectedIndex:2];
    
    return YES;
}




#pragma mark - Record and play video

-(void)playDream{

    self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
    mediaPlayer.view.tag = 100;
     
    NSString *fileType = [[fileURL absoluteString] substringFromIndex:[[fileURL absoluteString] length] - 3];
    if ([fileType isEqualToString:@"mov"]) {
        [mediaPlayer.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    }
    
    self.mediaPlayer.controlStyle = MPMovieControlStyleEmbedded;
    [mediaPlayer.view setFrame: CGRectMake(0, 30, self.view.bounds.size.width, 50)];

    [self.view addSubview:mediaPlayer.view];    
    mediaPlayer.shouldAutoplay = NO;
    [mediaPlayer prepareToPlay];    
    
    [self addTextField];
    
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

-(void)startRecordingAudio
{
    if (mediaPlayer) {
        [mediaPlayer stop];
        [mediaPlayer.view removeFromSuperview];
    }
    if (dreamNameTextField) {
        [dreamNameTextField removeFromSuperview];
    }
    
    isRecording = YES;

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
    if (error){
        NSLog(@"[AVAudioRecorder alloc] error: %@", [error localizedDescription]);
    } 
    else {
        self.aVAudioRecorder = aVAudioRecorderTemp;
        self.aVAudioRecorder.meteringEnabled = YES;
    
    
        [aVAudioRecorder prepareToRecord];
        [aVAudioRecorder record];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        dream = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Dream"
                 inManagedObjectContext:context];
        
        NSDateFormatter *dreamDateFormatter = [[NSDateFormatter alloc] init];
        [dreamDateFormatter setDateFormat: @"dd MMM yyyy"];
        
        NSString *dreamDateAsString = [dreamDateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *dreamTimeFormatter = [[NSDateFormatter alloc] init];
        [dreamTimeFormatter setDateFormat: @"HH:mm"];
        
        NSString *dreamTimeAsString = [dreamTimeFormatter stringFromDate:[NSDate date]];
        
        dream.name = [dreamDateAsString stringByAppendingString:@""];
        dream.fileUrl = [fileURL path];
        dream.date = dreamDateAsString;
        dream.mediaType = @"Audio";
        dream.dateCreated = [NSDate date];
        dream.time = dreamTimeAsString;
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Couldn't save audio dream: %@", [error localizedDescription]);
        }
    }
    
    SineWaveView *swView2 = [[SineWaveView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 140)];

    sineWaveView = swView2;
    sineWaveView.backgroundColor = [UIColor blackColor];
    sineWaveView.passedInValue = 0.0f;
    //[self.view addSubview:sineWaveView];
    [self.view insertSubview:sineWaveView atIndex:self.view.subviews.count - 1];
 


}

-(void)stopRecordingAudio
{
    if (sineWaveView) {
        [sineWaveView removeFromSuperview];
    }
    isRecording = NO;
    [aVAudioRecorder stop];   
    [self playDream];

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



-(void)segmentValueChanged:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
        [self startRecordingAudio];
  
    else if(segment.selectedSegmentIndex == 1)
        [self stopRecordingAudio];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    //if (!loadedFromAlarm) {
    if (autoRecord) {
        segmentedControl.selectedSegmentIndex = 0;
        [self startRecordingAudio];
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    if (isRecording) {
        [self stopRecordingAudio];
    }
    
    if (mediaPlayer) {
        [mediaPlayer stop];
        [mediaPlayer.view removeFromSuperview];
        mediaPlayer = nil;
    }
    
    if (dreamNameTextField) {
        [dreamNameTextField removeFromSuperview];
    }
        
    UIView *b = (UIView *)[self.view viewWithTag:100];
    [b removeFromSuperview];
    b = nil;
    
    isRecording = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUserDefaults];
    

    NSTimer *levelTimerTemp = [NSTimer scheduledTimerWithTimeInterval: 0.02 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    
    self.levelTimer = levelTimerTemp;
    
    
    //segment control
    NSArray *itemArray = [NSArray arrayWithObjects: @"Record", @"Stop", nil];
    UISegmentedControl *segmentedControlTemp = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl = segmentedControlTemp;
    segmentedControl.frame = CGRectMake(35, 330, 250, 50);
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    UIFont *font = [UIFont fontWithName:@"Solari" size:20];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [segmentedControl setTitleTextAttributes:attributes 
                                    forState:UIControlStateNormal];
    
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Solari" size:20],UITextAttributeFont,
                                        [UIColor redColor], UITextAttributeTextColor,                                      
                                        nil] ;
    [segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    
    segmentedControl.tintColor = [UIColor darkGrayColor];
    
    [segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [self getUserDefaults];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    segmentedControl.selectedSegmentIndex = -1;
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)getUserDefaults{
    userDefaults = [NSUserDefaults standardUserDefaults];
    autoRecord = [userDefaults boolForKey:@"AutoRecord"];
}

- (void)doHighlight:(UIButton*)b {
    
    if (isRecording){
        [b setHighlighted:YES];
    }
    else {
        [b setHighlighted:NO];
    }
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




@end
