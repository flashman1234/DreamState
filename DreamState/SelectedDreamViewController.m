//
//  SelectedDreamViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "SelectedDreamViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DreamNameViewController.h"
#import "SineWaveView.h"

@interface SelectedDreamViewController ()
{
    MPMoviePlayerController *mediaPlayer;
}
@end

@implementation SelectedDreamViewController

@synthesize soundFile;
@synthesize mediaPlayer;
@synthesize managedObjectContext;
@synthesize existingDream;
@synthesize labelDreamName;
@synthesize nameButton;
@synthesize audioPlayer;
@synthesize sineWaveView;
@synthesize lowPassResults;
@synthesize levelTimer;
@synthesize sineWaveImageView;
@synthesize highPassResults;


-(void)playDream{
    
        NSURL *fileURL = [NSURL fileURLWithPath:[existingDream fileUrl]];
        
        self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
        
        NSString *fileType = [[existingDream fileUrl] substringFromIndex:[[existingDream fileUrl] length] - 3];
        if ([fileType isEqualToString:@"mov"]) {
            [mediaPlayer.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        }

        //self.mediaPlayer.controlStyle = MPMovieControlStyleNone;
        [mediaPlayer.view setFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height  - 30)]; 
        
        [self.view addSubview:mediaPlayer.view];
        mediaPlayer.view.layer.zPosition = -1;
        
        mediaPlayer.shouldAutoplay = NO;
        [mediaPlayer prepareToPlay];
        
}

#pragma mark - view methods


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    [self playDream];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:(BOOL)animated];
    [mediaPlayer stop];
    [mediaPlayer.view removeFromSuperview];
    [self.audioPlayer stop];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	self.title = existingDream.name;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



-(void)deleteDream{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath: [existingDream fileUrl] error: &error];
    if (error) {
        NSLog(@"error : %@", error.localizedDescription);
    }
    
    [[self managedObjectContext] deleteObject:existingDream];
    
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    if (saveError) {
        NSLog(@"error : %@", saveError.localizedDescription);
    }
    
    [mediaPlayer stop];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)deleteButtonTapped:(id)sender
{
    //[self deleteDream:soundFile];
    [self deleteDream];
}

-(IBAction)nameDream{
    DreamNameViewController *dreamNameViewController = [[DreamNameViewController alloc] init];
    dreamNameViewController.managedObjectContext = [self managedObjectContext];
    dreamNameViewController.existingDream = existingDream;
    [self.navigationController pushViewController:dreamNameViewController animated:YES];
}

@end
