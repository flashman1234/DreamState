//
//  AlarmDaysViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/9/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmDaysViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *alarmDayTableView;
}

@property(nonatomic, retain) NSMutableArray *dayArray;
@property (nonatomic, retain) UITableView *alarmDayTableView;
@property (nonatomic, retain) NSMutableArray *selectedDayArray;

@end
