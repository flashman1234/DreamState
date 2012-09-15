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
#import "HomeViewController.h"
#import "Alarm.h"
#import "Day.h"
#import "NotificationLoader.h"
#import "Alarmhelper.h"

@implementation AlarmViewController

@synthesize alarmTableView;
@synthesize tableDataSource;
@synthesize existingAlarm;
@synthesize alarmSound;
@synthesize alarmName;
@synthesize alarmRepeatDays;
@synthesize tidyDay;
@synthesize nameLabel;
@synthesize valueLabel;
@synthesize managedObjectContext;
@synthesize existingDayNames;


#pragma mark - picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component)
    {
        case 0: return 24;
        case 1: return 60;
        default: return -1;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 50.0, 50.0)];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Solari" size:30]];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 1.0;
    if (row < 10) {
        [label setText:[NSString stringWithFormat:@"0%d",row]];
    }
    else {
        [label setText:[NSString stringWithFormat:@"%d",row]];
    }
    
    return label;
}


#pragma mark - alarm store
-(void)cancelAlarm:(id)sender{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)saveAlarm:(id)sender{

    NSDateComponents* compoNents = [[NSDateComponents alloc] init];    
    compoNents.hour = [timePicker selectedRowInComponent:0];
    compoNents.minute = [timePicker selectedRowInComponent:1];
    NSDate *pickerDate = [[NSCalendar currentCalendar] dateFromComponents:compoNents];
    
    [self storeAlarmInStore:pickerDate];
    
    NotificationLoader *notificationLoader = [[NotificationLoader alloc] init];
    notificationLoader.managedObjectContext = [self managedObjectContext];
    [notificationLoader loadNotifications];
    
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)storeAlarmInStore:(NSDate *)fireDate{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Alarm *alarm;
    
    if (existingAlarm) {
        alarm = existingAlarm;
    }
    else {
        alarm = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Alarm"
                 inManagedObjectContext:context];

    }
   
    [alarm setValue:alarmName forKey:@"name"];
    [alarm setValue:alarmSound forKey:@"sound"];
    [alarm setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *timeString = [outputFormatter stringFromDate:fireDate];
    
    [alarm setValue:timeString forKey:@"time"];
    
    for (NSManagedObject *aDay in alarm.day) {
        [context deleteObject:aDay];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    
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
            alarmSoundViewController.soundArray = Children;
            alarmSoundViewController.existingSound = self.alarmSound;
            [self.navigationController pushViewController:alarmSoundViewController animated:YES];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.alarmTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor blackColor];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 7.0, 0.0, 100.0, 44.0 )];
        
        [nameLabel setFont:[UIFont fontWithName:@"Solari" size:14]];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        nameLabel.backgroundColor = [UIColor clearColor];
        //add tag to make label accessible when the view is reloaded.
        nameLabel.tag = 1;
        
        [cell.contentView addSubview: nameLabel];
        
        valueLabel = [[UILabel alloc] initWithFrame: CGRectMake( 105.0, 0.0,180, 44.0 )];
        [valueLabel setFont:[UIFont fontWithName:@"Solari" size:14]];
        valueLabel.textAlignment = UITextAlignmentRight;
        valueLabel.textColor = [UIColor whiteColor];
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
        nLabel.text = @"Days";
        
        UILabel *vLabel = (UILabel *)[cell viewWithTag:2];
        Alarmhelper *helper = [[Alarmhelper alloc] init];
        vLabel.text = [helper tidyDaysFromArray:self.alarmRepeatDays];
    }
    
    UIImage *newDreamButton = [UIImage imageNamed: @"AccDisclosure.png"];
    UIImageView *newDreamButtonView = [[UIImageView alloc] initWithImage:newDreamButton];
    newDreamButtonView.frame = CGRectMake(280, 5, 30, 30);
    [cell insertSubview:newDreamButtonView atIndex:100];

    
    return cell;
}



#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Alarm clock";
    
    if (existingAlarm) {
        
        self.alarmSound = existingAlarm.sound;
        self.alarmName = existingAlarm.name;
        
        NSArray *existingDays = [existingAlarm.day allObjects];
        NSMutableArray *existingDayNamesTemp = [[NSMutableArray alloc] init];
        existingDayNames = existingDayNamesTemp;
        
        for (Day *day in existingDays) {
            [existingDayNames addObject:day.day];
        }
        
        self.alarmRepeatDays = existingDayNames;
 
    }
    else {
        self.alarmSound = @"alarm 1";
        self.alarmName = @"Alarm";
    }

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.tableDataSource = [appDelegate.alarmClockData objectForKey:@"Rows"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarm:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                              target:self action:@selector(cancelAlarm:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    alarmTableView.backgroundColor = [UIColor clearColor];
    alarmTableView.opaque = NO;
    alarmTableView.backgroundView = nil;
    
    NSDate *dateNow = [NSDate date];
    
    if (existingAlarm) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        dateNow = [dateFormat dateFromString:existingAlarm.time]; 
    }
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:dateNow]; // 
    
    //cut out hours and minutes from the alarm time
    NSInteger currentHour = compoNents.hour;
    NSInteger currentMinutes = compoNents.minute;
    
    [timePicker selectRow:currentHour inComponent:0 animated:YES];
    [timePicker selectRow:currentMinutes inComponent:1 animated:YES];
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
