//
//  ViewController.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "MenuViewController.h"
//#import "AlarmViewController.h"
#import "AlarmListViewController.h"

#import "CurrentDreamsViewController.h"
#import "RecordDreamViewController.h"
#import "AppDelegate.h"

#import "InAppSettings.h"


#import "Alarm.h"


@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize alarmButton, currentDreamButton, recordDreamButton, settingsButton;

@synthesize alarms;


@synthesize managedObjectContext;

#pragma mark - IBActions

-(IBAction)pressAlarmButton{
    AlarmListViewController *alarmController = [[AlarmListViewController alloc] init];
    alarmController.managedObjectContext = [self managedObjectContext];
    [self.navigationController pushViewController:alarmController animated:YES];
   
}
-(IBAction)pressCurrentDreamButton{
    CurrentDreamsViewController *currentDreamsController = [[CurrentDreamsViewController alloc] init];
    currentDreamsController.managedObjectContext = [self managedObjectContext];
    [self.navigationController pushViewController:currentDreamsController animated:YES];
    
}
-(IBAction)pressRecordDreamButton{
    RecordDreamViewController *recordDreamController = [[RecordDreamViewController alloc] init];
    recordDreamController.managedObjectContext = [self managedObjectContext];
    [self.navigationController pushViewController:recordDreamController animated:YES];
}

-(IBAction)pressSettingsButton{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];

}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.title = @"Dream State";
    
    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Alarm" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.alarms = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localAction) name:localReceived object:nil];
    
    [self setSwipes];

}

-(void)setSwipes{
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.delaysTouchesEnded = YES;
    //swipeUp.direction = (UISwipeGestureRecognizerDirectionUp);
    [self.view addGestureRecognizer:swipeUp];
    
//    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreenDown:)];
//    swipeDown.numberOfTouchesRequired = 1;
//    swipeDown.direction = (UISwipeGestureRecognizerDirectionDown);
//    [self.view addGestureRecognizer:swipeDown];

}

- (void) swipedScreen:(UISwipeGestureRecognizer*)swipeGesture {
    
    if ([swipeGesture direction] == UISwipeGestureRecognizerDirectionUp) {
        InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] pushViewController:settings animated:NO];
    }
    
    
    
    
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.75;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype =kCATransitionFromLeft;
//    transition.delegate = self;
//    [self.view.layer addAnimation:transition forKey:nil];

//    [UIView animateWithDuration:0.75
//                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                         [self.navigationController pushViewController:settings animated:NO];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
//                     }];
    
    
    //[self.navigationController pushViewController:settings animated:YES];

}

-(void)localAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RecordDreamViewController *recordDreamController = [[RecordDreamViewController alloc] init];
    recordDreamController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:recordDreamController animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


@end
