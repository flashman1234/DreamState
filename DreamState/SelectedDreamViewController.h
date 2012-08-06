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

@interface SelectedDreamViewController : UIViewController<AVAudioPlayerDelegate>
{
    NSString *soundFile;
}

-(IBAction)playButtonTapped:(id)sender;
-(IBAction)deleteButtonTapped:(id)sender;

@property (nonatomic,strong) NSString *soundFile;

@property (nonatomic, retain) MPMoviePlayerController *mediaPlayer;
@property (nonatomic, retain) IBOutlet UIView *display;

@end
