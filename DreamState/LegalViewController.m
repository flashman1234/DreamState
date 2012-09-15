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


@implementation LegalViewController
@synthesize legalTableView;
@synthesize inAppSettings;

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70.0;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
        if (indexPath.row == 0) {
            cell.textLabel.text = @"About";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Terms of Service";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Record Settings";
        }
        
    }
        
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        //go about
        [legalTableView deselectRowAtIndexPath:indexPath animated:YES];
        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutViewController animated:YES];
    }
    else if (indexPath.row == 1) {
        //go tos
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
    

        InAppSettingsViewController *inAppSettings2 = [[InAppSettingsViewController alloc] init];
        inAppSettings = inAppSettings2;
        inAppSettings.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
        [self.view addSubview:inAppSettings.view];

}

- (id)init {
    
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"Information"];
    UIImage *i = [UIImage imageNamed:@"information.png"];
    [tbi setImage:i];
    
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
