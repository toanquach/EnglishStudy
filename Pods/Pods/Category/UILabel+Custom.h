//
//  UILabel+Custom.h
//  YouPlusMobile
//
//  Created by HAI NGUYEN on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel(Custom)

+ (void)setHeightForLabel:(UILabel*)newLabel;

//Set Width for Label with the Max Width & align center in the first position
+ (void)setWidthForLabel:(UILabel*)newLabel widthLimit:(float)newWidth isCenter:(BOOL)isCenter;

@end
