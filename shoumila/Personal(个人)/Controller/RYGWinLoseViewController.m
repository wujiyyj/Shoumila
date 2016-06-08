//
//  RYGWinLoseViewController.m
//  shoumila
//
//  Created by 阴～ on 16/4/10.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import "RYGWinLoseViewController.h"
#import "RYGWinLoseTableViewCell.h"
#import "RYGAllListParam.h"
#import "RYGHttpRequest.h"
#import "RYGWinLoseListModel.h"
#import "RYGUserCenterViewController.h"
#import "MJRefresh.h"

@interface RYGWinLoseViewController ()
{
    UITableView* mainTableView;
}

@property(nonatomic,strong) RYGWinLoseListModel *winLoseListModel;
@property(nonatomic,strong) NSMutableArray* winLoseListArray;
@property(nonatomic,assign) BOOL hasMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGWinLoseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    [MobClick beginLogPageView:@"输赢列表"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    
    [MobClick endLogPageView:@"输赢列表"];
}

-(void)loadView{
    [super loadView];
    _winLoseListArray = [[NSMutableArray alloc]init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"输赢列表";
    
    [self createTableView];
    
    [self aRefresh];
    if (self.navigationController.childViewControllers[0] == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    }
}

- (void)loadNewData{
    RYGAllListParam *allListParam = [RYGAllListParam param];
    allListParam.userid = _userid;
    allListParam.count = @"15";
    allListParam.next = _next;
    [RYGHttpRequest postWithURL:User_WinLose params:allListParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.winLoseListModel = [RYGWinLoseListModel objectWithKeyValues:dic];
        
        [_winLoseListArray addObjectsFromArray:self.winLoseListModel.datas];
        
        _next = self.winLoseListModel.next;
        // 没有加载更多
        if ([self.winLoseListModel.page_is_last isEqualToString:@"0"]) {
            _hasMoreData = YES;
        }
        else {
            _hasMoreData = NO;
        }
        [mainTableView.header setState:MJRefreshHeaderStateIdle];
        
        [self reloadData];
        
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

- (void)createTableView
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView registerClass:[RYGWinLoseTableViewCell class] forCellReuseIdentifier:@"WinLoseCell"];
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
    _winLoseListArray = [[NSMutableArray alloc]init];
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
    return 118;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 20;
//}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _winLoseListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RYGWinLoseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WinLoseCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.winLosePersonModel = [_winLoseListArray objectAtIndex:indexPath.row];
    
    return cell;
    
    
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
