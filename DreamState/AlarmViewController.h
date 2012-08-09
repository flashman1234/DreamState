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
    
//    NSArray *tableDataSource;
//    NSDate *existingAlarmDate;
//    
//    NSString *alarmSound;
//    NSString *alarmName;
//
//    
//    UILabel* nameLabel;
//    UILabel* valueLabel;
    
}

-(void) scheduledNotificationWithDate:(NSDate *) fireDate;
-(IBAction)alarmSetButtonTapped:(id)sender;
-(IBAction)alarmCancelButtonTapped:(id)sender;

@property (nonatomic, retain) UITableView *alarmTableView;
@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSDate *existingAlarmDate;

@property (nonatomic, retain) NSString *alarmSound;
@property (nonatomic, retain) NSString *alarmName;
@property (nonatomic, retain) NSArray *alarmRepeatDays;

@property (nonatomic, retain) NSString *tidyDay;


@property (nonatomic, retain)  UILabel* nameLabel;
@property (nonatomic, retain)  UILabel* valueLabel;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
