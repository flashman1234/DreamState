//
//  AlarmLabelViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/8/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmLabelViewController.h"
#import "AlarmViewController.h"

@interface AlarmLabelViewController ()

@end

@implementation AlarmLabelViewController

@synthesize labelTextField;
@synthesize existingName;


-(void)saveAlarmLabel:(id)sender{
    
    AlarmViewController *parentViewController = (AlarmViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        
    parentViewController.alarmName = labelTextField.text;

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [labelTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [labelTextField resignFirstResponder];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Alarm label";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarmLabel:)];
    
    if (existingName) {
        labelTextField.text = existingName;
    }
    
}

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
    [labelTextField becomeFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
