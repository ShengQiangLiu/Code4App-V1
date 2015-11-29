//
//  CFChatServerManager.h
//  Code4App
//
//  Created by Sniper on 15/11/28.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;

@interface CFChatServerManager : NSObject
+ (instancetype)sharedManager;
- (void)connect;    //连接服务器
- (void)disconnect; //断开服务器连接

- (void)login:(UserInfo *)user; //登录服务器
- (void)logout;             //退出登录

- (void)online;             //上线
- (void)offline;            //下线

- (void)registerUser:(UserInfo *)user;      //用户注册

- (void)addFriend:(UserInfo *)user;
- (void)removeFriend:(UserInfo *)user;


- (XMPPvCardAvatarModule *)avatarModule;    //头像模块;
- (NSManagedObjectContext *)rosterContext;  //好友存储
- (NSManagedObjectContext *)vCardContext;   //名片存储
- (NSManagedObjectContext *)messageContext; //消息存储

@end
