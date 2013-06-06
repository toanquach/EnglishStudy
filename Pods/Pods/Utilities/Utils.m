//
//  Utils.m
//  Abilene
//
//  Created by Toan Quach on 6/3/13.
//
//

#import "Utils.h"

@implementation Utils

+ (BOOL)isNumeric:(NSString*) checkText
{
	NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
	
	NSNumber* number = [numberFormatter numberFromString:checkText];
	
	if (number != nil)
    {
		//NSLog(@"%@ is numeric", checkText);
		return true;
	}
	
	//NSLog(@"%@ is not numeric", checkText);
    return false;
}

+ (BOOL)validateEmail:(NSString *)email

{
    NSString *emailRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    
    NSPredicate *emailStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailStr evaluateWithObject:email];
}
@end
