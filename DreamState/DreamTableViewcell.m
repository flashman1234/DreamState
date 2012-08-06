//
//  DreamTableViewcell.m
//  Dream
//
//  Created by Michal Thompson on 7/18/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "DreamTableViewcell.h"




@implementation DreamTableViewcell

@synthesize dreamLabel = _dreamImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
