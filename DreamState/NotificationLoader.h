//
//  NotificationLoader.h
//  DreamState
//
//  Created by Michal Thompson on 8/9/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

@interface NotificationLoader : NSObject

-(void)loadNotifications;
-(void)createNotificationForAlarm:(Alarm *)alarm;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *alarms;
@property (nonatomic, strong) NSArray *notificationArray;
@property int numberOfAlarms;

@end
