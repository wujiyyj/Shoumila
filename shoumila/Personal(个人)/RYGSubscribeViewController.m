//
//  RYGSubscribeViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSubscribeViewController.h"
#import "RYGAttentionParam.h"
#import "RYGAllListParam.h"
#import "RYGHttpRequest.h"
#import "RYGAttentionListModel.h"
#import "RYGUserCenterViewController.h"
#import "MJRefresh.h"

//订阅
@interface RYGSubscribeViewController ()
{
    UITableView* mainTableView;
}

@property(nonatomic,strong) RYGAttentionListModel *attentionListModel;
@property(nonatomic,strong) NSMutableArray* attentionListArray;
@property(nonatomic,assign) BOOL hasMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGSubscribeViewController

-(void)loadView{
    [super loadView];
    _attentionListArray = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"关注"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"关注"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"关注";
    [self createTableView];
    
    [self aRefresh];
    if (self.navigationController.childViewControllers[0] == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    }
}

- (void)loadNewData{
    RYGAllListParam *allListParam = [RYGAllListParam param];
    allListParam.userid = _userid;
    allListParam.count = @"25";
    allListParam.next = _next;
    [RYGHttpRequest postWithURL:User_AttentionList params:allListParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.attentionListModel = [RYGAttentionListModel objectWithKeyValues:dic];
        
        [_attentionListArray addObjectsFromArray:self.attentionListModel.datas];
        
        _next = self.attentionListModel.next;
        // 没有加载更多
        if ([self.attentionListModel.page_is_last isEqualToString:@"0"]) {
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
    [mainTableView registerClass:[RYGSubscribeTableViewCell class] forCellReuseIdentifier:@"SubscribeCell"];
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
    _attentionListArray = [[NSMutableArray alloc]init];
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
    return _attentionListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RYGSubscribeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribeCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.attentionPersonModel = [_attentionListArray objectAtIndex:indexPath.row];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedCell) {
        RYGAttentionPersonModel *person = [_attentionListArray objectAtIndex:indexPath.row];
        _selectedCell(person);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark RYGSubscribeTableViewCellDelegate
- (void)clickOtherPerson:(NSString *)userId {
    if (!_selectedCell) {
        RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
        otherPersonViewController.userId = userId;
        [self.navigationController pushViewController:otherPersonViewController animated:YES];
    }
}

- (void)clickCancelAttentionButton:(NSString *)userId {
    
    RYGAttentionParam *attentionParam = [RYGAttentionParam param];
    attentionParam.userid = userId;
    attentionParam.op = @"1";
    __block RYGSubscribeViewController *blockSelf = self;
    [RYGHttpRequest postWithURL:User_Attention params:attentionParam.keyValues success:^(id json) {
        NSNumber *code = [json valueForKey:@"code"];
        if (code && code.integerValue == 0) {
            //取消关注成功
            [_attentionListArray removeAllObjects];
            [blockSelf aRefresh];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
