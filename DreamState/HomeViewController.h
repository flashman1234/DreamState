//
//  HomeViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

-(IBAction)pressAlarmButton;
-(IBAction)pressANewDreamButton;
-(IBAction)pressOldDreamButton;
-(IBAction)pressSettingsButton;

@property(nonatomic, retain)IBOutlet UIButton *nextAlarmView;


@property(nonatomic, retain)IBOutlet UIButton *aNewDreamView;
@property(nonatomic, retain)IBOutlet UIButton *oldDreamView;
@property(nonatomic, retain)IBOutlet UIButton *settingsView;



@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic,strong) UILabel *nextAlarmTimeLabel;
@property (nonatomic,strong) UILabel *nextAlarmDayLabel;

@property (nonatomic,strong) UIImageView *bellView;



@end
