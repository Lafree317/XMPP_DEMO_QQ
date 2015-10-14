//
//  XMPPManager.h
//  XMPP_DEMO_QQ
//
//  Created by huchunyuan on 15/10/13.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
/** 
 通讯管道
 通讯管道必须是唯一的
 */
@interface XMPPManager : NSObject

/** xmpp属性 */
@property (nonatomic, strong) XMPPStream *xmppSteam;

/** 花名册(好友列表) */
@property (nonatomic, strong) XMPPRoster *xmppRoster;

/** 聊天消息 */
@property (strong, nonatomic) XMPPMessageArchiving *xmppMessageArchiving;

/** 管理对象上下文(临时数据库) */
@property (strong, nonatomic) NSManagedObjectContext *context;

/** 手动登陆 */
- (void)connectToServerByLoginWithUserName:(NSString *)userName Password:(NSString *)password;

/** 单例 */
+ (XMPPManager *)shardManager;

/** 连接服务器 */
- (void)connectToServerWithUserName:(NSString *)userName;
@end
