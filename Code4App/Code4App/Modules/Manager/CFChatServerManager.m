//
//  CFChatServerManager.m
//  Code4App
//
//  Created by Sniper on 15/11/28.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//
/*
一、XMPP服务器：
 采用 Openfire
 
二、XMPP协议：
 1、XMPP 在TCP基础上使用XML流进行通信
 
 2、其中三种常用的XML节点：
 * Message：发送消息，点对对推送机制，to表示接受者
 * Presence：广播或订阅机制，一对多，登录信息
 * IQ（Info/Query）：消息查询，请求回应机制
 
 3、XMPP-iPhone的核心类
 * XMPPStream：最重要的类，通过它进行所有交互
 * XMPPJID：JID（Jabber Identifier），用户ID
 * XMPPIQ 继承自XMPPElement
 * XMPPMessage 继承自XMPPElement
 * XMPPPresence 继承自XMPPElement
 * 也可以实现自己的需求继承于XMPPElement

三、XMPP工作流程：
 1、配置 stream 对象
 2、连接服务器
 3、登录认证
 4、消息发送、接收

四、常见问题
1、登录失败: <failure xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><not-authorized></not-authorized></failure>
 这个需要检查jid中的域设置的是否和openfire设置是否一致
 
*/



#import "CFChatServerManager.h"
#import "Constant.h"
#import "UserInfo.h"
#import "CFAccountManager.h"
#import "UserInfo.h"


@interface CFChatServerManager () <XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;
    XMPPReconnect *_xmppReconnect;              //重连模块
    XMPPRoom *_xmppRoom;                        //多人聊天
    XMPPRoster  *_xmppRoster;                   //通讯录
    XMPPvCardAvatarModule *_xmppAvatarModule;   //头像模块
    XMPPvCardTempModule *_xmppvCardModule;      //电子身份模块
    XMPPCapabilities *_xmppCapabilities;        //
    XMPPMessageArchiving *_xmppMessageArchiving;    //消息

    UserInfo *_user;    //当前操作用户

    ServerState _serverState;
}
@end

@implementation CFChatServerManager
+ (instancetype)sharedManager
{
    static CFChatServerManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CFChatServerManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self comfigureStream];
    }
    
    return self;
}

//  1、配置 stream 对象
- (void)comfigureStream
{
    _xmppStream = [[XMPPStream alloc] init];
    _xmppStream.hostName = kHostName;
    _xmppStream.hostPort = 5222;
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self loadModules];
    
}

// 加载常用模块
- (void)loadModules
{
    
    //重连模块
    _xmppReconnect = [[XMPPReconnect alloc] init];
    [_xmppReconnect activate:_xmppStream];
    
    // 使用 CoreData 管理通讯录
    XMPPRosterCoreDataStorage *rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    // 花名册
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:rosterStorage];
    // 自动获取通讯录
    _xmppRoster.autoFetchRoster = YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [_xmppRoster activate:_xmppStream];
    
    // 电子名片
    XMPPvCardCoreDataStorage *vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppvCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:vCardStorage];
    [_xmppvCardModule activate:_xmppStream];
    
    // 头像
    _xmppAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardModule];
    [_xmppAvatarModule activate:_xmppStream];
    
    
}

// 2、连接服务器
- (void)connect
{
    _xmppStream.myJID = [XMPPJID jidWithString:[CFAccountManager sharedManager].user.username resource:@"mChat"];
    [_xmppStream connectWithTimeout:kTimeoutLength error:nil];
}

- (void)disconnect
{
    [_xmppStream disconnect];
}


//连接服务器
- (void)_connectWithState:(ServerState)state
{
    NSError *error;
    if(![_xmppStream connectWithTimeout:kTimeoutLength error:&error]) {
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
        return;
    }
    
    // 连接服务器，并设置为注册状态
    _serverState = state;
}



#pragma mark - 登录&注册
//用户登录
- (void)_loginWithPassword:(NSString *)password
{
    NSLog(@"password : %@", password);
    NSError *error;
    if (![_xmppStream authenticateWithPassword:password error:&error]) {
        NSLog(@"认证调用失败: %@", error);
    }
}

