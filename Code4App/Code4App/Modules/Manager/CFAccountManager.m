//
//  CFAccountManager.m
//  Code4App
//
//  Created by Sniper on 15/11/28.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFAccountManager.h"
#import "KeychainItemWrapper.h"
#import "UserInfo.h"

@implementation CFAccountManager
+ (instancetype)sharedManager
{
    static CFAccountManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CFAccountManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _user = [[UserInfo alloc] init];
        
        KeychainItemWrapper *itemWrapper = [self keychainItemWrapper];
        _user.username = [itemWrapper objectForKey:(__bridge id)(kSecAttrAccount)];
        _user.password = [itemWrapper objectForKey:(__bridge id)(kSecValueData)];
    }
    
    return self;
}

- (void)setUser:(UserInfo *)user
{
    _user = user;
    KeychainItemWrapper *itemWrapper = [self keychainItemWrapper];
    [itemWrapper setObject:user.username forKey:(__bridge id)(kSecAttrAccount)];
    [itemWrapper setObject:user.password forKey:(__bridge id)(kSecValueData)];
}

- (void)resetUser
{
    _user = nil;
    KeychainItemWrapper *itemWrapper = [self keychainItemWrapper];
    [itemWrapper resetKeychainItem];
}

- (KeychainItemWrapper *)keychainItemWrapper
{
    return [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChainIdentifier accessGroup:nil];
}

- (BOOL)isLogin
{
    if (_user.username.length && _user.password.length) {
        return YES;
    }
    
    return NO;
}
@end
