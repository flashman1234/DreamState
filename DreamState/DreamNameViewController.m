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

-(void)cancelDreamNameLabel:(id)sender{
       
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    existingDream.name = labelTextField.text;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *saveError = nil;
    [context save:&saveError];
    if (saveError) {
        NSLog(@"saveError : %@", saveError);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                             target:self action:@selector(cancelDreamNameLabel:)];
}

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
    [self.navigationController setNavigationBarHidden:YES animated:flag];
    [labelTextField becomeFirstResponder];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
