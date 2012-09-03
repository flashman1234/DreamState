//
//  DreamTableViewcell.h
//  Dream
//
//  Created by Michal Thompson on 7/18/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DreamTableViewcell : UITableViewCell{
    UIView *upperLine;
    UIView *lowerLine;
}

//@property (nonatomic, strong) UILabel *dreamLabel;

@property (nonatomic ,retain) UIView *upperLine;
@property (nonatomic ,retain) UIView *lowerLine;


@end
