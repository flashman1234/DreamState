//
//  AlarmSoundViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/24/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmSoundViewController.h"
#import "AlarmViewController.h"
#import <QuartzCore/QuartzCore.h>

#define encUrl(x) [NSURL URLWithString:[x stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]

@implementation AlarmSoundViewController

@synthesize alarmSoundTableView;
@synthesize soundArray;
@synthesize existingSound;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.soundArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.alarmSoundTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else {
        UILabel *text = (UILabel *)[cell.contentView viewWithTag:1];
        if ([text superview]) {
            [text removeFromSuperview];
        }
    }
    
    UILabel *dreamLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 290, 25)];
    dreamLabel.tag = 1;        
    [dreamLabel setFont:[UIFont fontWithName:@"Solari" size:20]];
    dreamLabel.textColor = [UIColor whiteColor];
    dreamLabel.backgroundColor = [UIColor clearColor];
    dreamLabel.text = [self.soundArray objectAtIndex:indexPath.row];

    [cell.contentView addSubview:dreamLabel];

    cell.accessoryType = UITableViewCellAccessoryNone;
   
    if ([existingSound isEqualToString:[self.soundArray objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    for (NSIndexPath *algoPath in [tableView indexPathsForVisibleRows]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:algoPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(algoPath.row == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    [self playSound:[self.soundArray objectAtIndex:indexPath.row]];
}

-(void)playSound:(NSString *)alarmSound{
    //NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.m4a", [[NSBundle mainBundle] resourcePath], alarmSound]];
    
    NSString *c = [NSString stringWithFormat:@"%@/%@.m4a", [[NSBundle mainBundle] resourcePath], alarmSound];
    
    NSString *path = [c stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
    NSURL *url = [NSURL URLWithString:path];

	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
	
	if (audioPlayer == nil)
        NSLog(@"error.localizedDescription : %@", error.localizedDescription);
	else 
		[audioPlayer play];
}

-(void)cancelAlarmSound:(id)sender{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)saveAlarmSound:(id)sender{
    AlarmViewController *parentViewController = (AlarmViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        NSIndexPath *selectedIndexPath = [alarmSoundTableView indexPathForSelectedRow];
    parentViewController.alarmSound = [self.soundArray  objectAtIndex:selectedIndexPath.row];
        
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    alarmSoundTableView.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                              target:self action:@selector(cancelAlarmSound:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarmSound:)];
    
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Alarm sounds";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


-(void)viewWillDisappear:(BOOL)animated
{  
    [audioPlayer stop];
}



@end
