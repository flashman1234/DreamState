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

//- (NSComparisonResult)weekdayCompare:(NSString*)otherDay {
//
//    NSArray *weekDays2 = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday",  @"Friday",@"Saturday", nil];
//    
//    NSUInteger selfIndex = [weekDays2 indexOfObject:self];
//    NSUInteger otherDayIndex = [weekDays2 indexOfObject:otherDay];
//    
//    if (selfIndex < otherDayIndex) {
//        return NSOrderedAscending;
//    }
//    else if (selfIndex > otherDayIndex) {
//        return NSOrderedDescending;
//    } else {
//        return NSOrderedSame;
//    }
//}

-(NSString *)tidyDaysFromArray:(NSArray *)array{
NSLog(@"array : %@", array);
    
    array = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
            NSString *s1 = obj1;
            NSString *s2 = obj2;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
             NSArray *weekDays2 = [dateFormatter weekdaySymbols]; 
            
            
           // NSArray *weekDays2 = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday",  @"Friday",@"Saturday", nil];
            
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

        // TODO: default is the same?
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSString *tidyDay = [[NSString alloc]init];
   
    for (NSString *myArrayElement in array) {
        NSString *shortDay = [myArrayElement substringToIndex:3];
        
        tidyDay = [tidyDay stringByAppendingString:shortDay];
        tidyDay = [tidyDay stringByAppendingString:@", "];
        
    }
    if ([tidyDay length] > 0) {
        tidyDay = [tidyDay substringToIndex:[tidyDay length] - 2];
        return tidyDay;
    }
    return @"";    
}

@end
