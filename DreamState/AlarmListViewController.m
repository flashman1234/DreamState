//
//  AlarmListViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/31/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmListViewController.h"
#import "AlarmViewController.h"
#import "Alarm.h"
#import "Day.h"

#import "NotificationLoader.h"

#import "Alarmhelper.h"

#define TAG_OFFSET 100

@interface AlarmListViewController ()

@end

@implementation AlarmListViewController

@synthesize noAlarmsLabel;

//@synthesize notificationsArray;
@synthesize tableView;
@synthesize alarmArray;

@synthesize managedObjectContext;

@synthesize enabledSwitch;


- (void)addAlarmButtonTapped:(id)sender {

    AlarmViewController *alarmViewControllerControllerTemp = [[AlarmViewController alloc] init];
    alarmViewControllerControllerTemp.managedObjectContext = [self managedObjectContext];
              
    [self.navigationController pushViewController:alarmViewControllerControllerTemp animated:YES]; 
}


#pragma mark - Table view 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmViewController *selectedAlarmViewController = [[AlarmViewController alloc] init];
    selectedAlarmViewController.managedObjectContext = [self managedObjectContext];
    
    Alarm *existingAlarm = [self.alarmArray objectAtIndex:indexPath.row];
    selectedAlarmViewController.existingAlarm = existingAlarm;
    
    [self.navigationController pushViewController:selectedAlarmViewController animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.alarmArray count] == 0) {
        noAlarmsLabel.frame = CGRectMake(115, 150, 100, 30);
        [self.view addSubview:noAlarmsLabel];
    }
    else {
        [noAlarmsLabel removeFromSuperview];
    }
    return [self.alarmArray count];
}


- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    CGRect labelTimeFrame = CGRectMake(10, 10, 290, 25);
    CGRect labelNameFrame = CGRectMake(10, 33, 290, 25);
    CGRect labelDaysFrame = CGRectMake(10, 56, 290, 25);
    UILabel *lblTemp;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CellFrame];
    
    //Initialize Label with tag 1.
    lblTemp = [[UILabel alloc] initWithFrame:labelTimeFrame];
    lblTemp.tag = 1;
    [cell.contentView addSubview:lblTemp];
    
    //Initialize Label with tag 2.
    lblTemp = [[UILabel alloc] initWithFrame:labelNameFrame];
    lblTemp.tag = 2;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];
    
    //Initialize Label with tag 3.
    lblTemp = [[UILabel alloc] initWithFrame:labelDaysFrame];
    lblTemp.tag = 3;
    [cell.contentView addSubview:lblTemp];
    
    return cell;
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = [self getCellContentView:CellIdentifier];
    }
    
    UILabel *lblTime = (UILabel *)[cell viewWithTag:1];
    UILabel *lblName = (UILabel *)[cell viewWithTag:2];
    UILabel *lblDays = (UILabel *)[cell viewWithTag:3];
    
    
    Alarm *alarm = [self.alarmArray objectAtIndex:indexPath.row];
    
    NSArray *existingDays = [alarm.day allObjects];
    NSMutableArray *existingDayNames = [[NSMutableArray alloc] init];
       
    for (Day *day in existingDays) {
        [existingDayNames addObject:day.day];
    }

    Alarmhelper *helper = [[Alarmhelper alloc] init];  
    lblDays.text = [helper tidyDaysFromArray:existingDayNames];
    lblTime.text = alarm.time;
    lblName.text = alarm.name;

    enabledSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];

    enabledSwitch.on = [alarm.enabled boolValue];
    
    enabledSwitch.tag = TAG_OFFSET + indexPath.row;
    [enabledSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = enabledSwitch;
    
    [cell.contentView addSubview: enabledSwitch];    
    
    return cell;
}


- (void)updateSwitchAtIndexPath:(id)sender {

    UISwitch* switchControl = sender;
    int x = switchControl.tag;

    Alarm *alarm = [self.alarmArray objectAtIndex:x - TAG_OFFSET];
   
    [alarm setValue:[NSNumber numberWithBool:switchControl.on] forKey:@"enabled"];
     
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    
    //update notifications
    NotificationLoader *notificationLoader = [[NotificationLoader alloc] init];
    notificationLoader.managedObjectContext = [self managedObjectContext];
    [notificationLoader loadNotifications];
    
}


#pragma mark - View methods

- (void)viewWillAppear:(BOOL)animated {
    
    [self loadAlarmArray];
    [self.tableView reloadData];
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadAlarmArray
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Alarm" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    self.alarmArray = fetchedObjects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Alarms";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                              target:self action:@selector(addAlarmButtonTapped:)];
    
    [self loadAlarmArray];

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
