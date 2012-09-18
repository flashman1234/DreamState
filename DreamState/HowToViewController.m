//
//  HowToViewController.m
//  DreamState
//
//  Created by Michal Thompson on 9/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "HowToViewController.h"


@implementation HowToViewController



-(void)loadScrollView{
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    
    NSString *s = @"We suggest you change your notification types for Dream State in your device settings:";
    
    CGSize textSize = [s 
                       sizeWithFont:[UIFont fontWithName:@"Solari" size:15] 
                       constrainedToSize:CGSizeMake(self.view.frame.size.width, 2000)
                       lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 80, textSize.width, textSize.height);
    label1.numberOfLines = 0;
    [label1 setLineBreakMode:UILineBreakModeWordWrap];
    label1.font = [UIFont fontWithName:@"Solari" size:15];
    label1.backgroundColor = [UIColor blackColor];
    label1.textColor = [UIColor whiteColor];
    [label1 setText:s];

    [scrollView addSubview:label1];
    
    UIImage *image1 = [UIImage imageNamed: @"Notifications.png"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
    imageView1.frame = CGRectMake(20, 170, image1.size.width, image1.size.height);
    [scrollView addSubview:imageView1];
    
    UIImage *image2 = [UIImage imageNamed: @"Notifications2.png"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(20, 380, image2.size.width, image2.size.height);
    [scrollView addSubview:imageView2];
    
    UIImage *image3 = [UIImage imageNamed: @"Notifications3.png"];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image3];
    imageView3.frame = CGRectMake(20, 770, image3.size.width, image3.size.height);
    [scrollView addSubview:imageView3];


}

/*

then you can create your UILabel like that :

UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,textSize.width, textSize.height];
                                                          [lbl setNumberOfLines:0];
                                                          [lbl setLineBreakMode:UILineBreakModeWordWrap];
                                                          [lbl setText:[myObject getALongText]];
*/

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
    [self loadScrollView];
     [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
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
