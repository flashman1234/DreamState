//
//  Dream.h
//  DreamState
//
//  Created by Michal Thompson on 8/10/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dream : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * fileUrl;
@property (nonatomic, retain) NSString * mediaType;

@end
