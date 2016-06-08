//
//  RYGBlackListViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/1.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBlackListViewController.h"
#import "RYGAttentionParam.h"
#import "RYGHttpRequest.h"
#import "RYGBlackListModel.h"
#import "RYGAllListParam.h"
#import "RYGUserCenterViewController.h"
#import "MJRefresh.h"

@interface RYGBlackListViewController ()
{
    UITableView* mainTableView;
}

@property(nonatomic,strong) RYGBlackListModel *blackListModel;
@property(nonatomic,strong) NSMutableArray* blackListArray;
@property(nonatomic,assign) BOOL hasMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGBlackListViewController

-(void)loadView{
    [super loadView];
    _blackListArray = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"黑名单"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"黑名单"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"黑名单管理";
    self.view.backgroundColor = ColorRankMyRankBackground;
    
    [self createTableView];
    
    [self aRefresh];
    
}

- (void)loadNewData{
    RYGAllListParam *allListParam = [RYGAllListParam param];
    allListParam.count = @"5";
    allListParam.next = _next;
    [RYGHttpRequest postWithURL:User_BlackList params:allListParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.blackListModel = [RYGBlackListModel objectWithKeyValues:dic];
        
        [_blackListArray addObjectsFromArray:self.blackListModel.datas];
        
        _next = self.blackListModel.next;
        // 没有加载更多
        if ([self.blackListModel.page_is_last isEqualToString:@"0"]) {
            _hasMoreData = YES;
        }
        else {
            _hasMoreData = NO;
        }
        [mainTableView.header setState:MJRefreshHeaderStateIdle];
        
        if (_blackListArray.count == 0 || _blackListArray == NULL) {
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

- (void)createTableView
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-48) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView registerClass:[RYGBlackListTableViewCell class] forCellReuseIdentifier:@"CancelShieldCell"];
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
    _blackListArray = [[NSMutableArray alloc]init];
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

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _blackListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RYGBlackListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CancelShieldCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.blackPersonModel = [_blackListArray objectAtIndex:indexPath.row];
    
    
    return cell;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark RYGSubscribeTableViewCellDelegate

- (void)clickOtherPerson:(NSString *)userId {
    RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
    otherPersonViewController.userId = userId;
    [self.navigationController pushViewController:otherPersonViewController animated:YES];
}

- (void)clickcancelShieldButton:(NSString *)userId {
        RYGAttentionParam *attentionParam = [RYGAttentionParam param];
        attentionParam.userid = userId;
        attentionParam.op = @"1";
        __block RYGBlackListViewController *blockSelf = self;
        [RYGHttpRequest postWithURL:User_AddBlack params:attentionParam.keyValues success:^(id json) {
            NSNumber *code = [json valueForKey:@"code"];
            if (code && code.integerValue == 0) {
                //删除黑名单成功
                [_blackListArray removeAllObjects];
                [blockSelf aRefresh];
            }
        } failure:^(NSError *error) {
            
        }];
        
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
