//
//  LegalViewController.m
//  DreamState
//
//  Created by Michal Thompson on 9/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "LegalViewController.h"
#import "TOCViewController.h"
#import "AboutViewController.h"
#import "InAppSettings.h"
#import "Settings.h"
#import "HowToViewController.h"

@implementation LegalViewController
@synthesize legalTableView;
@synthesize inAppSettings;
@synthesize enabledSwitch;
@synthesize managedObjectContext;


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70.0;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return  3;
    }
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Record Settings";
    else
        return @"Other stuff";
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, tableView.bounds.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.bounds.size.width - 10, 24)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    [label setFont:[UIFont fontWithName:@"Solari" size:20]];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
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
        cell.backgroundColor = [UIColor darkGrayColor];
        [cell.textLabel setFont:[UIFont fontWithName:@"Solari" size:14]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        if (indexPath.section == 0) {
            cell.textLabel.text = @"Auto Record";
            
            
            
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Settings" inManagedObjectContext:managedObjectContext];
            [fetchRequest setEntity:entity];
            NSError *error;

            NSArray *settings = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            Settings *set = [settings objectAtIndex:0];
            
            
            
            
            
            enabledSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            enabledSwitch.on = set.autoRecord.boolValue;
            //enabledSwitch.tag = TAG_OFFSET + indexPath.row;
            [enabledSwitch addTarget:self action:@selector(updateAutoRecord:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.accessoryView = enabledSwitch;
            cell.editingAccessoryView = enabledSwitch;
            [cell.contentView addSubview: enabledSwitch];  
        }
        else if (indexPath.section == 1) {

            if (indexPath.row == 0) {
                cell.textLabel.text = @"About";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Terms of Service";
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"Dream State help";
            }
            
        }
    }
    
    return cell;
}


-(void)updateAutoRecord:(id)sender{
    
//    UISwitch* switchControl = sender;
//    int x = switchControl.tag;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Settings" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *settings = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    Settings *set = [settings objectAtIndex:0];
    
    [set setValue:[NSNumber numberWithBool:enabledSwitch.on] forKey:@"autoRecord"];
    
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
       
        if (indexPath.row == 0) {
            //go about
            [legalTableView deselectRowAtIndexPath:indexPath animated:YES];
            AboutViewController *aboutViewController = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
        else if (indexPath.row == 1) {
            //go tos TOCViewController
            [legalTableView deselectRowAtIndexPath:indexPath animated:YES];
            TOCViewController *tOCViewController = [[TOCViewController alloc] init];
            [self.navigationController pushViewController:tOCViewController animated:YES];
        }
        else if (indexPath.row == 2) {
            //go tos TOCViewController
            [legalTableView deselectRowAtIndexPath:indexPath animated:YES];
            HowToViewController *howToViewController = [[HowToViewController alloc] init];
            [self.navigationController pushViewController:howToViewController animated:YES];
        }
        
        
    }
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SelectedDreamViewController *selectedDreamViewController = [[SelectedDreamViewController alloc] init];
//    selectedDreamViewController.managedObjectContext = [self managedObjectContext];
//    
//    Dream *existingDream = [self.dreamArray objectAtIndex:indexPath.row];
//    selectedDreamViewController.existingDream = existingDream;
//    
//    [self.navigationController pushViewController:selectedDreamViewController animated:YES]; 
}

-(void)loadInAppSettingsView{
    
//
//        InAppSettingsViewController *inAppSettings2 = [[InAppSettingsViewController alloc] init];
//        inAppSettings = inAppSettings2;
//        inAppSettings.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
//        [self.view addSubview:inAppSettings.view];

}

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)moc{
    
    if (self = [super init])
    {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Information"];
        UIImage *i = [UIImage imageNamed:@"information.png"];
        [tbi setImage:i];
        self.managedObjectContext = moc;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self loadInAppSettingsView];
    
    if(!self.title){
        self.title = NSLocalizedString(@"Settings", nil);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
