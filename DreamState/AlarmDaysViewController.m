//
//  AlarmDaysViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/9/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmDaysViewController.h"
#import "AlarmViewController.h"

@interface AlarmDaysViewController ()

@end

@implementation AlarmDaysViewController

@synthesize dayArray;
@synthesize alarmDayTableView;
@synthesize selectedDayArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)saveAlarmDays:(id)sender{

    AlarmViewController *parentViewController = (AlarmViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    parentViewController.alarmRepeatDays = selectedDayArray;
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Repeat";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarmDays:)];

    NSMutableArray *dayArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *selectedDayArrayTemp = [[NSMutableArray alloc] init];
   
    if (!selectedDayArray) {
        selectedDayArray = selectedDayArrayTemp;
    }
    
    
    UITableView *temp =  [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];

    self.alarmDayTableView =   temp; 
    
    dayArray = dayArrayTemp;
    
    [dayArray addObject:@"Monday"];
    [dayArray addObject:@"Tuesday"];
    [dayArray addObject:@"Wednesday"];
    [dayArray addObject:@"Thursday"];
    [dayArray addObject:@"Friday"];
    [dayArray addObject:@"Saturday"];
    [dayArray addObject:@"Sunday"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dayArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.alarmDayTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.dayArray objectAtIndex:indexPath.row];
    
    for (NSString *day in selectedDayArray) 
    {
        if ([day isEqualToString:[self.dayArray objectAtIndex:indexPath.row]]) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];

    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedDayArray addObject:thisCell.textLabel.text];
        
    }else{
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        
        [selectedDayArray removeObject:thisCell.textLabel.text];
    }

}

@end
