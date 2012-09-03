//
//  AlarmSoundViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/24/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmSoundViewController.h"
#import "AlarmViewController.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@implementation AlarmSoundViewController

@synthesize alarmSoundTableView;
@synthesize soundArray;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.soundArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.alarmSoundTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *dreamLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 290, 25)];
    dreamLabel.tag = 1;        
    dreamLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:20.0];
    dreamLabel.textColor = [UIColor whiteColor];
    dreamLabel.backgroundColor = [UIColor clearColor];
    dreamLabel.text = [self.soundArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:dreamLabel];
    
//    cell.textLabel.text = [self.soundArray objectAtIndex:indexPath.row];
//    cell.textLabel.textColor = [UIColor greenColor];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor blackColor];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmViewController *parentViewController = (AlarmViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    parentViewController.alarmSound = [self.soundArray objectAtIndex:indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    alarmSoundTableView.backgroundColor = RGBA(0,0,0,5);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)viewWillAppear:(BOOL)animated
{  
    //[self.alarmSoundTableView reloadData];
}

@end
