//
//  RYGMessageViewController.m
//  消息
//
//  Created by jiaocx on 15/8/18.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageViewController.h"
#import "MJRefresh.h"
#import "UMFeedbackViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "RYGMessageTableViewCell.h"
#import "RYGMessageReplyMeViewController.h"
#import "RYGMessageReferToMeViewController.h"
#import "RYGMessagePraiseMeViewController.h"
#import "RYGAttendedPersonDynamicMessageViewController.h"
#import "RYGMessageCenterViewController.h"
#import "RYGMessageRequestParam.h"
#import "RYGHttpRequest.h"
#import "RYGMessageInfosModel.h"
#import "RYGMessageManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AppDelegate.h"

@interface RYGMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *messageTableView;
@property(nonatomic,strong)NSMutableArray *messageList;
// 下一页的标识
@property(nonatomic,strong)NSString *next;
@property(nonatomic,strong)NSString *pageLast;
// 是否有更多数据
@property(nonatomic,assign) BOOL isMoreData;

@property(nonatomic,strong)RYGMessageInfosModel *messageInfosModel;

@end

@implementation RYGMessageViewController

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = nil;
    
    _messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableView.backgroundColor = ColorRankBackground;
    [self.view addSubview:self.messageTableView];
    
    __weak __typeof(&*self)weakself = self;
    [self.messageTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [self.messageTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    }];
    
    // 向消息中心注册侦听所需的消息
    [self signUpToNotificationCenterReceiveNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"消息"];
    
    // 是否登录
    if (![RYGUtility validateUserLogin])
    {
        return;
    }
    else {
        // 从本地获取数据
        [self aRefresh];
        AppDelegate* myDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [myDelegate updateMessageItem];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"消息"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初期刷新，下拉刷新
- (void)aRefresh {
    // 是否登录
    if ([RYGUtility validateUserLogin])
    {
        _next = @"0";
        _isMoreData = YES;
        RYGMessageManager *shareMessage = [RYGMessageManager shareMessageManager];
        [shareMessage messageSendAsynchronousRequest];
    }
}

- (void)signUpToNotificationCenterReceiveNotifications
{
    RYGMessageManager *shareMessage = [RYGMessageManager shareMessageManager];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMessage:)
                                                 name:kRYGMessageRefreshNotification
                                               object:shareMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)refreshMessage:(NSNotification *)notification {
    [self retriveMessagePageLocalCacheData];
}

/**
 *  从本地缓存中获取初始化数据
 */
- (void)retriveMessagePageLocalCacheData
{
    _messageList = [NSMutableArray array];
    _next = @"1";
    _pageLast = [[NSUserDefaults standardUserDefaults]objectForKey:kRYGMessagePageLast];
    _isMoreData = YES;
    
    NSArray *moduleInfoArray = [[RYGDataCache sharedInstance] dataInFile:kRYGMessageModelFileName];
    [_messageList addObjectsFromArray:moduleInfoArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageList addObjectsFromArray:self.messageInfosModel.datas];
        _next = self.messageInfosModel.next;
        // 没有加载更多
        if (nil == _pageLast || [_pageLast isEqualToString:@"0"] || [_pageLast isEqualToString:@"1"]) {
            _isMoreData = NO;
        }
        [self.messageTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    });
}

