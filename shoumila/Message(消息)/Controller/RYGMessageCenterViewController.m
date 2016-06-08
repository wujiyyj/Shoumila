//
//  RYGMessageCenterViewController.m
//  消息中心界面
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageCenterViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "RYGHttpRequest.h"
#import "RYGMessageCenterTableViewCell.h"
#import "RYGDateUtility.h"
#import "RYGMessageRequestParam.h"
#import "RYGHttpRequest.h"
#import "RYGMessageCenterInfosModel.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGVirtualAccountViewController.h"
#import "RYGUserCenterViewController.h"
#import "RYGPersonPackageViewController.h"
#import "RYGPackageViewController.h"
#import "RYGPublishViewController.h"
#import "RYGViewController.h"
#import "AppDelegate.h"

@interface RYGMessageCenterViewController  ()<UITableViewDataSource, UITableViewDelegate>

// 消息中心列表
@property(nonatomic,strong)UITableView *messageCenterTableView;
// 下一页的标识
@property(nonatomic,strong)NSString *next;
// 消息的数据
@property(nonatomic,strong)NSMutableArray *messageCenterList;
// 是否有更多数据
@property(nonatomic,assign) BOOL isMoreData;
// 行高
@property(nonatomic,strong)NSMutableArray *rowHeights;
// 存储时间
@property (nonatomic,strong) NSMutableDictionary *dicTime;
// 是否显示时间0不显示，1显示
@property (nonatomic,strong) NSMutableArray *showTimes;

@property(nonatomic,strong)RYGMessageCenterInfosModel *messageCenterInfosModel;

@end

