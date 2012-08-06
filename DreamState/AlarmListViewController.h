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
    NSArray *notificationsArray;
    IBOutlet UITableView *tableView;
    
}

@property (nonatomic, retain) AlarmViewController *tdController;

@property (nonatomic, retain) NSArray *notificationsArray;

@property (nonatomic, retain) UITableView *tableView;

@end
