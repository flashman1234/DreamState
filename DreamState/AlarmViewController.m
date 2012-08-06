//
//  AlarmViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmViewController.h"
#import "AppDelegate.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController
@synthesize alarmTableView;
@synthesize tableDataSource;
@synthesize existingAlarmDate;


-(void)scheduledNotificationWithDate:(NSDate *)fireDate {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = fireDate;
    notification.alertBody = @"Would you like to record a dream?";
       
    existingAlarmDate = nil;
    
    notification.soundName = @"alarm-clock-1.caf";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)saveAlarm{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    
    UILocalNotification *notificationToCancel=nil;
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([aNotif.fireDate isEqualToDate:existingAlarmDate]) {
            notificationToCancel=aNotif;
            NSLog(@"notificationToCancel : %@", notificationToCancel.fireDate);
            break;
        }
    }
    if (notificationToCancel) {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }

    [self scheduledNotificationWithDate:dateTimePicker.date];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.alarmTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictionary objectForKey:@"Title"];
    
    return cell;
}



#pragma mark - IBActions

-(IBAction)alarmSetButtonTapped:(id)sender
{
    [self saveAlarm];
}

-(IBAction)alarmCancelButtonTapped:(id)sender
{

    UILocalNotification *notificationToCancel=nil;
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([aNotif.fireDate isEqualToDate:existingAlarmDate]) {
            notificationToCancel=aNotif;
            NSLog(@"notificationToCancel : %@", notificationToCancel.fireDate);
            break;
        }
    }
    if (notificationToCancel) {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Alarm clock";
    
    if (existingAlarmDate) {
        dateTimePicker.date = existingAlarmDate;
    }
    else {
        dateTimePicker.date = [NSDate date];
    }

    NSArray *tempArray = [[NSArray alloc] init];
    self.tableDataSource = tempArray;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.tableDataSource = [appDelegate.alarmClockData objectForKey:@"Rows"];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarm:)];
    
}


-(void)saveAlarm:(id)sender{
    [self saveAlarm];
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
