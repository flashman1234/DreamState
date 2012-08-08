//
//  AlarmLabelViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/8/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmLabelViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *labelTextField ;
    NSString *existingName;
}

@property ( nonatomic , retain ) IBOutlet UITextField *labelTextField ;
@property ( nonatomic , retain ) NSString *existingName;

@end
