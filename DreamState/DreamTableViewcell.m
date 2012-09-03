//
//  DreamTableViewcell.m
//  Dream
//
//  Created by Michal Thompson on 7/18/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "DreamTableViewcell.h"


@implementation DreamTableViewcell
@synthesize upperLine;
@synthesize lowerLine;
//@synthesize dreamLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.upperLine = [[UIView alloc] init];
        self.lowerLine = [[UIView alloc] init];
        [self.contentView addSubview:self.upperLine];
        [self.contentView addSubview:self.lowerLine];
        
//        self.dreamLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 290, 25)];
//        dreamLabel.tag = 1;        
//        dreamLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:20.0];
//        dreamLabel.textColor = [UIColor grayColor];
//        dreamLabel.backgroundColor = [UIColor clearColor];
//
//        [self.contentView addSubview:self.dreamLabel];
    }
    return self;
}

- (void)layoutSubviews {
    //[self.upperLine setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
    [self.lowerLine setFrame:CGRectMake(0, self.contentView.frame.size.height - 1, self.frame.size.width, 1)];
    //[self.lowerLine setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
