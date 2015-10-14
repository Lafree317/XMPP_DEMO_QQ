//
//  MessageTableViewController.m
//  XMPP_DEMO_QQ
//
//  Created by huchunyuan on 15/10/14.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//

#import "MessageTableViewController.h"

@interface MessageTableViewController ()<XMPPStreamDelegate>
@property (strong, nonatomic) NSMutableArray *messageListArray;
@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[XMPPManager shardManager].xmppSteam addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 创建测试发送按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStyleDone) target:self action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self updateMessage];
    
    
}
#pragma mark XMPPStreamDelegate
/** 发送消息方法 */
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    [self updateMessage];
}

/** 接收消息 */
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    [self updateMessage];
}

/** 获取聊天消息 */
- (void)updateMessage{
    
    NSManagedObjectContext *context = [XMPPManager shardManager].context;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    // bareJidStr streamBareJidStr
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ AND streamBareJidStr = %@", self.jid,[XMPPManager shardManager].xmppSteam.myJID.bareJID];
    
    [fetchRequest setPredicate:predicate];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"你怎么了?%@",error);
    }
    
    
    [self.messageListArray removeAllObjects];
    [self.messageListArray addObjectsFromArray:fetchedObjects];
    
    
    
    
    // 刷新
    [self.tableView reloadData];
    
    
    if (self.messageListArray.count > 0) {
        
        // 让消息始终从最下面往上推
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageListArray.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}
- (void)sendMessage{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.jid];
    [message addBody:@"哈哈哈"];
    
    [[XMPPManager shardManager].xmppSteam sendElement:message];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return self.messageListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"message"];
    }
    XMPPMessageArchiving_Message_CoreDataObject *message = self.messageListArray[indexPath.row];
    
    // 判断谁发送的消息
    if (message.isOutgoing) {
        cell.textLabel.text = message.body;
        cell.detailTextLabel.text = @"";
    }else{
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = message.body;
    }
    
    return cell;
}

- (NSMutableArray *)messageListArray{
    if (!_messageListArray) {
        _messageListArray = [[NSMutableArray alloc] init];
    }
    return _messageListArray;
}

@end
