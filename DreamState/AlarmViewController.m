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
    
    
//    if(indexPath.row == 0)
//    {
//        cell.textLabel.text = @"1111";
//    }
//    
//    switch (indexPath.row) {
//        case 0:
//            cell.textLabel.text = @"Repeat";
//            break;
//        case 1:
//            cell.textLabel.text = @"Sound";
//            break;
//        case 2:
//            cell.textLabel.text = @"Snooze";
//            break;
//        case 3:
//            cell.textLabel.text = @"Label";
//            break;
//        default:
//            break;
//    }
    
    return cell;
}






-(void)scheduledNotificationWithDate:(NSDate *)fireDate {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = fireDate;
    notification.alertBody = @"Would you like to record a dream?";
       
    existingAlarmDate = nil;
    
    notification.soundName = @"alarm-clock-1.caf";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)presentMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dream alarm clock" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}


-(IBAction)alarmSetButtonTapped:(id)sender
{
    [self saveAlarm];
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
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    
//    [self presentMessage:@"Dream alarm cancelled"];
}


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
    // Release any retained subviews of the main view.
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
