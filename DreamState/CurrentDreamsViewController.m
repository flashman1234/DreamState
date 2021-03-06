//
//  CurrentDreamsViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "CurrentDreamsViewController.h"
#import "SelectedDreamViewController.h"
#import "Dream.h"
#import "AppDelegate.h"

@implementation CurrentDreamsViewController

@synthesize dreamTableView;
@synthesize dreamArray;
@synthesize selectedCellIndexPath;
@synthesize managedObjectContext;


#pragma mark - table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dreamArray count]; 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    else {
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:1];
        if ([name superview]) {
            [name removeFromSuperview];
        }
        
        UILabel *time = (UILabel *)[cell.contentView viewWithTag:2];
        if ([time superview]) {
            [time removeFromSuperview];
        }

    }
    
    Dream *dream = [self.dreamArray objectAtIndex:indexPath.row];
    
    UILabel *dreamLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 290, 25)];
    dreamLabel.tag = 1;        
    [dreamLabel setFont:[UIFont fontWithName:@"Solari" size:20]];
    dreamLabel.textColor = [UIColor whiteColor];
    dreamLabel.backgroundColor = [UIColor clearColor];
    dreamLabel.text = dream.name;
    [cell.contentView addSubview:dreamLabel];
    
    
    
    UILabel *dreamTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 290, 25)];
    dreamTimeLabel.tag = 2;        
    [dreamTimeLabel setFont:[UIFont fontWithName:@"Solari" size:15]];
    dreamTimeLabel.textColor = [UIColor whiteColor];
    dreamTimeLabel.backgroundColor = [UIColor clearColor];
    dreamTimeLabel.text = dream.time;
    [cell.contentView addSubview:dreamTimeLabel];
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectedDreamViewController *selectedDreamViewController = [[SelectedDreamViewController alloc] init];
    selectedDreamViewController.managedObjectContext = [self managedObjectContext];
    
    Dream *existingDream = [self.dreamArray objectAtIndex:indexPath.row];
    selectedDreamViewController.existingDream = existingDream;

    [self.navigationController pushViewController:selectedDreamViewController animated:YES]; 
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{    Dream *dreamToDelete = [self.dreamArray objectAtIndex:indexPath.row];
    [self deleteDream:dreamToDelete];
    
    [self loadDreamArray];
    
    [self.dreamTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
    
}


-(void)deleteDream:(Dream *)dreamToDelete{
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath: [dreamToDelete fileUrl] error: &error];
    if (error) {
        NSLog(@"removeItemAtPath dream delete error : %@", error.localizedDescription);
    }
    
    [[self managedObjectContext] deleteObject:dreamToDelete];
    
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    if (saveError) {
        NSLog(@"deleteDream error : %@", saveError.localizedDescription);
    } 
}

- (void)loadDreamArray
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
   
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Dream" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    self.dreamArray = [fetchedObjects mutableCopy];
}

#pragma mark - View methods

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)moc{
    
    if (self = [super init])
    {
        self.managedObjectContext = moc;
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Archive"];
        UIImage *i = [UIImage imageNamed:@"play@1x.png"];
        [tbi setImage:i];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   if (managedObjectContext == nil) 
        { managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }    
    
    [self loadDreamArray];
    
    dreamTableView.backgroundColor = [UIColor blackColor];
    [dreamTableView setEditing:YES];
    dreamTableView.allowsSelectionDuringEditing = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)viewWillAppear:(BOOL)animated
{  
    [self loadDreamArray];
    
    [self.dreamTableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = (UITableViewCell *)[dreamTableView cellForRowAtIndexPath:myIP];
    [cell setHighlighted:YES animated:YES];
    [cell setHighlighted:NO animated:YES];
   
}




@end
