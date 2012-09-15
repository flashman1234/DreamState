//
//  Alarmhelper.m
//  DreamState
//
//  Created by Michal Thompson on 8/13/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "Alarmhelper.h"

@implementation Alarmhelper

@synthesize weekDays;
@synthesize managedObjectContext;

-(NSString *)tidyDaysFromArray:(NSArray *)array{
    
    array = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {

            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            int dayNumber = [obj1 intValue];   
            NSString *s1 = [[df weekdaySymbols] objectAtIndex:(dayNumber)];
            
            dayNumber = [obj2 intValue];
            NSString *s2 = [[df weekdaySymbols] objectAtIndex:(dayNumber)];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            NSArray *weekDays2 = [dateFormatter weekdaySymbols]; 
            
            NSUInteger selfIndex = [weekDays2 indexOfObject:s1];
            NSUInteger otherDayIndex = [weekDays2 indexOfObject:s2];
            
            if (selfIndex < otherDayIndex) {
                return NSOrderedAscending;
            }
            else if (selfIndex > otherDayIndex) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }

        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSString *tidyDay = [[NSString alloc]init];
   
    for (NSString *myArrayElement in array) {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        NSString *stringFromDay = [[df weekdaySymbols] objectAtIndex:[myArrayElement intValue]];
        
        NSString *shortDay = [stringFromDay substringToIndex:3];
        
        tidyDay = [tidyDay stringByAppendingString:shortDay];
        tidyDay = [tidyDay stringByAppendingString:@","];
        
    }
    if ([tidyDay length] > 0) {
        tidyDay = [tidyDay substringToIndex:[tidyDay length] - 1];
        return tidyDay;
    }
    return @"";    
}

@end
