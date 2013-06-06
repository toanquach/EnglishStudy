//
//  Utils.h
//  Abilene
//
//  Created by Toan Quach on 6/3/13.
//
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (BOOL)isNumeric:(NSString*) checkText;
+ (BOOL)validateEmail:(NSString *)email;

@end
