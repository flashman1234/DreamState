//
//  AlarmListViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/31/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmListViewController.h"
#import "AlarmViewController.h"

@interface AlarmListViewController ()

@end

@implementation AlarmListViewController
@synthesize tdController;
@synthesize notificationsArray;
@synthesize tableView;

- (void)addAlarmButtonTapped:(id)sender {

    AlarmViewController *alarmViewControllerControllerTemp = [[AlarmViewController alloc] init];
    
    self.tdController = alarmViewControllerControllerTemp;
              
    [self.navigationController pushViewController:self.tdController animated:YES]; 
}


#pragma mark - Table view 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AlarmViewController *selectedAlarmViewController = [[AlarmViewController alloc] init];
    
    UILocalNotification *notifcation = [self.notificationsArray objectAtIndex:indexPath.row];
    
    
    selectedAlarmViewController.existingAlarmDate = notifcation.fireDate;
    [self.navigationController pushViewController:selectedAlarmViewController animated:YES];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notificationsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    UILocalNotification *notifcation = [self.notificationsArray objectAtIndex:indexPath.row];
      
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    [[cell textLabel] setText:[dateFormatter stringFromDate:notifcation.fireDate]];
    
    return cell;
}


#pragma mark - View methods

- (void)viewWillAppear:(BOOL)animated {
    self.notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Alarms";
    
    self.notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                              target:self action:@selector(addAlarmButtonTapped:)];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return NO;
}

@end
