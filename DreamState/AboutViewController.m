//
//  AboutViewController.m
//  DreamState
//
//  Created by Michal Thompson on 9/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

-(void)sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body{
    
    NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@", [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}


- (IBAction)openMail:(id)sender 
{
    
    [self sendEmailTo:@"flashman1234@gmail.com" withSubject:@"DreamState" withBody:@"hey"];

    
}

- (IBAction)openWebsite:(id)sender{
    NSString *mailString = [NSString stringWithFormat:@"http://dreamstate.squareknife.com"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
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
    // Do any additional setup after loading the view from its nib.
    aboutText.text = @"Dream State was created by Michal Thompson and Hannes Niepold";
    aboutText.font = [UIFont fontWithName:@"Solari" size:20];
    aboutText.numberOfLines = 0;
    [aboutText setLineBreakMode:UILineBreakModeWordWrap];
    
    contactText.titleLabel.font = [UIFont fontWithName:@"Solari" size:14];
    [contactText setTitle:@"Contact us" forState:UIControlStateNormal];
    contactText.titleLabel.textColor = [UIColor whiteColor];
    
    findUs.titleLabel.font = [UIFont fontWithName:@"Solari" size:14];
    [findUs setTitle:@"Find us" forState:UIControlStateNormal];
    findUs.titleLabel.textColor = [UIColor whiteColor];

    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    self.title = @"About";
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


-(void)viewWillAppear:(BOOL)animated
{  
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
