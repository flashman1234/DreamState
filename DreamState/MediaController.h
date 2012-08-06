//
//  MediaController.h
//  DreamState
//
//  Created by Michal Thompson on 8/6/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVfoundation.h>
#import "AVFoundation/AVAudioPlayer.h"
#import <CoreAudio/CoreAudioTypes.h>
#import "DIYCam.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MediaController : NSObject

@property (nonatomic, retain) MPMoviePlayerController *mediaPlayer;
@property (nonatomic, retain) NSURL  *fileURL;
@property (nonatomic, retain) NSString  *fileURLAsString;

@end
