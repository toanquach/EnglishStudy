//
//  UILabel+Custom.m
//  YouPlusMobile
//
//  Created by HAI NGUYEN on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel(Custom)

+ (void)setHeightForLabel:(UILabel*)newLabel
{
    CGRect frame = [newLabel frame];
    CGSize maximumSize = CGSizeMake(frame.size.width, 9999);
    
    CGSize expectedSize = [newLabel.text sizeWithFont:newLabel.font 
                                    constrainedToSize:maximumSize 
                                        lineBreakMode:newLabel.lineBreakMode]; 
    if (expectedSize.width < frame.size.width)
    {
        expectedSize.width = frame.size.width;
    }
    frame.size = expectedSize;
    newLabel.frame = frame;
}

+ (void)setWidthForLabel:(UILabel*)newLabel widthLimit:(float)newWidth isCenter:(BOOL)isCenter
{
    CGRect frame = [newLabel frame];
    if (newWidth == 0) 
    {
        newWidth = frame.size.height;
    }
    CGSize maximumSize = CGSizeMake(9999, newWidth);
    CGSize expectedSize = [newLabel.text sizeWithFont:newLabel.font 
                                    constrainedToSize:maximumSize 
                                        lineBreakMode:newLabel.lineBreakMode]; 
    frame.size = expectedSize;
    newLabel.frame = frame;
}

@end
