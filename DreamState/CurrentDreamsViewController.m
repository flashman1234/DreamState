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


#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation CurrentDreamsViewController

@synthesize dreamTableView;
@synthesize dreamArray;
@synthesize selectedCellIndexPath;
@synthesize managedObjectContext;


#pragma mark - table view methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
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

    }
    
    Dream *dream = [self.dreamArray objectAtIndex:indexPath.row];
    
    UILabel *dreamLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 290, 25)];
    dreamLabel.tag = 1;        
    dreamLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:20.0];
    dreamLabel.textColor = [UIColor whiteColor];
    dreamLabel.backgroundColor = [UIColor clearColor];
    dreamLabel.text = dream.name;
    [cell.contentView addSubview:dreamLabel];
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectedDreamViewController *selectedDreamViewController = [[SelectedDreamViewController alloc] init];
    selectedDreamViewController.managedObjectContext = [self managedObjectContext];
    
    Dream *existingDream = [self.dreamArray objectAtIndex:indexPath.row];
    selectedDreamViewController.existingDream = existingDream;
    
    selectedDreamViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectedDreamViewController animated:YES]; 
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
        [tbi setTitle:@"Play"];
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
    
    dreamTableView.backgroundColor = RGBA(0,0,0,5);
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

@end
