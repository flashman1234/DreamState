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


#import "Alarm.h"


@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize alarmButton, currentDreamButton, recordDreamButton, settingsButton;

@synthesize alarms;


@synthesize managedObjectContext;

#pragma mark - IBActions

-(IBAction)pressAlarmButton{
    AlarmListViewController *alarmController = [[AlarmListViewController alloc] init];
    alarmController.managedObjectContext = [self managedObjectContext];
    [self.navigationController pushViewController:alarmController animated:YES];
   
}
-(IBAction)pressCurrentDreamButton{
    CurrentDreamsViewController *currentDreamsController = [[CurrentDreamsViewController alloc] init];
    currentDreamsController.managedObjectContext = [self managedObjectContext];
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

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Dream State";
    
    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Alarm" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.alarms = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"self.alarms : %@", self.alarms);
    
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
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
