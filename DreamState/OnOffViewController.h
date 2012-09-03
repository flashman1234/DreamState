//
//  OnOffViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/28/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATSDragToReorderTableViewController.h"

@interface OnOffViewController : ATSDragToReorderTableViewController {
	
	NSMutableArray *arrayOfItems;
    IBOutlet UITableView *tView;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tView;

@end
