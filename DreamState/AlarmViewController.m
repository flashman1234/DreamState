//
//  AlarmViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmViewController.h"
#import "AppDelegate.h"

#import "AlarmSoundViewController.h"
#import "AlarmLabelViewController.h"
#import "AlarmDaysViewController.h"

#import "Alarm.h"
#import "Day.h"

@implementation AlarmViewController
@synthesize alarmTableView;
@synthesize tableDataSource;
@synthesize existingAlarmDate;

@synthesize alarmSound;
@synthesize alarmName;
@synthesize alarmRepeatDays;
@synthesize tidyDay;

@synthesize nameLabel;
@synthesize valueLabel;

@synthesize managedObjectContext;



-(void)scheduledNotificationWithDate:(NSDate *)fireDate {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = fireDate;
    notification.alertBody = @"Would you like to record a dream?";
    NSDictionary *userInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:alarmName, @"AlarmName", alarmSound, @"AlarmSound", nil];
    
    notification.userInfo = userInfoDict;

    existingAlarmDate = nil;
    
    notification.soundName = [self.alarmSound stringByAppendingString:@".caf"];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)saveAlarm:(id)sender{
    [self saveAlarm];
}

-(void)saveAlarm{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    
    //if there is a current notification, then remove it before adding new one.
    UILocalNotification *notificationToCancel=nil;
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([aNotif.fireDate isEqualToDate:existingAlarmDate]) {
            notificationToCancel=aNotif;
            break;
        }
    }
    if (notificationToCancel) {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }

    [self scheduledNotificationWithDate:dateTimePicker.date];
    [self storeAlarmInStore:dateTimePicker.date];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)storeAlarmInStore:(NSDate *)fireDate{
    NSManagedObjectContext *context = [self managedObjectContext];
    

    Alarm *alarm = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Alarm"
                    inManagedObjectContext:context];
    
    [alarm setValue:alarmName forKey:@"name"];
    [alarm setValue:alarmSound forKey:@"sound"];
    
    
    for (NSString *myArrayElement in alarmRepeatDays) {
        
        Day *day = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Day"
                                    inManagedObjectContext:context];
        
        [day setValue:myArrayElement forKey:@"day"];
        
        [day setValue:alarm forKey:@"alarm"];
    }
        
    
       NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}



#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //Get the dictionary of the selected data source.
        NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
        
        //Get the children of the present item.
        NSArray *Children = [dictionary objectForKey:@"Children"];
        
        if([Children count] != 0) {
          
            AlarmSoundViewController *alarmSoundViewController = [[AlarmSoundViewController alloc] init];
        
            [self.navigationController pushViewController:alarmSoundViewController animated:YES];
        
            alarmSoundViewController.tableDataSource = Children;
        }
        
    }

    if (indexPath.row == 1) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *vLabel = (UILabel *)[cell viewWithTag:2];

        AlarmLabelViewController *alarmLabelViewController = [[AlarmLabelViewController alloc] init];
        alarmLabelViewController.existingName = vLabel.text;
        
        [self.navigationController pushViewController:alarmLabelViewController animated:YES];
    }
    
    if (indexPath.row == 2) {
        
        AlarmDaysViewController *alarmDaysViewController = [[AlarmDaysViewController alloc] init];
        alarmDaysViewController.selectedDayArray = [alarmRepeatDays mutableCopy];
        
        [self.navigationController pushViewController:alarmDaysViewController animated:YES];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.tableDataSource count];
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.alarmTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 7.0, 0.0, 140.0, 44.0 )];
        
        nameLabel.font = [UIFont systemFontOfSize: 12.0];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        nameLabel.backgroundColor = [UIColor clearColor];
        //add tag to make label accessible when the view is reloaded.
        nameLabel.tag = 1;
        
        [cell.contentView addSubview: nameLabel];
        
        valueLabel = [[UILabel alloc] initWithFrame: CGRectMake( 165.0, 0.0,120, 44.0 )];
        
        valueLabel.font = [UIFont systemFontOfSize: 11];
        valueLabel.textAlignment = UITextAlignmentRight;
        valueLabel.textColor = [UIColor blueColor];
        valueLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        valueLabel.backgroundColor = [UIColor clearColor];
        //add tag to make label accessible when the view is reloaded.
        valueLabel.tag = 2;
        
        [cell.contentView addSubview: valueLabel];
    }
    
     NSDictionary *dictionary = [self.tableDataSource objectAtIndex:indexPath.row];
    
    if ([[dictionary objectForKey:@"Title"] isEqualToString:@"Sound"]) {
        
        UILabel *nLabel = (UILabel *)[cell viewWithTag:1];
        nLabel.text = @"Sound";
        
        UILabel *vLabel = (UILabel *)[cell viewWithTag:2];
        vLabel.text = self.alarmSound;
        

    }
    else if([[dictionary objectForKey:@"Title"] isEqualToString:@"Label"])
    {
        UILabel *nLabel = (UILabel *)[cell viewWithTag:1];
        nLabel.text = @"Label";

        UILabel *vLabel = (UILabel *)[cell viewWithTag:2];
        vLabel.text = self.alarmName;
    }
    
    else if([[dictionary objectForKey:@"Title"] isEqualToString:@"Repeat"])
    {
        UILabel *nLabel = (UILabel *)[cell viewWithTag:1];
        nLabel.text = @"Repeat";
        
        UILabel *vLabel = (UILabel *)[cell viewWithTag:2];
        vLabel.text = [self tidyDaysFromArray:self.alarmRepeatDays];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(NSString *)tidyDaysFromArray:(NSArray *)array{
    
    NSString *tidyDayTemp = [[NSString alloc]init];
    tidyDay = tidyDayTemp;
    
    for (NSString *myArrayElement in array) {
        NSString *shortDay = [myArrayElement substringToIndex:3];
        
        tidyDay = [tidyDay stringByAppendingString:shortDay];
        tidyDay = [tidyDay stringByAppendingString:@", "];

    }
    if ([tidyDay length] > 0) {
        tidyDay = [tidyDay substringToIndex:[tidyDay length] - 2];
        return tidyDay;
    }
    return @"";    
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
    
    if (!alarmSound) {
        self.alarmSound = @"alarm 1";
    }
    
    if (!alarmName) {
        self.alarmName = @"";
    }
    
    
    if (existingAlarmDate) {
        dateTimePicker.date = existingAlarmDate;
    }
    else {
        dateTimePicker.date = [NSDate date];
    }

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.tableDataSource = [appDelegate.alarmClockData objectForKey:@"Rows"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarm:)];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self.alarmTableView reloadData];
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
