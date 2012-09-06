//
//  NotificationLoader.m
//  DreamState
//
//  Created by Michal Thompson on 8/9/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "NotificationLoader.h"
#import "Alarm.h"

@implementation NotificationLoader

@synthesize managedObjectContext;
@synthesize alarms;
@synthesize notificationArray;
@synthesize numberOfAlarms;

-(void)loadNotifications{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Alarm" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.alarms = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
       
    //delete any existing notifications for this alarm
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    numberOfAlarms = self.alarms.count;
    
    //now loop through Alarm, and set the notifications for each particular day.
    for (Alarm *alarm in self.alarms) {
        if ([alarm.enabled boolValue]) {
            [self createNotificationForAlarm:alarm];
        }
    }
    
    self.notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
}

- (void)setNotification:(NSDate *)finalAlarmDate alarm:(Alarm *)alarm {
    //create notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = finalAlarmDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"]; 
    
    NSString *stringFromDate = [dateFormat stringFromDate:notification.fireDate];
    
    notification.alertBody = stringFromDate;// @"Would you like to record a dream?";
    
    NSDictionary *userInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:alarm.name, @"AlarmName", alarm.sound, @"AlarmSound", nil];
    
    notification.userInfo = userInfoDict;
    
    notification.soundName = [alarm.sound stringByAppendingString:@".caf"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)createNotificationForAlarm:(Alarm *)alarm{

    int totalNumberOfNotifications = 10;
    int numberOfNotificationsPerAlarm = totalNumberOfNotifications / numberOfAlarms;
    
    //get date and convert to components
    NSDate *curentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:curentDate]; // 
    
    //cut out hours and minutes from the alarm time
    NSInteger alarmHour = [[alarm.time substringToIndex:2] integerValue];
    NSInteger alarmMinutes = [[alarm.time substringFromIndex:3] integerValue];
    
    [compoNents setHour:alarmHour];
    [compoNents setMinute:alarmMinutes];
    
    //create alarm date
    NSDate *alarmDate = [[NSCalendar currentCalendar] dateFromComponents:compoNents];
    
    
    //no days were set, so this alarm will run everyday
    if (alarm.day.count == 0) {
        
        for (int i = 0; i <= numberOfNotificationsPerAlarm;i ++) {
            
            //increase day by increment
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = i;

            NSDate *finalAlarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:alarmDate options:0];

            //if (finalAlarmDate > curentDate) {
            if ([finalAlarmDate compare:curentDate] == NSOrderedDescending) {
                [self setNotification:finalAlarmDate alarm:alarm];
            }
        }
    }
    else {
        
        int dayOffest = 0;
        int numberOfSetNotifications = 0;
        
        do {
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = dayOffest;
            
            NSDate *finalAlarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:alarmDate options:0];
            
            NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
            [weekday setDateFormat: @"EEEE"];

            NSString *possibleAlarmDay = [weekday stringFromDate:finalAlarmDate];
            
            NSSet *days = [alarm.day valueForKey: @"day"];
           
            bool dayIsFound = NO;
            
            dayIsFound = [days containsObject:possibleAlarmDay];
            
            if (dayIsFound) {
                if ([finalAlarmDate compare:curentDate] == NSOrderedDescending) {
                    [self setNotification:finalAlarmDate alarm:alarm];
                    numberOfSetNotifications = numberOfSetNotifications + 1;
                }
            }
            
            dayOffest = dayOffest + 1;

        } while (numberOfSetNotifications < numberOfNotificationsPerAlarm);
        
    }
    
}


@end
