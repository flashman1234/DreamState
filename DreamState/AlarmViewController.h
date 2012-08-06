//
//  AlarmViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
    IBOutlet UIDatePicker *dateTimePicker;
    IBOutlet UITableView *alarmTableView;
    
    NSArray *tableDataSource;
    NSDate *existingAlarmDate;
}

//-(void) presentMessage:(NSString *)message;
-(void) scheduledNotificationWithDate:(NSDate *) fireDate;
-(IBAction)alarmSetButtonTapped:(id)sender;
-(IBAction)alarmCancelButtonTapped:(id)sender;

@property (nonatomic, retain) UITableView *alarmTableView;
@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSDate *existingAlarmDate;

@end
