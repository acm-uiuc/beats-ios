//
//  ACMUserManager.m
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 9/1/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import "ACMUserManager.h"
#import "KeychainItemWrapper.h"

@implementation ACMUserManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static ACMUserManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[ACMUserManager alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if(self = [super init]) {
        self.session = @"";
    }
    return self;
}

#pragma mark -
#pragma mark Getters

- (NSString *)username {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"BeatsByACMUserData" accessGroup:nil];
    if([keychain objectForKey:(__bridge id)kSecAttrAccount]) {
        return [keychain objectForKey:(__bridge id)kSecAttrAccount];
    }
    else {
        return nil;
    }
}

- (NSString *)password {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"BeatsByACMUserData" accessGroup:nil];
    if([keychain objectForKey:(__bridge id)kSecValueData]) {
        return [keychain objectForKey:(__bridge id)kSecValueData];
    }
    else {
        return nil;
    }
}

#pragma mark -
#pragma mark Keychain Methods

- (void)setUsername:(NSString *)username password:(NSString *)password {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"BeatsByACMUserData" accessGroup:nil];
    [keychain setObject:username forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:password forKey:(__bridge id)kSecValueData];
}

- (void)resetKeychain; {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"BeatsByACMUserData" accessGroup:nil];
    [keychain resetKeychainItem];
}

@end
