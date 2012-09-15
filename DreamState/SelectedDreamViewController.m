//
//  SelectedDreamViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "SelectedDreamViewController.h"
#import <MediaPlayer/MediaPlayer.h>
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
@synthesize audioPlayer;
@synthesize sineWaveView;
@synthesize lowPassResults;
@synthesize levelTimer;
@synthesize sineWaveImageView;
@synthesize highPassResults;
@synthesize dreamNameTextField;


-(void)addTextField{
    UITextFieldNoMenu *textField = [[UITextFieldNoMenu alloc] initWithFrame:CGRectMake(10, 170, 300, 30)];
    dreamNameTextField = textField;
    
    dreamNameTextField.backgroundColor = [UIColor blackColor];
    [dreamNameTextField setFont:[UIFont fontWithName:@"Solari" size:20]];
    dreamNameTextField.textColor = [UIColor whiteColor];
    dreamNameTextField.borderStyle = UITextBorderStyleBezel;
    dreamNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    CGFloat myWidth = 26.0f;
    CGFloat myHeight = 30.0f;
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myWidth, myHeight)];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateHighlighted];
    
    [myButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    
    dreamNameTextField.rightView = myButton;
    dreamNameTextField.rightViewMode = UITextFieldViewModeAlways;
    
    dreamNameTextField.text = existingDream.name;
    dreamNameTextField.delegate = self;
    [self.view addSubview:dreamNameTextField];
    
}

-(void)doClear:(id)sender{
    self.title = dreamNameTextField.text;
    dreamNameTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    existingDream.name = dreamNameTextField.text;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save audio dream: %@", [error localizedDescription]);
    }
    self.title = dreamNameTextField.text;
    [theTextField resignFirstResponder];
    return YES;
}




-(void)playDream{
    
    NSURL *fileURL = [NSURL fileURLWithPath:[existingDream fileUrl]];
    
    self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
    
    NSString *fileType = [[existingDream fileUrl] substringFromIndex:[[existingDream fileUrl] length] - 3];
    if ([fileType isEqualToString:@"mov"]) {
        [mediaPlayer.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    }

    //self.mediaPlayer.controlStyle = MPMovieControlStyleNone;
    [mediaPlayer.view setFrame: CGRectMake(0, 0, self.view.bounds.size.width, 50)]; 
    
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
    [self addTextField];
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

@end
