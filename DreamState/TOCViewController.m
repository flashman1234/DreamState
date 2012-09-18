//
//  TOCViewController.m
//  DreamState
//
//  Created by Michal Thompson on 9/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "TOCViewController.h"



@implementation TOCViewController

-(void)loadTOC{
    
    tosText.text = @"This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.";
    tosText.font = [UIFont fontWithName:@"Solari" size:14];
    
//    UILabel *TOSLabel = [[UILabel alloc] init];
//    TOSLabel.frame = CGRectMake(120,100, 300, 50);
//    [TOSLabel setFont:[UIFont fontWithName:@"Solari" size:20]];
//    TOSLabel.textColor = [UIColor whiteColor];
//    TOSLabel.backgroundColor = [UIColor clearColor];
//    
//    TOSLabel.text = @"Terms of Service";
    
}

-(void)viewWillAppear:(BOOL)animated
{  
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadTOC];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.title = @"Terms of Service";
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

@end
