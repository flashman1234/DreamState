//
//  UITextFieldNoMenu.m
//  DreamState
//
//  Created by Michal Thompson on 9/8/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "UITextFieldNoMenu.h"

@implementation UITextFieldNoMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:))//and put other actions also
        return NO;
    return [super canPerformAction:action withSender:sender];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
