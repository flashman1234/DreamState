//
//  DreamNameViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/13/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dream.h"

@interface DreamNameViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *labelTextField ;

}

@property ( nonatomic , retain ) IBOutlet UITextField *labelTextField ;

@property (nonatomic, retain) Dream *existingDream;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