@implementation RYGMessageCenterViewController

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息中心";
    _messageCenterTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    _messageCenterTableView.delegate = self;
    _messageCenterTableView.dataSource = self;
    _messageCenterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageCenterTableView.backgroundColor = ColorRankMyRankBackground;
    [self.view addSubview:_messageCenterTableView];
    
    __weak __typeof(&*self)weakself = self;
    [self.messageCenterTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [self.messageCenterTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _rowHeights = [[NSMutableArray alloc]init];
    _showTimes = [[NSMutableArray alloc]init];
    _dicTime = [[NSMutableDictionary alloc]init];
    [self aRefresh];
    
    [MobClick beginLogPageView:@"消息中心"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"消息中心"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"RYGWeekRankingViewController");
}

#pragma mark- private method

#pragma mark 初期刷新，下拉刷新

- (void)aRefresh {
    _messageCenterList = [NSMutableArray array];
    _next = 0;
    _isMoreData = YES;
    [self loadData];
}

- (void)loadData {
    _messageCenterList = [[NSMutableArray alloc]init];

    [self.messageCenterTableView reloadData];
    RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
    messageRequestParam.next = _next;
    [RYGHttpRequest postWithURL:Message_Center params:messageRequestParam.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.messageCenterInfosModel = [RYGMessageCenterInfosModel objectWithKeyValues:dic];
        [self.messageCenterList addObjectsFromArray:self.messageCenterInfosModel.datas];
        _next = self.messageCenterInfosModel.next;
        // 没有加载更多
        if (self.messageCenterInfosModel.page_is_last || [self.messageCenterInfosModel.page_is_last isEqualToString:@"0"]) {
            _isMoreData = NO;
        }
        [self.messageCenterTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 更新排行榜的列表

- (void)reloadRankingTable {
    // 是否登录
    [self.messageCenterTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.messageCenterTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.messageCenterTableView reloadData];
}

#pragma mark-
#pragma mark UITableViewDataSource UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.messageCenterList && self.messageCenterList.count>0) {
        return self.messageCenterList.count;
    }
    return 0;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *rowHeight;
    if (indexPath.row < [self.rowHeights count]) {
        rowHeight = [self.rowHeights objectAtIndex:indexPath.row];
    }
    if (rowHeight) {
        return [rowHeight floatValue];
    }
    
    RYGMessageCenterModel *model = [self.messageCenterList objectAtIndex:indexPath.row];
    
    NSMutableString *content = [[NSMutableString alloc]init];
    
    for (int i = 0; i < model.data.content.count; i++) {
        RYGConetentModel *conentModel = [model.data.content objectAtIndex:i];
        [content appendString:conentModel.text];
    }
    
    NSString *strDate = model.in_time;
    
    CGFloat cellHeight = 15;
    if ([self.dicTime objectForKey:strDate]) {
        [self.showTimes addObject:@"0"];
    }
    else {
        CGSize dateSize = RYG_TEXTSIZE(@"昨天", [UIFont systemFontOfSize:10]);
        cellHeight += dateSize.height + 10;
        [self.dicTime setObject:strDate forKey:strDate];
        [self.showTimes addObject:@"1"];
    }
    if (content.length > 0) {
        CGSize labelSize = RYG_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:14.0f], CGSizeMake((self.view.width - 50), FLT_MAX), NSLineBreakByTruncatingTail);
        
        cellHeight = labelSize.height + 20 + cellHeight;
        
        [self.rowHeights addObject:[NSNumber numberWithFloat:cellHeight]];
        return cellHeight;
    }
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messageCenterTableViewCell=@"messageCenterTableViewCell";
    RYGMessageCenterTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:messageCenterTableViewCell];
    if (!cell) {
        cell=[[RYGMessageCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCenterTableViewCell];
    }
    NSString *isShow = [self.showTimes objectAtIndex:indexPath.row];
    if (self.messageCenterList.count > 0) {
        [cell updateCell:[self.messageCenterList objectAtIndex:indexPath.row] showTime:isShow];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGMessageCenterModel *model = [self.messageCenterList objectAtIndex:indexPath.row];
    
    // 提现;连红;排名类（周排行）排上提升（有变化提示）   跳转“我的账户”
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"12"] ) {
        RYGVirtualAccountViewController *accountViewController = [[RYGVirtualAccountViewController alloc]init];
        [self.navigationController pushViewController:accountViewController animated:YES];
    }
    // 购买   跳转“TA个人主页”
    else if ([model.type isEqualToString:@"2"])
    {
        RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
        otherPersonViewController.userId = model.data.userid;
        [self.navigationController pushViewController:otherPersonViewController animated:YES];
    }
    /*
    // 购买套餐成功;跳转“TA套餐主页”;套餐   跳转“TA套餐主页”
    else if ([model.type isEqualToString:@"3"] || [model.type isEqualToString:@"4"] ) {
        RYGPersonPackageViewController *personPackageViewController = [[RYGPersonPackageViewController alloc]init];
        personPackageViewController.userid = model.data.userid;
       [self.navigationController pushViewController:personPackageViewController animated:YES];
    }
    */
    // 别人购买我的;别人购买我的 成功;别人购买我的 失败;  跳转“我的套餐主页”
    else if ([model.type isEqualToString:@"5"] || [model.type isEqualToString:@"6"] || [model.type isEqualToString:@"7"] ) {
        RYGPackageViewController *packageViewController = [[RYGPackageViewController alloc]init];
        [self.navigationController pushViewController:packageViewController animated:YES];
    }
    // 推荐比赛结束;   跳转“发布的个人帖子详情页”
    else if ([model.type isEqualToString:@"8"])
    {
        RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
        detailViewController.feed_id = model.data.feed_id;
        detailViewController.cat = model.data.cat;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    // 跳转到“我的”页面
    else if([model.type isEqualToString:@"10"] || [model.type isEqualToString:@"11"])
    {
        RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
        RYGUserInfoModel *userInfoModel = [RYGUtility getUserInfo];
        otherPersonViewController.userId = userInfoModel.userid;
        [self.navigationController pushViewController:otherPersonViewController animated:YES];
    }
    // 跳转到“首页”
    else if([model.type isEqualToString:@"9"]) {
        RYGViewController *homeViewControlView = ((AppDelegate *)[UIApplication sharedApplication].delegate).viewController;
        ((UITabBarController*)homeViewControlView.centerVc).selectedIndex = 0;
    }
}

@end
