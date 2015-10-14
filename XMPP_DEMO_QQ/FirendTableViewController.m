//
//  FirendTableViewController.m
//  XMPP_DEMO_QQ
//
//  Created by huchunyuan on 15/10/14.
//  Copyright (c) 2015年 Lafree. All rights reserved.
//

#import "FirendTableViewController.h"
#import "XMPPManager.h"
#import "MessageTableViewController.h"

@interface FirendTableViewController ()<XMPPRosterDelegate>

@property (nonatomic , strong) NSMutableArray *friendListArray;

@end

@implementation FirendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[XMPPManager shardManager].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.friendListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell_id" forIndexPath:indexPath];
    
    // 从数组中取出对应的jid
    XMPPJID *jid = self.friendListArray[indexPath.row];
    cell.textLabel.text = jid.user;
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewController *message = [[MessageTableViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
    message.jid = self.friendListArray[indexPath.row];
    [self showViewController:message sender:nil];
}

#pragma mark -XMPPRoster Delegate
/** 这个检索好友列表 */
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    NSLog(@"%@",item);

    // 取出jid
    XMPPJID *jid = [XMPPJID jidWithString:[[item attributeForName:@"jid"] stringValue]];
    [self.friendListArray addObject:jid];
    [self.tableView reloadData];
}
- (NSMutableArray *)friendListArray{
    if (!_friendListArray) {
        _friendListArray = [NSMutableArray array];
    }
    return _friendListArray;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
