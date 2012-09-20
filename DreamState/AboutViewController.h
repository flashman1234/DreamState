//
//  AboutViewController.h
//  DreamState
//
//  Created by Michal Thompson on 9/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController{
//    IBOutlet UITextView *aboutText;
//    IBOutlet UITextView *contactText;
    
    IBOutlet UILabel *aboutText;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *contactText;
    IBOutlet UIButton *findUs;
}
- (IBAction)openMail:(id)sender;
- (IBAction)openWebsite:(id)sender;



@end