- (void)login:(UserInfo *)user
{
    _user = user;
    NSLog(@"%@", user.username);
    _xmppStream.myJID = [XMPPJID jidWithString:user.username resource:@"mChat"];
    
    if ([_xmppStream isConnected]) {
        [self _loginWithPassword:user.password];
    }
    else {
        [self _connectWithState:kLoginServerState];
    }

}

- (void)logout
{
    
}

- (void)online
{
    
}

- (void)offline
{
    
}

- (void)_registerWithPassword:(NSString *)password
{
    //服务器不支持带内注册
    if (!_xmppStream.supportsInBandRegistration) {
        NSLog(@"In Band Registration Not Supported");
        return;
    }
    
    NSError *error;
    //使用密码注册用户
    if (![_xmppStream registerWithPassword:password error:&error]) {
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    }
    
}



- (void)registerUser:(UserInfo *)user
{
    _user = user;
    _xmppStream.myJID = [XMPPJID jidWithString:user.username];
    
    //必须先连接才能注册
    if ([_xmppStream isConnected]) {
        //注册用户
        [self _registerWithPassword:user.password];
    }
    else {
        [self _connectWithState:kRegisterServerState];
    }

}

#pragma mark - 用户信息&好友管理
- (void)addFriend:(UserInfo *)user
{
    XMPPJID *jid = [XMPPJID jidWithString:user.username];
    [_xmppRoster addUser:jid withNickname:nil];
}

- (void)removeFriend:(UserInfo *)user
{
    XMPPJID *jid = [XMPPJID jidWithString:user.username];
    [_xmppRoster removeUser:jid];
}

//头像模块
- (XMPPvCardAvatarModule *)avatarModule
{
    return _xmppAvatarModule;
}

//好友存储
- (NSManagedObjectContext *)rosterContext
{
    XMPPRosterCoreDataStorage *storage = [XMPPRosterCoreDataStorage sharedInstance];
    return [storage mainThreadManagedObjectContext];
}

////名片存储
//- (NSManagedObjectContext *)vCardContext
//{
//    
//}
//
////消息存储
//- (NSManagedObjectContext *)messageContext
//{
//    
//}

#pragma mark - XMPPStreamDelegate
//服务器连接建立成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"服务器连接成功");
    switch (_serverState) {
        case kLoginServerState:
            [self _loginWithPassword:_user.password];
            break;
        case kRegisterServerState:
            [self _registerWithPassword:_user.password];
            break;
        default:
            break;
    }
    
}

//连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"连接超时");
}

//断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"连接断开：%@", error);
}

#pragma mark - Account
//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"用户注册成功");

}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"用户注册失败：%@", error);

}

//登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"用户登录成功");
}

//登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"用户登录失败: %@", error);
}

#pragma mark - Receive Message
//接收到信息请求
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSLog(@"Received IQ: %@", iq);
    return YES;
}

//接收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"Received Message%@", message);
}

//接收到上线信息
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //    if ([[presence type] isEqualToString:@"unsubscribe"]) {
    //        // 删除好友
    //        [_xmppRoster removeUser:presence.from];
    //    }
    //    else if ([[presence type] isEqualToString:@"subscribe"])
    //    {
    //        // 接收好友请求
    //        [_xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    //        // 拒绝好友请求
    //        [_xmppRoster rejectPresenceSubscriptionRequestFrom:presence.from];
    //    }
    //
    
    NSLog(@"Received Presence: %@", presence);
}

//接收错误
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    NSLog(@"Receive Error: %@", error);
}

#pragma mark - Send
//发送信息请求成功
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    NSLog(@"Send IQ: %@", iq);
}

//发送消息成功
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"Send Message: %@", message);
}

//发送在线信息成功
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    NSLog(@"Send Presence: %@", presence);
}

#pragma mark - Failure
//发送信息请求失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    NSLog(@"Fail To Send IQ: %@\nError: %@", iq, error);
}

//发送消息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"Fail To Send Message: %@\nError: %@", message, error);
}

//发送在线信息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
    NSLog(@"Fail To Send Presence: %@\nError: %@", presence, error);
}


@end















