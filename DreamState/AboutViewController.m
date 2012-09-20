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
    
    [self sendEmailTo:@"admin@dreamstate.squareknife.com" withSubject:@"DreamState" withBody:@""];

    
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

    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    NSString *s = @"Half of our lives we spend in dream state, and its not necessarily the less interesting part.\n\nMost of us forget their dreams immediately after waking up, and most of us are too lazy to write or operate some recording-tool while still struggling to cope with their new waking state surroundings. \n\nThats a pity, as many great inventions, narratives, songs, or just thoughts were born there but never made it cross the state-line.\n\nAnd thats why we created this App here.\n\nIt's an alarm clock which can automatically start recording audio, allowing you to record and archive your dreams while they are still vivid.\n\nDream State was created by Michal Thompson and Hannes Niepold\n\n Thanks to 8th Mode Music for supplying the 'A Mind of its Own', 'Blurred Atmospheres', 'Hard as Nails', and 'High Action' alarm sounds.";
    
    CGSize textSize = [s 
                       sizeWithFont:[UIFont fontWithName:@"Solari" size:15] 
                       constrainedToSize:CGSizeMake(self.view.frame.size.width, 2000)
                       lineBreakMode:UILineBreakModeWordWrap];
    aboutText.frame = CGRectMake(0,200, textSize.width, textSize.height);
    
    aboutText.text = s;
    aboutText.font = [UIFont fontWithName:@"Solari" size:15];
    aboutText.numberOfLines = 0;
    [aboutText setLineBreakMode:UILineBreakModeWordWrap];
    
    contactText.titleLabel.font = [UIFont fontWithName:@"Solari" size:15];
    [contactText setTitle:@"Contact us" forState:UIControlStateNormal];
    contactText.titleLabel.textColor = [UIColor whiteColor];
    
    findUs.titleLabel.font = [UIFont fontWithName:@"Solari" size:15];
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
