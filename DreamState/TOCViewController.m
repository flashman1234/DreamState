//
//  TOCViewController.m
//  DreamState
//
//  Created by Michal Thompson on 9/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "TOCViewController.h"

@interface TOCViewController ()

@end

@implementation TOCViewController


-(void)loadTOC{
    UILabel *TOSLabel = [[UILabel alloc] init];
    TOSLabel.frame = CGRectMake(120,100, 300, 50);
    [TOSLabel setFont:[UIFont fontWithName:@"Solari" size:20]];
    TOSLabel.textColor = [UIColor whiteColor];
    TOSLabel.backgroundColor = [UIColor clearColor];
    
    TOSLabel.text = @"Terms of Service";
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
