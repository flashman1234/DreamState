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

@property(nonatomic, retain)IBOutlet UIButton *nextAlarmView;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) UILabel *nextAlarmTimeLabel;
@property (nonatomic,strong) UILabel *nextAlarmDayLabel;
@property (nonatomic,strong) UIImageView *bellView;

@end
