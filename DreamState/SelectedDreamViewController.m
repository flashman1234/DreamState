//
//  SelectedDreamViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "SelectedDreamViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SelectedDreamViewController ()
{
    MPMoviePlayerController *mediaPlayer;
}
@end

@implementation SelectedDreamViewController

@synthesize soundFile;
@synthesize mediaPlayer;
@synthesize display;


#pragma mark - IBActions

-(IBAction)playButtonTapped:(id)sender
{
    [self playBack:soundFile];
}

-(IBAction)deleteButtonTapped:(id)sender
{
    [self deleteDream:soundFile];
}


-(void)playBack:(NSString *)dreamFileName{
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:dreamFileName];

    NSURL *fileURL = [NSURL fileURLWithPath:soundFilePath];

    self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
    
    //Use MPMovieControlStyleNone if you want to add my own buttons
    //self.mediaPlayer.controlStyle = MPMovieControlStyleNone;

    [mediaPlayer prepareToPlay];
    
    CGRect bounds           = CGRectMake(0, 0, display.layer.bounds.size.width, display.layer.bounds.size.height - 30);
    
    [mediaPlayer.view setFrame: bounds]; 
    
    //force player into portrait
    NSString *fileType = [soundFilePath substringFromIndex:[soundFilePath length] - 3];
    if ([fileType isEqualToString:@"mov"]) {
        [mediaPlayer.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    }
    
    [display addSubview:mediaPlayer.view];
    mediaPlayer.view.layer.zPosition = -1;
    [mediaPlayer play];
    
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



#pragma mark - view methods

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
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
