//
//  LegalViewController.h
//  DreamState
//
//  Created by Michal Thompson on 9/15/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettings.h"

@interface LegalViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView  *legalTableView;
}
@property (nonatomic, retain) UITableView *legalTableView;
@property (nonatomic, retain) InAppSettingsViewController *inAppSettings;
@end
