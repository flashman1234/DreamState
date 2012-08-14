//
//  Alarm.h
//  DreamState
//
//  Created by Michal Thompson on 8/10/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSSet *day;
@end

@interface Alarm (CoreDataGeneratedAccessors)

- (void)addDayObject:(Day *)value;
- (void)removeDayObject:(Day *)value;
- (void)addDay:(NSSet *)values;
- (void)removeDay:(NSSet *)values;

@end
