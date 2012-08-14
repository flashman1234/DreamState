//
//  DreamNameViewController.m
//  DreamState
//
//  Created by Michal Thompson on 8/13/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "DreamNameViewController.h"
#import "Dream.h"

@interface DreamNameViewController ()

@end

@implementation DreamNameViewController
@synthesize labelTextField;
@synthesize existingDream;
@synthesize managedObjectContext;


-(void)saveDreamNameLabel:(id)sender{

    existingDream.name = labelTextField.text;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *saveError = nil;
    [context save:&saveError];
    if (saveError) {
        NSLog(@"saveError : %@", saveError);
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [labelTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [labelTextField resignFirstResponder];
    return YES;
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
    
    self.title = @"Dream name";
    
    NSLog(@"existingDream : %@", existingDream);
    
    labelTextField.text = existingDream.name;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                              target:self action:@selector(saveDreamNameLabel:)];
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
