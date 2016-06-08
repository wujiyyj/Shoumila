//
//  RYGAccountDetailViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAccountDetailViewController.h"
#import "RYGAllListParam.h"
#import "RYGHttpRequest.h"
#import "RYGUserMoneyModel.h"
#import "RYGUserMoneyLogModel.h"
#import "MJRefresh.h"

@interface RYGAccountDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* mainTableView;
}
@property(nonatomic,strong) RYGUserMoneyModel *moneyModel;
@property(nonatomic,strong) NSMutableDictionary *moneyLogDic;
@property(nonatomic,strong) NSMutableArray* moneyArray;
@property(nonatomic,assign) BOOL hasMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGAccountDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"帐户明细"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"帐户明细"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"账户明细";
    
    [self createMainView];
    
    [self aRefresh];
}

- (void)loadNewData{
    RYGAllListParam *allListParam = [RYGAllListParam param];
    allListParam.count = @"5";
    allListParam.next = _next;
    [RYGHttpRequest postWithURL:User_MoneyLog params:allListParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.moneyModel = [RYGUserMoneyModel objectWithKeyValues:dic];
        
        [_moneyArray addObjectsFromArray:self.moneyModel.datas];
        
        _next = self.moneyModel.next;
        // 没有加载更多
        if ([self.moneyModel.page_is_last isEqualToString:@"0"]) {
            _hasMoreData = YES;
        }
        else {
            _hasMoreData = NO;
        }
        [mainTableView.header setState:MJRefreshHeaderStateIdle];
        
        if (_moneyArray.count == 0 || _moneyArray == NULL) {
            [self createEmptyView];
            mainTableView.hidden = YES;
        }
        else {
            [self reloadData];
            mainTableView.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData
{
    [mainTableView.footer endRefreshing];
    if (!_hasMoreData) {
        [mainTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [mainTableView reloadData];
    
}

- (void)createEmptyView{
    UIImageView* emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 135, 80, 80)];
    emptyImageView.centerX = SCREEN_WIDTH/2;
    emptyImageView.image = [UIImage imageNamed:@"user_account_empty"];
    [self.view addSubview:emptyImageView];
    
    UILabel* emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 235, 150, 20)];
    emptyLabel.centerX = SCREEN_WIDTH/2;
    emptyLabel.text = @"没有相关记录";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = ColorSecondTitle;
    emptyLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:emptyLabel];
}


- (void)createMainView {
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    mainTableView.backgroundColor = ColorRankMyRankBackground;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = YES;
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakself = self;
    
    [mainTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [mainTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadNewData];
    } noMoreDataTitle:@"没有更多数据"];
    [self.view addSubview:mainTableView];
}

#pragma mark 初期刷新，下拉刷新
- (void)aRefresh {
    _moneyArray = [[NSMutableArray alloc]init];
    _next = @"0";
    _hasMoreData = YES;
    [self loadNewData];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _moneyArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    //修改UITableview服用重叠的问题
//    for(UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    
    _moneyLogDic = [_moneyArray objectAtIndex:indexPath.row];
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 15)];
    nameLabel.text = [NSString stringWithFormat:@"%@",[_moneyLogDic objectForKey:@"name"]];
    nameLabel.textColor = ColorName;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:nameLabel];
    
    UILabel* tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 37, 160, 15)];
    tipsLabel.text = [NSString stringWithFormat:@"%@",[_moneyLogDic objectForKey:@"log"]];
    tipsLabel.textColor = ColorSecondTitle;
    tipsLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:tipsLabel];
    
    UILabel* dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-135, 14, 120, 15)];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.text = [NSString stringWithFormat:@"%@",[_moneyLogDic objectForKey:@"ctime"]];
    dateLabel.textColor = ColorSecondTitle;
    dateLabel.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:dateLabel];
    
    UILabel* priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-65, 32, 50, 15)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    NSString* moneyString = nil;
    if ([[_moneyLogDic objectForKey:@"money"] intValue] < 0) {
        moneyString = [NSString stringWithFormat:@"%d",-[[_moneyLogDic objectForKey:@"money"] intValue]];
    }
    else {
        moneyString = [_moneyLogDic objectForKey:@"money"];
    }
    priceLabel.text = [NSString stringWithFormat:@"%@元",moneyString];
    priceLabel.textColor = ColorName;
    priceLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:priceLabel];
    
    UIImageView* inOrOutImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-75, 35, 10, 10)];
    if ([[_moneyLogDic objectForKey:@"money"] intValue] > 0) {
        inOrOutImageView.image = [UIImage imageNamed:@"user_account_input"];
    }
    else {
        inOrOutImageView.image = [UIImage imageNamed:@"user_account_output"];
    }
    [cell.contentView addSubview:inOrOutImageView];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height-0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = ColorLine;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
