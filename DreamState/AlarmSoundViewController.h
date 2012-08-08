//
//  AlarmSoundViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/7/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmSoundViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *alarmSoundTableView;
    NSArray *tableDataSource;
}

@property (nonatomic, retain) UITableView *alarmSoundTableView;
@property (nonatomic, retain) NSArray *tableDataSource;

@end
