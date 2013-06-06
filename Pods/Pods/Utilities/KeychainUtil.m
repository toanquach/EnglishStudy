//
//  KeychainUtil.m
//  YouPlusMobile
//
//  Created by Duong Anh Thi on 07/09/2012.
//  Copyright (c) 2012 Sutrix. All rights reserved.
//

#import "KeychainUtil.h"
#import <Security/Security.h>

@implementation KeychainUtil

// -------------------------------------------------------------------------
+ (NSString *)getSecureValueForKey:(NSString *)key 
{
    /*
     
     Return a value from the keychain
     
     */
    NSString *temp = nil;
    // Retrieve a value from the keychain
    NSDictionary *result  = [[[NSDictionary alloc] init] autorelease];
    NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecReturnAttributes, nil] autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, key, kCFBooleanTrue, nil] autorelease];
    NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
    
    // Check if the value was found
    OSStatus status = SecItemCopyMatching((CFDictionaryRef) query, (CFTypeRef *) &result);
    if (status != noErr) 
    {
        // Value not found
        temp = nil;
    } else 
    {
        // Value was found so return it
        NSString *value = (NSString *) [result objectForKey: (NSString *) kSecAttrGeneric];
        temp = value;
    }
    return temp;
}




// -------------------------------------------------------------------------
+ (BOOL)storeSecureValue:(NSString *)value forKey:(NSString *)key 
{
    /*
     
     Store a value in the keychain
     
     */
    
    // Get the existing value for the key
    NSString *existingValue = [self getSecureValueForKey:key];
    
    // Check if a value already exists for this key
    OSStatus status;
    if (existingValue) {
        // Value already exists, so update it
        NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, nil] autorelease];
        NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, key, nil] autorelease];
        NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
        status = SecItemUpdate((CFDictionaryRef) query, (CFDictionaryRef) [NSDictionary dictionaryWithObject:value forKey: (NSString *) kSecAttrGeneric]);
    } else {
        // Value does not exist, so add it
        NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrGeneric, nil] autorelease];
        NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, key, value, nil] autorelease];
        NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
        status = SecItemAdd((CFDictionaryRef) query, NULL);
    }
    
    // Check if the value was stored
    if (status != noErr) 
    {
        // Value was not stored
        return FALSE;
    } else 
    {
        // Value was stored
        return TRUE;
    }
}


@end
