//
//  AlarmDaysViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/9/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmDaysViewController.h"
#import "AlarmViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlarmDaysViewController

@synthesize dayArray;
@synthesize alarmDayTableView;
@synthesize selectedDayArray;

-(void)saveAlarmDays:(id)sender{

    AlarmViewController *parentViewController = (AlarmViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    parentViewController.alarmRepeatDays = selectedDayArray;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelAlarmDays:(id)sender{

    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Days";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarmDays:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                             target:self action:@selector(cancelAlarmDays:)];

    NSMutableArray *dayArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *selectedDayArrayTemp = [[NSMutableArray alloc] init];
   
    if (!selectedDayArray) {
        selectedDayArray = selectedDayArrayTemp;
    }
    
    
    alarmDayTableView.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    dayArray = dayArrayTemp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dayArray = [[dateFormatter weekdaySymbols] mutableCopy]; 
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"Solari" size:24]];
    
    for (NSString *day in selectedDayArray) 
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *stringFromDay = [[df weekdaySymbols] objectAtIndex:[day intValue]];
       
        //if ([day isEqualToString:[self.dayArray objectAtIndex:indexPath.row]]) {
        if ([stringFromDay isEqualToString:[self.dayArray objectAtIndex:indexPath.row]]) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
           
            break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];

    NSString *dayAsString = thisCell.textLabel.text;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *stringFromDay = [NSString stringWithFormat:@"%d", [[df weekdaySymbols] indexOfObject:dayAsString]];
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        //[selectedDayArray addObject:thisCell.textLabel.text];
        [selectedDayArray addObject:stringFromDay];
        
    }else{
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        
        //[selectedDayArray removeObject:thisCell.textLabel.text];
        [selectedDayArray removeObject:stringFromDay];
    }
}

@end
