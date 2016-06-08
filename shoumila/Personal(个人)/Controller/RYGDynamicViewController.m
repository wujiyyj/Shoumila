//
//  RYGDynamicViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicViewController.h"
#import "RYGHttpRequest.h"
#import "RYGDynamicList.h"
#import "MJRefresh.h"
#import "RYGDynamicTableViewCell.h"
#import "RYGDynamicModel.h"
#import "RYGDynamicFrame.h"
#import "RYGDynamicRecommendTableViewCell.h"
#import "RYGDynamicRecommend1TableViewCell.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGDynamicParam.h"
#import "MBProgressHUD.h"

static NSString *dynamicCell = @"dynamicCell";
static NSString *dynamicCell1 = @"dynamicCell1";
static NSString *dynamicCell2 = @"dynamicCell2";
@interface RYGDynamicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView* mePushedTableView;
@property(nonatomic,strong) UITableView* meJoinedTableView;
@property(nonatomic,strong) NSMutableArray *pushDatas;
@property(nonatomic,strong) NSMutableArray *joinDatas;
@property(nonatomic,assign) BOOL isPushMoreData;
@property(nonatomic,assign) BOOL isJoinMoreData;
@property(nonatomic,copy)   NSString *pushNext;
@property(nonatomic,copy)   NSString *joinNext;
@property(nonatomic,copy)   NSString *type;

@end

@implementation RYGDynamicViewController
@synthesize mePushedTableView;
@synthesize meJoinedTableView;

