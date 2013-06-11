//
//  ESButton.m
//  EnglishStudy
//
//  Created by Toan.Quach on 6/11/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import "ESButton.h"

@implementation ESButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self.imageView setContentMode:UIViewContentModeTop];
        
        //UIFont *font = [UIFont fontWithName:@"Stag-Book" size:11];
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        //self.titleLabel.font = font;
        
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.6] forState:UIControlStateNormal];
        self.titleLabel.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.imageView.frame;
    rect.origin.x = (NSInteger)(self.bounds.size.width/2 - rect.size.width/2);
    rect.origin.y = 12.0;
    self.imageView.frame = rect;
    
    rect = self.titleLabel.frame;
    rect.size.width = self.bounds.size.width;
    rect.origin.x = 0;
    rect.origin.y = self.bounds.size.height - 22.0;
    self.titleLabel.frame = rect;
}

@end
