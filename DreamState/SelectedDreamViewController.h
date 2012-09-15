//
//  SelectedDreamViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVfoundation.h>
#import "AVFoundation/AVAudioPlayer.h"
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Dream.h"
#import "SineWaveView.h"
#import "UITextFieldNoMenu.h"

@interface SelectedDreamViewController : UIViewController<AVAudioPlayerDelegate, UITextFieldDelegate>


@property (nonatomic,strong) NSString *soundFile;
@property (nonatomic, retain) MPMoviePlayerController *mediaPlayer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) Dream *existingDream;
@property (nonatomic, retain) NSTimer *levelTimer;
@property double lowPassResults;
@property double highPassResults;
@property (nonatomic, retain) SineWaveView *sineWaveView;
@property (nonatomic, retain) UIImageView *sineWaveImageView;
@property (nonatomic, retain) UITextFieldNoMenu *dreamNameTextField;

@end
