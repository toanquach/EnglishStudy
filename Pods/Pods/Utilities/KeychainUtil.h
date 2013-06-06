//
//  KeychainUtil.h
//  YouPlusMobile
//
//  Created by Duong Anh Thi on 07/09/2012.
//  Copyright (c) 2012 Sutrix. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeychainUtil : NSObject

+ (NSString *)getSecureValueForKey:(NSString *)key;
+ (BOOL)storeSecureValue:(NSString *)value forKey:(NSString *)key;

@end
