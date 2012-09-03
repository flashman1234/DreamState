//
//  HomeViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "HomeViewController.h"
#import "RecordDreamViewController.h"
#import "AppDelegate.h"
#import "InAppSettings.h"
#import "AlarmViewController.h"
#import "RecordDreamViewController.h"
#import "CurrentDreamsViewController.h"
#import "Alarmhelper.h"
#import "AlarmListViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize nextAlarmView;
@synthesize managedObjectContext;
@synthesize nextAlarmDayLabel;
@synthesize nextAlarmTimeLabel;
@synthesize aNewDreamView;
@synthesize oldDreamView;
@synthesize settingsView;
@synthesize bellView;

-(IBAction)pressAlarmButton{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    AlarmListViewController *alarmController = [[AlarmListViewController alloc] init];
    alarmController.managedObjectContext = [self managedObjectContext];
    [self.navigationController pushViewController:alarmController animated:NO];
    
}


-(IBAction)pressANewDreamButton{
    RecordDreamViewController *recordDreamViewController = [[RecordDreamViewController alloc] init];
    recordDreamViewController.managedObjectContext = [self managedObjectContext];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] pushViewController:recordDreamViewController animated:NO];
}

-(IBAction)pressOldDreamButton{
    
        CurrentDreamsViewController *currentDreamsViewController = [[CurrentDreamsViewController alloc] init];
        currentDreamsViewController.managedObjectContext = [self managedObjectContext];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] pushViewController:currentDreamsViewController animated:NO];
 

    
}
-(IBAction)pressSettingsButton{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [[self navigationController] pushViewController:settings animated:NO]; 
}


#pragma mark - Alarm details

-(void)setAlarmDetails{
    NSArray *notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];    
    
   
    
    if (notificationsArray.count > 0) {
        UILocalNotification *firstNotification = [notificationsArray objectAtIndex:0];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"HH:mm"]; 
        nextAlarmTimeLabel.text = [dateFormat  stringFromDate:firstNotification.fireDate];
        
    
        
        
        
        
        [dateFormat setDateFormat: @"EEEE"]; 
        NSString *dayText = [dateFormat  stringFromDate:firstNotification.fireDate];
        
        NSDate *todayDate = [NSDate date];
        NSString *today = [dateFormat  stringFromDate:todayDate];
        
        if ([today isEqualToString:dayText]) {
            dayText = @"Today";
        }
        
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:todayDate];
        NSInteger theDay = [todayComponents day];
        NSInteger theMonth = [todayComponents month];
        NSInteger theYear = [todayComponents year];
        
        // now build a NSDate object for yourDate using these components
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:theDay]; 
        [components setMonth:theMonth]; 
        [components setYear:theYear];
        NSDate *thisDate = [gregorian dateFromComponents:components];
                
        // now build a NSDate object for the next day
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
               
        NSString *tomorrow = [dateFormat  stringFromDate:nextDate];
        
        if ([tomorrow isEqualToString:dayText]) {
            dayText = @"Tomorrow";
        }
        
        
        nextAlarmDayLabel.text = dayText;
        [nextAlarmTimeLabel setFont:[UIFont fontWithName:@"Solari" size:60]];
        
        UIImage *bell;
        bell = [UIImage imageNamed:@"blackalarmbell.png"];
        UIImageView *bellViewTemp = [[UIImageView alloc] initWithImage:bell];
        bellView = bellViewTemp;
        [bellView setFrame:CGRectMake(200, 25, 50, 50)];
        [nextAlarmView addSubview:bellView];

        
    }
    else {
        [nextAlarmTimeLabel setFont:[UIFont fontWithName:@"Solari" size:40]];
        nextAlarmTimeLabel.text = @"Add alarm";
        nextAlarmDayLabel.text = @"";
        [bellView removeFromSuperview];
    }
    
    
   
        

}


#pragma mark - screen swipes

-(void)setSwipes{
    UISwipeGestureRecognizer *swipe;

    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
       
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    

    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe];
      
}

- (void) swipedScreen:(UISwipeGestureRecognizer*)swipeGesture {

    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionUp) {
        
        
            InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
            
            CATransition* transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [[self navigationController] pushViewController:settings animated:NO];     

    }
    
    
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        RecordDreamViewController *recordDreamViewController = [[RecordDreamViewController alloc] init];
        recordDreamViewController.managedObjectContext = [self managedObjectContext];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] pushViewController:recordDreamViewController animated:NO];
    }
    
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        CurrentDreamsViewController *currentDreamsViewController = [[CurrentDreamsViewController alloc] init];
        currentDreamsViewController.managedObjectContext = [self managedObjectContext];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] pushViewController:currentDreamsViewController animated:NO];
    }
}



#pragma mark - localAction
-(void)localAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RecordDreamViewController *recordDreamController = [[RecordDreamViewController alloc] init];
    recordDreamController.managedObjectContext = self.managedObjectContext;
    recordDreamController.loadedFromAlarm = YES;
    [self.navigationController pushViewController:recordDreamController animated:YES];
    
    [self.tabBarController setSelectedIndex:1];
    
}







#pragma mark - view methods


- (id)init {
  
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"Alarm"];
    UIImage *i = [UIImage imageNamed:@"11-clock.png"];
    [tbi setImage:i];
    
    return self;
}



- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
      
    
        
    
    
