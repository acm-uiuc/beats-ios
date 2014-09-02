//
//  ACMUserManager.h
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 9/1/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACMUserManager : NSObject
@property (nonatomic, strong) NSString *session;

@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *password;

+ (instancetype)sharedInstance;

#pragma mark -
#pragma mark Keychain Methods

- (void)setUsername:(NSString *)username password:(NSString *)password;
- (void)resetKeychain;

@end
