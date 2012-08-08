//
//  AlarmSoundViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/7/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmSoundViewController.h"
#import "AlarmViewController.h"

@interface AlarmSoundViewController ()

@end

@implementation AlarmSoundViewController

@synthesize alarmSoundTableView;
@synthesize tableDataSource;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.alarmSoundTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.tableDataSource objectAtIndex:indexPath.row];
    
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmViewController *parentViewController = (AlarmViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    parentViewController.alarmSound = [self.tableDataSource objectAtIndex:indexPath.row];

    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
