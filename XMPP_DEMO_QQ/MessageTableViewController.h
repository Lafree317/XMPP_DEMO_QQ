//
//  MessageTableViewController.h
//  XMPP_DEMO_QQ
//
//  Created by huchunyuan on 15/10/14.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"

@interface MessageTableViewController : UITableViewController
@property (strong, nonatomic) XMPPJID *jid;
@end
