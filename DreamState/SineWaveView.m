//
//  SineWaveView.m
//  DreamState
//
//  Created by Michal Thompson on 8/16/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "SineWaveView.h"

@implementation SineWaveView
@synthesize passedInValue;
@synthesize myImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *myImage2 = [UIImage imageNamed:@"dslogocroppedtransparent.png"];
        myImage = myImage2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
      
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
    float colour = passedInValue;
    
    
    CGContextSetCMYKFillColor(context, 0.2, colour, colour, 0, 1);
    //CGContextSetCMYKFillColor(<#CGContextRef context#>, <#CGFloat cyan#>, <#CGFloat magenta#>, <#CGFloat yellow#>, <#CGFloat black#>, <#CGFloat alpha#>)
    
    
    float size =  ((passedInValue *200) + 10) * 2;
    if (size > 280) {
        size = 280;
    }
    
    //CGContextFillEllipseInRect(context, CGRectMake(self.frame.size.width / 2 - (size/2), self.frame.size.height / 2 - (size/2), size, size));
    CGContextFillRect(context, CGRectMake(((self.frame.size.width / 2) - (size/2)) , ((self.frame.size.height / 2) - (size/2)) , size -1, size -1));
    
    
    float width = rect.size.width;
    float height = rect.size.height;
 
    
    CGRect imageRect = CGRectMake((width/2) - (size/2), (height/2) - (size/2), size, size);
    
    [myImage drawInRect:imageRect];
    
}

@end
