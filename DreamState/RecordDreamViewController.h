//
//  RecordDreamViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVfoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "DIYCam.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Dream.h"

@interface RecordDreamViewController : UIViewController <AVAudioRecorderDelegate,DIYCamDelegate>
{
    UIButton *recButton;
    UIButton *stopButton;
    UIButton *deleteButton;
    UIButton *nameButton;
    
    UIToolbar *bottomBar;
    
    BOOL autoRecord;
    BOOL showPreview;
}

@property (nonatomic, retain) IBOutlet UIView *display;
@property(nonatomic, retain)IBOutlet UIImageView *currentlyRecordingIcon;
@property(nonatomic, retain)IBOutlet UILabel *recordingAudioLabel;
@property(nonatomic, retain)IBOutlet UIButton *recButton;
@property(nonatomic, retain)IBOutlet UIButton *stopButton;
@property(nonatomic, retain)IBOutlet UIButton *deleteButton;
@property(nonatomic, retain)IBOutlet UIButton *nameButton;

@property(nonatomic, retain)IBOutlet UIToolbar *bottomBar;

@property (nonatomic, retain) DIYCam *cam;
@property (nonatomic, retain) MPMoviePlayerController *mediaPlayer;
@property (nonatomic, retain) AVAudioRecorder *recorder;

@property (nonatomic, retain) NSDictionary *recordSettings;

@property (nonatomic, retain) NSURL *soundFileURL;
@property (nonatomic, retain) NSURL  *fileURL;
@property (nonatomic, retain) NSString  *fileURLAsString;
@property (nonatomic, retain) NSURL  *videoURL;

@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) NSString *audioOrVideo;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property ( nonatomic , retain ) Dream *dream;


-(IBAction)recordDream;
-(IBAction)deleteDream;
-(IBAction)stopRecording;
-(IBAction)nameDream;

@end
