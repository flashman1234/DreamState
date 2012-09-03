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


@property (nonatomic, retain) NSArray *weekDays;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
