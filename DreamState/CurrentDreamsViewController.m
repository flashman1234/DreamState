//
//  CurrentDreamsViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "CurrentDreamsViewController.h"
#import "DreamTableViewcell.h"
#import "SelectedDreamViewController.h"

@interface CurrentDreamsViewController ()

@end

@implementation CurrentDreamsViewController

@synthesize dreamTableView;

-(NSArray *)listFileAtPath:(NSString *)path
{
    
    NSError* error = nil;
    NSMutableArray  *myArray = (NSMutableArray*)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    [myArray sortUsingSelector:@selector(compare:)];

    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];        
    NSArray* sortedArray = [myArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return sortedArray;
    
}

#pragma mark - table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableViewArray count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    
    
    
    NSString *fileName = [tableViewArray objectAtIndex:indexPath.row];
    NSString *fileNameDate = [fileName substringToIndex:[fileName length] - 4];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *date = [format dateFromString:fileNameDate];

    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"d MMM YYYY"];

    NSString *s = [f2 stringFromDate:date];    
       
    cell.textLabel.text = s;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelectedDreamViewController *selectedDreamViewController = [[SelectedDreamViewController alloc]
                                         initWithNibName:@"SelectedDreamViewController" bundle:nil];
    selectedDreamViewController.soundFile = [tableViewArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:selectedDreamViewController animated:YES];
    
}



#pragma mark - View methods

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
    self.title = @"Recorded Dreams";
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
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    tableViewArray = [self listFileAtPath:docsDir];
    
    [self.dreamTableView reloadData];
}

@end
