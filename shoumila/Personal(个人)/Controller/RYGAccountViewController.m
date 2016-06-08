//
//  RYGAccountViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAccountViewController.h"
#import "RYGAccountTableViewCell.h"
#import "RYGOrderDetailViewController.h"
#import "RYGAllListParam.h"
#import "RYGHttpRequest.h"
#import "RYGOrderListModel.h"
#import "MJRefresh.h"

@interface RYGAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* mTableView;
}

@property(nonatomic,strong) RYGOrderListModel *orderListModel;
@property(nonatomic,strong) NSMutableArray *orderListArray;
@property(nonatomic,assign) BOOL hasMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGAccountViewController

-(void)loadView{
    [super loadView];
    _orderListArray = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"我的订单"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"我的订单"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = ColorRankMyRankBackground;
    
    
    [self createMainTablView];
    
    [self aRefresh];
//    [self loadNewData];
}

- (void)loadNewData{
    RYGAllListParam *allListParam = [RYGAllListParam param];
    allListParam.count = @"5";
    allListParam.next = _next;
    [RYGHttpRequest postWithURL:OrderPay_list params:allListParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.orderListModel = [RYGOrderListModel objectWithKeyValues:dic];
        [_orderListArray addObjectsFromArray:self.orderListModel.datas];
        
        _next = self.orderListModel.next;
        // 没有加载更多
        if ([self.orderListModel.page_is_last isEqualToString:@"0"]) {
            _hasMoreData = YES;
        }
        else {
            _hasMoreData = NO;
        }
        [mTableView.header setState:MJRefreshHeaderStateIdle];
        
        if (_orderListArray.count == 0) {
            mTableView.hidden = YES;
            [self createEmptyView];
        }
        else {
            [self reloadData];
            mTableView.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData
{
    [mTableView.footer endRefreshing];
    if (!_hasMoreData) {
        [mTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [mTableView reloadData];
    
}

- (void)createEmptyView{
    UIImageView* emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 135, 80, 80)];
    emptyImageView.centerX = SCREEN_WIDTH/2;
    emptyImageView.image = [UIImage imageNamed:@"default_picture"];
    [self.view addSubview:emptyImageView];
    
    UILabel* emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 235, 150, 20)];
    emptyLabel.centerX = SCREEN_WIDTH/2;
    emptyLabel.text = @"您寻找的内容不存在";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = ColorSecondTitle;
    emptyLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:emptyLabel];
}

- (void)createMainTablView {
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [mTableView registerClass:[RYGAccountTableViewCell class] forCellReuseIdentifier:@"Cell"];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakself = self;
    [mTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [mTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadNewData];
    } noMoreDataTitle:@"没有更多数据"];
    [self.view addSubview:mTableView];
}

#pragma mark 初期刷新，下拉刷新
- (void)aRefresh {
    _orderListArray = [[NSMutableArray alloc]init];
    _next = @"0";
    _hasMoreData = YES;
    [self loadNewData];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _orderListArray.count-1) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYGAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
//    //修改UITableview服用重叠的问题
//    for(UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }

    cell.orderPayModel = [_orderListArray objectAtIndex:indexPath.section];
    
    UIView* toplineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    toplineView.backgroundColor = ColorLine;
    [cell.contentView addSubview:toplineView];
    
//    UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 187.5, SCREEN_WIDTH, 0.5)];
//    bottomlineView.backgroundColor = ColorLine;
//    [cell.contentView addSubview:bottomlineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYGOrderDetailViewController* orderDetailVC = [[RYGOrderDetailViewController alloc]init];
    orderDetailVC.order_no = [[_orderListArray objectAtIndex:indexPath.section] valueForKey:@"order_no"];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
