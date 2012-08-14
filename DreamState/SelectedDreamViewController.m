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

@interface SelectedDreamViewController ()
{
    MPMoviePlayerController *mediaPlayer;
}
@end

@implementation SelectedDreamViewController

@synthesize soundFile;
@synthesize mediaPlayer;
//@synthesize display;
@synthesize managedObjectContext;
@synthesize existingDream;
@synthesize labelDreamName;
@synthesize nameButton;


#pragma mark - IBActions

-(IBAction)playButtonTapped:(id)sender
{
    [self playDream];
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



-(void)playDream{
    
    NSURL *fileURL = [NSURL fileURLWithPath:[existingDream fileUrl]];
    
    self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
    
    NSString *fileType = [[existingDream fileUrl] substringFromIndex:[[existingDream fileUrl] length] - 3];
    if ([fileType isEqualToString:@"mov"]) {
        [mediaPlayer.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    }
    
    //Use MPMovieControlStyleNone if you want to add my own buttons
    self.mediaPlayer.controlStyle = MPMovieControlStyleNone;
    
    //CGRect bounds           = CGRectMake(0, -46, self.view.bounds.size.width, self.view.bounds.size.height +92);
    [mediaPlayer.view setFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 30)]; 
    

    
    [self.view addSubview:mediaPlayer.view];
    mediaPlayer.view.layer.zPosition = -1;
    
    [mediaPlayer prepareToPlay];

    [mediaPlayer play];
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:(BOOL)animated];
    [mediaPlayer stop];
    [mediaPlayer.view removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	labelDreamName.text = existingDream.name;
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
