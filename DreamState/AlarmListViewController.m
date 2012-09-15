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

@implementation AlarmListViewController

@synthesize noAlarmsLabel;
@synthesize tableView;
@synthesize alarmArray;
@synthesize managedObjectContext;
@synthesize enabledSwitch;


#pragma mark - table editing

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        Alarm *existingAlarm = [self.alarmArray objectAtIndex:indexPath.row];
        
        if (existingAlarm) {
            
            [[self managedObjectContext] deleteObject:existingAlarm];
            NSError *saveError = nil;
            [managedObjectContext save:&saveError];
            if (saveError) {
                NSLog(@"Alarm List saveError : %@", saveError.localizedDescription);
            }
        }

        [self loadAlarmArray];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        
        [self updateNotifications];
    } 
}

- (void)addAlarmButtonTapped:(id)sender {
    AlarmViewController *alarmViewControllerControllerTemp = [[AlarmViewController alloc] init];
    alarmViewControllerControllerTemp.managedObjectContext = [self managedObjectContext];              
    [self.navigationController pushViewController:alarmViewControllerControllerTemp animated:YES]; 
}

- (void)loadAlarmArray{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Alarm" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    self.alarmArray = fetchedObjects;
}


#pragma mark - Table view 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmViewController *selectedAlarmViewController = [[AlarmViewController alloc] init];
    selectedAlarmViewController.managedObjectContext = [self managedObjectContext];
    
    Alarm *existingAlarm = [self.alarmArray objectAtIndex:indexPath.row];
    selectedAlarmViewController.existingAlarm = existingAlarm;
    
    //selectedAlarmViewController.hidesBottomBarWhenPushed = YES;
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
    
    if (existingDayNames.count > 0) {
        lblDays.text = [helper tidyDaysFromArray:existingDayNames];
    }
    else {
        lblDays.text = @"Everyday";
    }
    
    lblDays.backgroundColor = [UIColor clearColor];
    //lblDays.font = [UIFont boldSystemFontOfSize:12];
    [lblDays setFont:[UIFont fontWithName:@"Solari" size:12]];
    lblDays.textColor = [UIColor whiteColor];
    
    lblTime.text = alarm.time;
    
    lblTime.backgroundColor = [UIColor clearColor];
    //lblTime.font = [UIFont boldSystemFontOfSize:18];
    [lblTime setFont:[UIFont fontWithName:@"Solari" size:18]];
    lblTime.textColor = [UIColor whiteColor];
    
    lblName.text = alarm.name;
    
    lblName.backgroundColor = [UIColor clearColor];
    //lblName.font = [UIFont boldSystemFontOfSize:12];
    [lblName setFont:[UIFont fontWithName:@"Solari" size:12]];
    lblName.textColor = [UIColor whiteColor];

    enabledSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    enabledSwitch.on = [alarm.enabled boolValue];
    enabledSwitch.tag = TAG_OFFSET + indexPath.row;
    [enabledSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = enabledSwitch;
    cell.editingAccessoryView = enabledSwitch;
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
    
    [self updateNotifications];
}

-(void)updateNotifications{
    NotificationLoader *notificationLoader = [[NotificationLoader alloc] init];
    notificationLoader.managedObjectContext = [self managedObjectContext];
    [notificationLoader loadNotifications];
}


#pragma mark - View methods

- (void)viewWillAppear:(BOOL)animated {
    
    [self loadAlarmArray];
    [self.tableView reloadData];
   
}


- (void)dealloc {
   
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Alarms";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                              target:self action:@selector(addAlarmButtonTapped:)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    
    [self loadAlarmArray];
    tableView.backgroundColor = [UIColor blackColor];
    
    [tableView setEditing:YES];
    tableView.allowsSelectionDuringEditing = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self updateNotifications];
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
