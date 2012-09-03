//
//  OnOffViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/28/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "OnOffViewController.h"


@implementation OnOffViewController

@synthesize tView;

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

    /*
     Populate array.
	 */
	if (arrayOfItems == nil) {
		
		NSUInteger numberOfItems = 2;
		
		arrayOfItems = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
		
		for (NSUInteger i = 0; i < numberOfItems; ++i)
			[arrayOfItems addObject:[NSString stringWithFormat:@"Item #%i", i + 1]];
	}
    tView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    tView.separatorColor = [UIColor clearColor];
    [tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView flashScrollIndicators];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        //cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
        
        UILabel *onLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];
        onLabel.text = @"ON";
        onLabel.textColor = [UIColor redColor];
        [cell.contentView addSubview:onLabel];
    }
	if (indexPath.row == 1) {
        //cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
        
        UILabel *onLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];
        onLabel.text = @"OFF";
        onLabel.textColor = [UIColor redColor];
        [cell.contentView addSubview:onLabel];
    }
	cell.contentView.backgroundColor = [UIColor clearColor];
    
    
    return cell;
}

// should be identical to cell returned in -tableView:cellForRowAtIndexPath:
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(ATSDragToReorderTableViewController *)dragTableViewController {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
    
    
	
	return cell;
}

/*
 Required for drag tableview controller
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	NSString *itemToMove = [arrayOfItems objectAtIndex:fromIndexPath.row];
	[arrayOfItems removeObjectAtIndex:fromIndexPath.row];
	[arrayOfItems insertObject:itemToMove atIndex:toIndexPath.row];
    
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

    /*
     Disable reordering if there's one or zero items.
     For this example, of course, this will always be YES.
	 */
	[self setReorderingEnabled:( arrayOfItems.count > 1 )];
	
	return arrayOfItems.count;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
