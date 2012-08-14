//
//  Day.h
//  DreamState
//
//  Created by Michal Thompson on 8/8/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alarm;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) Alarm *alarm;

@end
