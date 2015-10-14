//
//  ViewController.m
//  XMPP_DEMO_QQ
//
//  Created by huchunyuan on 15/10/13.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//

#import "ViewController.h"
#import "XMPPManager.h"

@interface ViewController ()<XMPPStreamDelegate>
/** 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *userName;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *uesrPass;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildXMPP];
    
}
- (void)buildXMPP{
    // 设置代理
    [[XMPPManager shardManager].xmppSteam addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //
    
}

/** 登陆 */
- (IBAction)loginAction:(UIButton *)sender {
    [[XMPPManager shardManager] connectToServerByLoginWithUserName:self.userName.text Password:self.uesrPass.text];
}

/** 注册 */
- (IBAction)registerAction:(UIButton *)sender {
    
}


#pragma mark - XMPPDelegate
/** 验证登陆成功 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    // 设置登陆状态为有效的
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[XMPPManager shardManager].xmppSteam sendElement:presence];
    
    [self performSegueWithIdentifier:@"friend_id" sender:nil];
}

/** 验证登陆失败 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
