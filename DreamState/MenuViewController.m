//
//  ViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "MenuViewController.h"
//#import "AlarmViewController.h"
#import "AlarmListViewController.h"

#import "CurrentDreamsViewController.h"
#import "RecordDreamViewController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "InAppSettings.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize alarmButton, currentDreamButton, recordDreamButton, settingsButton;


-(IBAction)pressAlarmButton{
    AlarmListViewController *alarmController = [[AlarmListViewController alloc] init];
    [self.navigationController pushViewController:alarmController animated:YES];
   
}
-(IBAction)pressCurrentDreamButton{
    CurrentDreamsViewController *currentDreamsController = [[CurrentDreamsViewController alloc] init];
    [self.navigationController pushViewController:currentDreamsController animated:YES];
    
}
-(IBAction)pressRecordDreamButton{
    RecordDreamViewController *recordDreamController = [[RecordDreamViewController alloc] init];
    [self.navigationController pushViewController:recordDreamController animated:YES];
}

-(IBAction)pressSettingsButton{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Dream State";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localAction) name:localReceived object:nil];

}

-(void)localAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RecordDreamViewController *recordDreamController = [[RecordDreamViewController alloc] init];
    [self.navigationController pushViewController:recordDreamController animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }

    return NO;
}

@end
