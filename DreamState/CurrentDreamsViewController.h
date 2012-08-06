//
//  CurrentDreamsViewController.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentDreamsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *tableViewArray;
    
    IBOutlet UITableView  *dreamTableView;
}

@property (nonatomic, retain) UITableView *dreamTableView;

@end