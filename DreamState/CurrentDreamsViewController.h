//
//  CurrentDreamsViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentDreamsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView  *dreamTableView;
}

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)moc;

@property (nonatomic, retain) UITableView *dreamTableView;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSMutableArray *dreamArray;
@property (nonatomic, retain) NSIndexPath *selectedCellIndexPath;

@end
