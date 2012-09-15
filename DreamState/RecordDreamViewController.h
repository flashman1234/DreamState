//
//  RecordDreamViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVfoundation.h>
#import "DIYCam.h"
#import "Dream.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SineWaveView.h"
#import "UITextFieldNoMenu.h"

@interface RecordDreamViewController : UIViewController <AVAudioRecorderDelegate, UITextFieldDelegate>
{
    BOOL autoRecord;
    BOOL showVideoPreview;
    BOOL isRecording;
    BOOL loadedFromAlarm;
}

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)moc;
-(void)levelTimerCallback:(NSTimer *)timer;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSString *audioOrVideo;
@property (nonatomic, retain) NSDictionary *recordSettings;
@property (nonatomic, retain) Dream *dream;
@property (nonatomic, retain) AVAudioRecorder *aVAudioRecorder;
@property (nonatomic, retain) NSURL  *fileURL;

@property (nonatomic, retain) MPMoviePlayerController *mediaPlayer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) UIView *overlayView;

@property (nonatomic, retain) DIYCam *diyCam;
@property BOOL loadedFromAlarm;
@property (nonatomic, retain) UIImage *isRecordingImage;
@property (nonatomic, retain) UIImageView *isRecordingImageView;
@property (nonatomic, retain) SineWaveView *sineWaveView;
@property (nonatomic, retain) UIImageView *sineWaveImageView;
@property (nonatomic, retain) NSTimer *levelTimer;
@property double lowPassResults;


@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UITextFieldNoMenu *dreamNameTextField;


@end
