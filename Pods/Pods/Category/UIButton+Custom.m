//
//  UIButton+Custom.m
//  Abilene
//
//  Created by Toan Quach on 6/1/13.
//
//

#import "UIButton+Custom.h"

@implementation UIButton(Custom)

+ (void)setFrameForButton:(UIButton*)button
{
    CGRect buttonFrame = [button frame];
    CGPoint centerPoint = button.center;
    CGSize textSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font];
    buttonFrame.size = CGSizeMake(textSize.width+50, buttonFrame.size.height);
    button.frame = buttonFrame;
    button.center = centerPoint;
}

+ (void)setFrameForButtonFromLeft:(UIButton*)button
{
    CGRect buttonFrame = [button frame];
    CGSize textSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font];
    buttonFrame.size = CGSizeMake(textSize.width+20, buttonFrame.size.height);
    button.frame = buttonFrame;
}

@end
