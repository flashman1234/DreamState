//
//  RecordDreamViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVfoundation.h>
#import "AVFoundation/AVAudioPlayer.h"
#import <CoreAudio/CoreAudioTypes.h>
#import "DIYCam.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RecordDreamViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate, DIYCamDelegate>
{
    //UIButton *playButton;
    UIButton *recButton;
    UIButton *stopButton;
    UIButton *deleteButton;

    
    
    
    
    
    //BOOL isRecording;

    
    
    
    NSURL *tempRecFile;
    AVAudioRecorder *audioRecorder;
    AVCaptureSession *session;
    //DIYCam *cam;
    
    BOOL autoRecord;

}

@property(nonatomic, retain)IBOutlet UIImageView *currentlyRecordingIcon;

//@property(nonatomic, retain)IBOutlet UIButton *playButton;
@property(nonatomic, retain)IBOutlet UIButton *recButton;
@property(nonatomic, retain)IBOutlet UIButton *stopButton;
@property(nonatomic, retain)IBOutlet UIButton *deleteButton;



@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSURL *soundFileURL;
@property (nonatomic, retain) NSDictionary *recordSettings;

@property (nonatomic, retain) NSURL  *fileURL;
@property (nonatomic, retain) NSString  *fileURLAsString;


@property (nonatomic, retain) DIYCam *cam;


@property (nonatomic, retain) IBOutlet UIView *display;
//@property (nonatomic, retain) IBOutlet UIButton *capturePhoto;
//@property (nonatomic, retain) IBOutlet UIButton *captureVideo;
//@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;


@property (nonatomic, retain) NSURL  *videoURL;
@property (nonatomic, retain) MPMoviePlayerController *mediaPlayer;

@property (nonatomic, retain) NSUserDefaults *defaults;

@property (nonatomic, retain) NSString *audioOrVideo;


-(IBAction)recordDream;
//-(IBAction)playBack;
-(IBAction)deleteDream;
-(IBAction)stopRecording;


@end
