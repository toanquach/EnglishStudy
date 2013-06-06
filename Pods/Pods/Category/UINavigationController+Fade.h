//
//  UINavigationController+Fade.h
//  Abilene
//
//  Created by Toan Quach on 6/1/13.
//
//

#import <Foundation/Foundation.h>

@interface UINavigationController(Fade)

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)fadePopViewController;
- (void)popFadeToViewController:(UIViewController *)viewController;

@end
