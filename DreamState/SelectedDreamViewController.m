//
//  SelectedDreamViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "SelectedDreamViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SelectedDreamViewController ()
{
    AVAudioPlayer *player;
    MPMoviePlayerController *mediaPlayer;
}
@end

@implementation SelectedDreamViewController

@synthesize soundFile;
@synthesize mediaPlayer;
@synthesize display;


-(IBAction)playButtonTapped:(id)sender
{
    [self playBack:soundFile];
}

-(IBAction)deleteButtonTapped:(id)sender
{
    [self deleteDream:soundFile];
}

-(void)deleteDream:(NSString *)dreamFileName{
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", dreamFileName]];
    
    NSLog(@"soundFilePath : %@", soundFilePath);
    [[NSFileManager defaultManager] removeItemAtPath: soundFilePath error: nil];
    [mediaPlayer stop];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)playBack:(NSString *)dreamFileName{
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:dreamFileName];

    NSURL *videoURL = [NSURL fileURLWithPath:soundFilePath];

    self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoURL];
    
    //self.mediaPlayer.controlStyle = MPMovieControlStyleNone;

    
    [mediaPlayer prepareToPlay];
    
    CGRect bounds           = CGRectMake(0, 0, display.layer.bounds.size.width, 380);
    
    [mediaPlayer.view setFrame: bounds];  // player's frame must match parent's
    [display addSubview:mediaPlayer.view];
    mediaPlayer.view.layer.zPosition = -1;
    [mediaPlayer play];
    
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:(BOOL)animated];
    [mediaPlayer stop];
    [mediaPlayer.view removeFromSuperview];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return NO;
}

@end