//    UIImageView *customBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockbackground.png"]];
//	backGroundView = customBackground;
//
//	
//	[self addSubview:backGroundView];
//
    
    
    
    
//    UIImage *background;
//    background = [UIImage imageNamed:@"clockbackground.png"];
//    
//    backGroundView = [[UIImageView alloc] initWithImage:background];
//    [backGroundView setFrame:CGRectMake(0, 0, 300, 300)];
    
    //[backGroundView setBackgroundImage:[UIImage imageNamed:@"cloud.png"]];
    
    
    
    
    
//    UITabBarItem *firstItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
//    [self.navigationController setTabBarItem:firstItem];
    
    
        
    //[nextAlarmView setBackgroundImage:[UIImage imageNamed:@"AlarmTimeBackground.png"] forState:normal];
    //[nextAlarmView setBackgroundImage:[UIImage imageNamed:@"Awaken.png"] forState:normal];
    
  
    
    
//    
//    [aNewDreamView setBackgroundImage:[UIImage imageNamed:@"cloudFlip.png"] forState:normal];
//    UILabel *newLabel = [[UILabel alloc] init];
//
//    newLabel.frame = CGRectMake(30, 7, 50, 50);
//    newLabel.text = @"New";
//    newLabel.backgroundColor = [UIColor clearColor];
//    
//    newLabel.textColor=[UIColor colorWithRed:(14.0/255.0) green:(105.0/255) blue:(128.0/255) alpha:1.0];
//    [newLabel setFont:[UIFont fontWithName:@"DS-DIGI" size:20]];
//
//    [aNewDreamView addSubview:newLabel];

    
    
//    
//    [oldDreamView setBackgroundImage:[UIImage imageNamed:@"cloud.png"] forState:normal];
//    UILabel *oldLabel = [[UILabel alloc] init];
//    
//    oldLabel.frame = CGRectMake(30, 7, 50, 50);
//    oldLabel.text = @"Old";
//    oldLabel.backgroundColor = [UIColor clearColor];
//    
//    oldLabel.textColor=[UIColor colorWithRed:(14.0/255.0) green:(105.0/255) blue:(128.0/255) alpha:1.0];
//    [oldLabel setFont:[UIFont fontWithName:@"DS-DIGI" size:20]];
//    
//    
//    [oldDreamView addSubview:oldLabel];
//    
//    
//    
//    [settingsView setBackgroundImage:[UIImage imageNamed:@"button18024651.png"] forState:normal];
    
    
    /* [self setSwipes]; 
    
    UIImage *settingsButton = [UIImage imageNamed: @"button18024651.png"];
    UIImageView *settingsButtonView = [[UIImageView alloc] initWithImage:settingsButton];
    
    
    
    settingsButtonView.frame = CGRectMake(100, self.view.layer.bounds.size.height - 30, 120, 30);
    [self.view insertSubview:settingsButtonView atIndex:100];
    
    UIImage *newDreamButton = [UIImage imageNamed: @"cloudFlip.png"];
    UIImageView *newDreamButtonView = [[UIImageView alloc] initWithImage:newDreamButton];
    
    UILabel *newLabel = [[UILabel alloc] init];
    newLabel.frame = CGRectMake(20, 10, 50, 50);
    newLabel.text = @"New";
    newLabel.backgroundColor = [UIColor clearColor];
    
    newLabel.textColor=[UIColor colorWithRed:(14.0/255.0) green:(105.0/255) blue:(128.0/255) alpha:1.0];
    [newLabel setFont:[UIFont fontWithName:@"Arial" size:30]];
    
     
     [newDreamButtonView addSubview:newLabel];
    
    newDreamButtonView.frame = CGRectMake(220, 300, 100, 100);
    [self.view insertSubview:newDreamButtonView atIndex:100];
    
    UIImage *oldDreamButton = [UIImage imageNamed: @"cloud.png"];
    UIImageView *oldDreamButtonView = [[UIImageView alloc] initWithImage:oldDreamButton];
    oldDreamButtonView.frame = CGRectMake(0,300, 100, 100);
    [self.view insertSubview:oldDreamButtonView atIndex:100];
    */
    
    nextAlarmTimeLabel = [[UILabel alloc] init];
    nextAlarmTimeLabel.numberOfLines = 0;
    nextAlarmTimeLabel.frame = CGRectMake(20,20, 300, 90);
    nextAlarmTimeLabel.textColor = [UIColor whiteColor];
    nextAlarmTimeLabel.backgroundColor = [UIColor clearColor];
    
    nextAlarmDayLabel = [[UILabel alloc] init];
    nextAlarmDayLabel.frame = CGRectMake(180,100, 150, 50);
    [nextAlarmDayLabel setFont:[UIFont fontWithName:@"Solari" size:20]];
    nextAlarmDayLabel.textColor = [UIColor whiteColor];
    nextAlarmDayLabel.backgroundColor = [UIColor clearColor];
   
    
    [nextAlarmView addSubview:nextAlarmDayLabel];
    [nextAlarmView addSubview:nextAlarmTimeLabel];
    
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(35,20, 300, 90);
    [title setFont:[UIFont fontWithName:@"Solari" size:35]];
    title.text = @"DREAM STATE";
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    
    [self.view addSubview:title];
    
    
    [self setAlarmDetails];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localAction) name:localReceived object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setAlarmDetails];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
