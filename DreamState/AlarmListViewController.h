//
//  AlarmListViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/31/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmViewController.h"

@interface AlarmListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView *tableView;
}

@property(nonatomic, retain)IBOutlet UILabel *noAlarmsLabel;

//@property (nonatomic, retain) NSArray *notificationsArray;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, retain) NSArray *alarmArray;

@property (nonatomic, retain) UISwitch *enabledSwitch;

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;

@end
