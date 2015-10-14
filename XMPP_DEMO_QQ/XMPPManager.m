//
//  XMPPManager.m
//  XMPP_DEMO_QQ
//
//  Created by huchunyuan on 15/10/13.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//

#import "XMPPManager.h"

/** 遵循协议 */
@interface XMPPManager ()<XMPPStreamDelegate>
/** 用于存储传过来的密码 */
@property (nonatomic,strong) NSString *passWord;
@end

@implementation XMPPManager
/** 单例 */
+ (XMPPManager *)shardManager{
    static XMPPManager *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [[XMPPManager alloc] init];
    });
    return audioManager;
}

/** 重写init方法 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化通信管道
        self.xmppSteam = [[XMPPStream alloc] init];
        // 设置服务器地址
        self.xmppSteam.hostName = kHostName;
        // 设置端口号
        self.xmppSteam.hostPort = kHostPort;
        // 设置代理
        [self.xmppSteam addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // 花名册本地存储
        XMPPRosterCoreDataStorage *rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
        // 初始化花名册
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:rosterStorage dispatchQueue:dispatch_get_main_queue()];
        // 激活
        [self.xmppRoster activate:self.xmppSteam];
        
        // 获取本地存储
        XMPPMessageArchivingCoreDataStorage * messageStroage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        // 初始化消息
        self.xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:messageStroage dispatchQueue:dispatch_get_main_queue()];
        // 激活通信管道
        [self.xmppMessageArchiving activate:self.xmppSteam];
        // 获取聊天信息上下文
        self.context = messageStroage.mainThreadManagedObjectContext;
    }
    return self;
}


/** 连接服务器 */
- (void)connectToServerWithUserName:(NSString *)userName{
    
    
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:kDomin resource:kResource];
    self.xmppSteam.myJID = jid;
    
    
    // 如果在登陆状态就断开
    if ([self.xmppSteam isConnected]) {
        [self.xmppSteam disconnect];
    }
    
    
    
    NSError *error = nil;
    [self.xmppSteam connectWithTimeout:10 error:&error];
    
    if (error) {
        NSLog(@"--- Server Error Is : %@ ---",error);
    }
    
}


#define mark XMPPSteamDelegate

/** 手动登陆 */
- (void)connectToServerByLoginWithUserName:(NSString *)userName Password:(NSString *)password{
    // 保存密码
    self.passWord = password;
    [self connectToServerWithUserName:userName];
}




/** 连接成功 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSError *error = nil;
    [self.xmppSteam authenticateWithPassword:self.passWord error:&error];
    
    if (error) {
        NSLog(@"--- Connect Error Is : %@ ---",error);
    }
}

/** 连接失败 */
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{

}

/** 连接超时 */
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    
}


@end
