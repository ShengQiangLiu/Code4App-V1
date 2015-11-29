//
//  Constant.h
//  WaO
//
//  Created by admin on 15/9/20.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//


typedef NS_ENUM(NSUInteger, ServerState) {
    kDefaultServerState = 0,    //默认状态
    kLoginServerState,          //登录状态
    kRegisterServerState,       //注册状态
    kMessageServerState,        //消息状态
};

typedef NS_ENUM(NSUInteger, RequestErrorCode) {
    kRequestOK = 0,
    kRequestTimeout,
    kRequestError,
};

extern const NSInteger kTimeoutLength;

extern NSString * const kKeyChainIdentifier;

extern NSString *const kHostName;
