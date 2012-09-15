//
//  AlarmLabelViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/8/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AlarmLabelViewController.h"
#import "AlarmViewController.h"
#import "UITextFieldNoMenu.h"

@implementation AlarmLabelViewController

@synthesize labelTextField;
@synthesize existingName;

-(void)saveAlarmLabel:(id)sender{
    
    AlarmViewController *parentViewController = (AlarmViewController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        
    parentViewController.alarmName = labelTextField.text;

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)cancelAlarmLabel:(id)sender{
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Alarm label";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveAlarmLabel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                             target:self action:@selector(cancelAlarmLabel:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if (existingName) {
        labelTextField.text = existingName;
    }
    
    labelTextField.backgroundColor = [UIColor blackColor];
    [labelTextField setFont:[UIFont fontWithName:@"Solari" size:20]];
    labelTextField.textColor = [UIColor whiteColor];
    labelTextField.borderStyle = UITextBorderStyleBezel;
    
    CGFloat myWidth = 26.0f;
    CGFloat myHeight = 30.0f;
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myWidth, myHeight)];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateHighlighted];
    
    [myButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    
    labelTextField.rightView = myButton;
    labelTextField.rightViewMode = UITextFieldViewModeAlways;
//    [labelTextField setHighlighted:YES];
    //[labelTextField selectAll:labelTextField];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)iTextField {
[iTextField selectAll:self];
}

-(void) doClear:(id)sender{
    labelTextField.text = @"";
}

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
    [labelTextField becomeFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
