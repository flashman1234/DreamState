//
//  ViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
{
    UIButton *alarmButton;
    UIButton *currentDreamButton;
    UIButton *recordDreamButton;
    UIButton *settingsButton;
}

@property(nonatomic, retain)IBOutlet UIButton *alarmButton;
@property(nonatomic, retain)IBOutlet UIButton *currentDreamButton;
@property(nonatomic, retain)IBOutlet UIButton *recordDreamButton;
@property(nonatomic, retain)IBOutlet UIButton *settingsButton;


-(IBAction)pressAlarmButton;
-(IBAction)pressCurrentDreamButton;
-(IBAction)pressRecordDreamButton;
-(IBAction)pressSettingsButton;


@end
