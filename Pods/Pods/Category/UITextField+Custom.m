//
//  UITextField+Custom.m
//  Abilene
//
//  Created by Mac on 5/29/13.
//
//

#import "UITextField+Custom.h"

@implementation UITextField(Custom)

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    return inset;
}

@end
