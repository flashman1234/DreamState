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
        UIImage *myImage2 = [UIImage imageNamed:@"dreamstaterecordimage.png"];
        myImage = myImage2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
      
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetLineWidth(context, 2.0);
    
    float colour = passedInValue;
    
    float size =  ((passedInValue *40) + 1) * 8;
    float theAlpha = 1;
    if (size < 20) {
        theAlpha = 0.8;
    }
    
    if (size < 15) {
        theAlpha = 0.6;
    }
    
    if (size < 10) {
        theAlpha = 0.5;
    }
    
    CGContextSetCMYKFillColor(context, 0.2, colour, colour, 0, theAlpha);
    //CGContextSetCMYKFillColor(<#CGContextRef context#>, <#CGFloat cyan#>, <#CGFloat magenta#>, <#CGFloat yellow#>, <#CGFloat black#>, <#CGFloat alpha#>)
    

    
//    if (size < 20) {
//        size = 20;
//    }
//    if (size > 250) {
//        size = size * 0.90;
//    }
    
    
    //CGContextFillEllipseInRect(context, CGRectMake(self.frame.size.width / 2 - (size/2), self.frame.size.height / 2 - (size/2), size, size));
    CGContextFillRect(context, CGRectMake((((self.frame.size.width / 2) - (size/2))) + 5 , (((self.frame.size.height / 2) - (size/2))) + 5 , (size) - 10, (size) - 10));
    
    float width = rect.size.width;
    float height = rect.size.height;
    
    CGRect imageRect = CGRectMake(((width/2) - (size/2)) - 10, ((height/2) - (size/2)) - 10, size + 20, size + 20);
     [myImage drawInRect:imageRect];
    
}

@end
