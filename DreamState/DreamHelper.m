//
//  DreamHelper.m
//  DreamState
//
//  Created by Michal Thompson on 8/13/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "DreamHelper.h"
#import "Dream.h"

@implementation DreamHelper

@synthesize managedObjectContext;


-(void)syncDataStoreWithFiles
{
    
    [self deleteAllDreams];
  
    //reload
    
    
}

-(void)deleteAllDreams
{
    NSFetchRequest * allDreams = [[NSFetchRequest alloc] init];
    [allDreams setEntity:[NSEntityDescription entityForName:@"Dream" inManagedObjectContext:managedObjectContext]];
    [allDreams setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * dreams = [managedObjectContext executeFetchRequest:allDreams error:&error];
    
    //error handling goes here
    for (NSManagedObject *dream in dreams) {
        [managedObjectContext deleteObject:dream];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
}

@end
