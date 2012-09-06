//
//  HomeViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "AlarmViewController.h"
#import "AlarmListViewController.h"


@implementation HomeViewController
@synthesize nextAlarmView;
@synthesize managedObjectContext;
@synthesize nextAlarmDayLabel;
@synthesize nextAlarmTimeLabel;
@synthesize bellView;

-(IBAction)pressAlarmButton{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Alarm" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        if (fetchedObjects.count > 0) {
            AlarmListViewController *alarmListController = [[AlarmListViewController alloc] init];
            alarmListController.managedObjectContext = [self managedObjectContext];
            [self.navigationController pushViewController:alarmListController animated:NO];
        }
        else {
            AlarmViewController *alarmController = [[AlarmViewController alloc] init];
            alarmController.managedObjectContext = [self managedObjectContext];
            [self.navigationController pushViewController:alarmController animated:NO];
        }
    }
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
        
        UIImageView *bellViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackalarmbell.png"]];
        bellView = bellViewTemp;
        bellView.tag = 99;
        [bellView setFrame:CGRectMake(200, 25, 50, 50)];
        [nextAlarmView addSubview:bellView];
        
    }
    else {
        [nextAlarmTimeLabel setFont:[UIFont fontWithName:@"Solari" size:40]];
        nextAlarmTimeLabel.text = @"Add alarm";
        nextAlarmDayLabel.text = @"";
        UIImageView *theBellView = (UIImageView *)[self.view viewWithTag:99];
        [theBellView removeFromSuperview];
        theBellView = nil;
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
}



#pragma mark - init and view
- (id)init {
  
    UITabBarItem *tbi = [self tabBarItem];
    [tbi setTitle:@"Home"];
    UIImage *i = [UIImage imageNamed:@"iconnav2.png"];
    [tbi setImage:i];
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
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
