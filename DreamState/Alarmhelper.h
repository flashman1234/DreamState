//
//  Alarmhelper.h
//  DreamState
//
//  Created by Michal Thompson on 8/13/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarmhelper : NSObject

-(NSString *)tidyDaysFromArray:(NSArray *)array;

- (NSComparisonResult)weekdayCompare:(NSString*)otherDay;
@property (nonatomic, retain) NSArray *weekDays;

@end
