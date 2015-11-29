//
//  UserInfo.m
//  Code4App
//
//  Created by Sniper on 15/11/28.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

//检查用户名是否完整（包含服务器地址）
- (NSString *)username
{
    if ([_username hasSuffix:kHostName]) {
        return _username;
    }
    else {
        return [_username stringByAppendingFormat:@"@%@", @"admin"];
    }
}

@end
