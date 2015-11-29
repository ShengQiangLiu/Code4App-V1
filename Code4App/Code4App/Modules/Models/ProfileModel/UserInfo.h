//
//  UserInfo.h
//  Code4App
//
//  Created by Sniper on 15/11/28.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) XMPPJID *jid;
@end