- (void)loadView {
    [super loadView];
    
    _pushDatas = [NSMutableArray array];
    _joinDatas = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的动态";
    
    [MobClick beginLogPageView:@"我的动态"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"我的动态"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的动态";
    
    [self aPushRefresh];
    [self createDataCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)aPushRefresh {
    _type = @"0";
    _pushNext = @"0";
    _isPushMoreData = YES;
    [self loadPushedData];
}

- (void)aJoinRefresh {
    _type = @"0";
    _joinNext = @"0";
    _isJoinMoreData = YES;
    [self loadJoinedData];
}

- (void)loadPushedData{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"加载中...";
    [hud show:YES];
    [hud hide:YES afterDelay:0.5];
    
    RYGDynamicParam *param = [RYGDynamicParam param];
    param.count = @"5";
    param.next = _pushNext;
    [RYGHttpRequest postWithURL:Feed_published params:[param keyValues] success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        RYGDynamicList *dynamicList = [RYGDynamicList objectWithKeyValues:dic];
        [dynamicList.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGDynamicFrame *dynamicFrame = [[RYGDynamicFrame alloc]init];
            dynamicFrame.dynamicModel = obj;
            [_pushDatas addObject:dynamicFrame];
        }];
        
        if ([dynamicList.page_is_last isEqualToString:@"0"]) {
            _isPushMoreData = YES;
        }
        else {
            _isPushMoreData = NO;
        }
        _pushNext = dynamicList.next;
        [self.mePushedTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadJoinedData{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"加载中...";
    [hud show:YES];
    [hud hide:YES afterDelay:0.5];
    
    RYGDynamicParam *param = [RYGDynamicParam param];
    param.count = @"5";
    param.next = _joinNext;
    [RYGHttpRequest postWithURL:Feed_involvemented params:[param keyValues] success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        RYGDynamicList *dynamicList = [RYGDynamicList objectWithKeyValues:dic];
        [dynamicList.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGDynamicFrame *dynamicFrame = [[RYGDynamicFrame alloc]init];
            dynamicFrame.dynamicModel = obj;
            [_joinDatas addObject:dynamicFrame];
        }];
        
        if ([dynamicList.page_is_last isEqualToString:@"0"]) {
            _isJoinMoreData = YES;
        }
        else {
            _isJoinMoreData = NO;
        }
        _joinNext = dynamicList.next;
        [self.meJoinedTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadJoinRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadRankingTable {
    [self.mePushedTableView.footer endRefreshing];
    if (!_isPushMoreData) {
        [self.mePushedTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.mePushedTableView reloadData];
}

- (void)reloadJoinRankingTable {
    [self.meJoinedTableView.footer endRefreshing];
    if (!_isJoinMoreData) {
        [self.meJoinedTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.meJoinedTableView reloadData];
}

- (void)createDataCell
{
    NSArray *menuTitles = [NSArray arrayWithObjects:@"我发布的", @"我参与的",nil];
    _menuItemView = [[RYGMenuItemView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) menuTitles:menuTitles];
    _menuItemView.textAttributes = @{MenuFont:[UIFont boldSystemFontOfSize:14], MenuColor:ColorName};
    _menuItemView.selectedTextAttributes = @{MenuFont:[UIFont boldSystemFontOfSize:14], MenuColor:ColorRankMenuBackground};
    _menuItemView.transitionTextAttributes = @{MenuFont:[UIFont boldSystemFontOfSize:14], MenuColor:ColorRankMenuBackground};
    _menuItemView.currentSelectedIndex = 0;
    _menuItemView.backgroundColor = ColorRankMyRankBackground;
    __weak __typeof(&*self)weakSelf = self;
    _menuItemView.selectBlock = ^(NSInteger index) {
        [weakSelf menuSelectChange:index];
    };
    [self.view addSubview:_menuItemView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, self.view.height-30)];
    _scrollView.delegate = self;
    _scrollView.contentSize= CGSizeMake(SCREEN_WIDTH*2, self.view.height-30);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [self initSubViews];
}

- (void)initSubViews
{
    mePushedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height-30) style:UITableViewStylePlain];
    mePushedTableView.delegate = self;
    mePushedTableView.dataSource = self;
    [mePushedTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mePushedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakself = self;
    
    [mePushedTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself.pushDatas removeAllObjects];
        [weakself aPushRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [mePushedTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadPushedData];
    } noMoreDataTitle:@"没有更多数据"];
    [self.scrollView addSubview:mePushedTableView];
    
    meJoinedTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height-30) style:UITableViewStylePlain];
    meJoinedTableView.delegate = self;
    meJoinedTableView.dataSource = self;
    [meJoinedTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    meJoinedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakselfs = self;
    
    [meJoinedTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself.joinDatas removeAllObjects];
        [weakselfs aJoinRefresh];
    }];
    __weak __typeof(&*self)weakselfs1 = self;
    [meJoinedTableView addLegendFooterWithRefreshingBlock:^{
        [weakselfs1 loadJoinedData];
    } noMoreDataTitle:@"没有更多数据"];
    [self.scrollView addSubview:meJoinedTableView];
    
}

// 点击榜单menu
- (void)menuSelectChange:(NSInteger)index
{
    self.scrollView.contentOffset = CGPointMake(self.view.width * index, 0);
    if (index == 1) {
        [self.joinDatas removeAllObjects];
        [self aJoinRefresh];
    }
    else if (index == 0) {
        [self.pushDatas removeAllObjects];
        [self aPushRefresh];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x+self.view.width/2.0) / self.view.width;
    NSLog(@"page == %d",page);
    NSLog(@"--%f",_scrollView.contentOffset.x);
    if (_scrollView.contentOffset.x == SCREEN_WIDTH) {
        page = 1;
    }
    _menuItemView.currentSelectedIndex = page;
    if (page == 1) {
        [self aJoinRefresh];
    }
}


#pragma mark - TableViewDatasource,delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* datas = [[NSMutableArray alloc] init];
    if (tableView == mePushedTableView) {
        datas = _pushDatas;
    }
    else if (tableView == meJoinedTableView) {
        datas = _joinDatas;
    }
    if (datas.count < indexPath.row) {
        return nil;
    }
    RYGDynamicFrame *dynamicFrame = datas[indexPath.row];
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    
    if ([model.cat isEqualToString:@"1"]) {
        RYGDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell];
        NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
        for (UIView *subview in subviews) {
            [subview removeFromSuperview];
        }
        if (!cell) {
            cell = [[RYGDynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCell];
        }
        dynamicFrame.dynamicModel.type = _type;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dynamicFrame = dynamicFrame;
        return cell;
    }else if ([model.cat isEqualToString:@"2"]||[model.cat isEqualToString:@"3"]||[model.cat isEqualToString:@"4"]){
        RYGDynamicRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell1];
        if (!cell) {
            cell = [[RYGDynamicRecommendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCell1];
        }
        cell.dynamicFrame = dynamicFrame;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RYGDynamicRecommend1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell2];
        if (!cell) {
            cell = [[RYGDynamicRecommend1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCell2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dynamicFrame = dynamicFrame;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == mePushedTableView) {
        return _pushDatas.count;
    }
    else if (tableView == meJoinedTableView) {
        return _joinDatas.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* datas = [[NSMutableArray alloc] init];
    if (tableView == mePushedTableView) {
        datas = _pushDatas;
    }
    else if (tableView == meJoinedTableView) {
        datas = _joinDatas;
    }
    RYGDynamicFrame *frame = datas[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* datas = [[NSMutableArray alloc] init];
    if (tableView == mePushedTableView) {
        datas = _pushDatas;
    }
    else if (tableView == meJoinedTableView) {
        datas = _joinDatas;
    }
    RYGDynamicFrame *dynamicFrame = datas[indexPath.row];
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
    detailViewController.feed_id = model.id;
    detailViewController.cat = model.cat;
    UINavigationController *nav = [self getCurrentVC]?[self getCurrentVC]:self.navigationController;
    [nav pushViewController:detailViewController animated:YES];
    
}

//获取当前窗口导航控制器
- (UINavigationController *)getCurrentVC
{
    UITabBarController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    UITabBarController *tabVc = result.childViewControllers[1];
    NSInteger index = tabVc.selectedIndex;
    
    return tabVc.viewControllers[index];
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
