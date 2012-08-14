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


-(void)cancelAlarm:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAlarm:(id)sender{
    [self storeAlarmInStore:dateTimePicker.date];
    
    NotificationLoader *notificationLoader = [[NotificationLoader alloc] init];
    notificationLoader.managedObjectContext = [self managedObjectContext];
    [notificationLoader loadNotifications];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *timeString = [outputFormatter stringFromDate:dateTimePicker.date];
    
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

//-(NSString *)tidyDaysFromArray:(NSArray *)array{
//
//    NSString *tidyDayTemp = [[NSString alloc]init];
//    tidyDay = tidyDayTemp;
//    
//    for (NSString *myArrayElement in array) {
//        NSString *shortDay = [myArrayElement substringToIndex:3];
//        
//        tidyDay = [tidyDay stringByAppendingString:shortDay];
//        tidyDay = [tidyDay stringByAppendingString:@", "];
//        
//    }
//    if ([tidyDay length] > 0) {
//        tidyDay = [tidyDay substringToIndex:[tidyDay length] - 2];
//        return tidyDay;
//    }
//    return @"";    
//}




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
        //vLabel.text = [self tidyDaysFromArray:self.alarmRepeatDays];
        Alarmhelper *helper = [[Alarmhelper alloc] init];
        
        vLabel.text = [helper tidyDaysFromArray:self.alarmRepeatDays];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}





#pragma mark - IBActions

-(IBAction)alarmCancelButtonTapped:(id)sender
{
    if (existingAlarm) {
        
        //DELETE THE DAYS ASSOCIATED WITH IT AS WELL - CASCADE IN MODEL?
        
        [[self managedObjectContext] deleteObject:existingAlarm];
        
        NSError *saveError = nil;
        [managedObjectContext save:&saveError];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Alarm clock";
    
    if (existingAlarm) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSDate *date = [dateFormat dateFromString:existingAlarm.time];  
        
        dateTimePicker.date = date;
        
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
        dateTimePicker.date = [NSDate date];
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
