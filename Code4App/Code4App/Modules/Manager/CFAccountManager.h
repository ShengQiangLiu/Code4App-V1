//
//  CFAccountManager.h
//  Code4App
//
//  Created by Sniper on 15/11/28.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;

@interface CFAccountManager : NSObject

@property (nonatomic, strong) UserInfo *user;

+ (instancetype)sharedManager;

- (void)resetUser;
- (BOOL)isLogin;

@end