- (void)loadData {
    // 是否登录
    if ([RYGUtility isLogin]) {
        RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
        messageRequestParam.next = _next;
        [RYGHttpRequest postWithURL:Message_List params:messageRequestParam.keyValues success:^(id json) {
            NSMutableDictionary *dic = [json valueForKey:@"data"];
            self.messageInfosModel = [RYGMessageInfosModel objectWithKeyValues:dic];
            [self.messageList addObjectsFromArray:self.messageInfosModel.datas];
            _next = self.messageInfosModel.next;
            // 没有加载更多
            if (self.messageInfosModel.page_is_last || [self.messageInfosModel.page_is_last isEqualToString:@"0"]) {
                _isMoreData = NO;
            }
            [self.messageTableView.header setState:MJRefreshHeaderStateIdle];
            [self reloadRankingTable];
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark 更新排行榜的列表

- (void)reloadRankingTable {
    [self.messageTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.messageTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.messageTableView reloadData];
}

#pragma mark-
#pragma mark UITableViewDataSource UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.messageList && self.messageList.count>0) {
        return self.messageList.count;
    }
    return 0;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MessageTableViewCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messageTableViewCellCellIdentify=@"MessageTableViewCellIdentify";
    RYGMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:messageTableViewCellCellIdentify];
    if (!cell) {
        cell=[[RYGMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageTableViewCellCellIdentify];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    if (self.messageList.count > 0) {
        cell.messageModel = [self.messageList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGMessageBaseModel *messageModel =[self.messageList objectAtIndex:indexPath.row];
    // 回复我的消息
    if ([messageModel.mtype isEqualToString:@"1"]) {
        RYGMessageReplyMeViewController *messageReplyMeViewController = [[RYGMessageReplyMeViewController alloc]init];
        [self.navigationController pushViewController:messageReplyMeViewController animated:YES];
    }
    // 提到我的
    else if([messageModel.mtype isEqualToString:@"2"]){
        RYGMessageReferToMeViewController *messageReferToMeViewController = [[RYGMessageReferToMeViewController alloc]init];
        [self.navigationController pushViewController:messageReferToMeViewController animated:YES];
    }
    // 赞过我的
    else if([messageModel.mtype isEqualToString:@"3"]){
        RYGMessagePraiseMeViewController *messagePraiseMeViewController = [[RYGMessagePraiseMeViewController alloc]init];
        [self.navigationController pushViewController:messagePraiseMeViewController animated:YES];
    }
    // 消息中心
    else if([messageModel.mtype isEqualToString:@"4"]) {
        RYGMessageCenterViewController *messageCenterViewController = [[RYGMessageCenterViewController alloc]init];
        [self.navigationController pushViewController:messageCenterViewController animated:YES];
    }
    // 收米小助手
    else if ([messageModel.mtype isEqualToString:@"5"]) {
        [self.navigationController pushViewController:[UMFeedbackViewController new]
                                             animated:YES];
    }
    // 关注人的动态消息
    else  {
        RYGMessageBaseModel*model = [self.messageList objectAtIndex:indexPath.row];
        RYGAttendedPersonDynamicMessageViewController *attendedPersonDynamicMessageViewController = [[RYGAttendedPersonDynamicMessageViewController alloc]init];
        attendedPersonDynamicMessageViewController.messageTitle = model.user_name;
        attendedPersonDynamicMessageViewController.from_id = model.userid;
        [self.navigationController pushViewController:attendedPersonDynamicMessageViewController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGMessageBaseModel *messageModel =[self.messageList objectAtIndex:indexPath.row];
    // 回复我的消息,提到我的,赞过我的,消息中心,收米小助手
    if ([messageModel.mtype isEqualToString:@"1"] || [messageModel.mtype isEqualToString:@"2"] || [messageModel.mtype isEqualToString:@"3"] || [messageModel.mtype isEqualToString:@"4"] || [messageModel.mtype isEqualToString:@"5"]) {
        return NO;
    }
    // 关注人的动态消息
    else  {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGMessageBaseModel *messageModel =[self.messageList objectAtIndex:indexPath.row];
    [self deleteAttentionMessage:messageModel indexPath:indexPath];

}

- (void)deleteAttentionMessage:(RYGMessageBaseModel *)messageModel indexPath:(NSIndexPath *)indexPath{
        RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
        messageRequestParam.userid = messageModel.userid;
    __weak __typeof(self) weakSelf = self;
        [RYGHttpRequest postWithURL:Message_AttentionDel params:messageRequestParam.keyValues success:^(id json) {
            [weakSelf.messageList removeObjectAtIndex:indexPath.row];
            [weakSelf.messageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.messageTableView endUpdates];
            AppDelegate* myDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [myDelegate updateMessageItem];

        } failure:^(NSError *error) {
            
        }];
}

#pragma mark - UIApplicationDidBecomeActiveNotification

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if ([RYGUtility isLogin]) {
        [[RYGMessageManager shareMessageManager] messageSendAsynchronousRequest];
    }
}

@end
