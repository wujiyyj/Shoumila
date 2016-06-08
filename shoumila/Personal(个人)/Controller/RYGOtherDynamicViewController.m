//
//  RYGOtherDynamicViewController.m
//  shoumila
//
//  Created by 阴～ on 15/10/8.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import "RYGOtherDynamicViewController.h"
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
#import "RYGDynamicCat6TableViewCell.h"


static NSString *dynamicCell = @"dynamicCell";
static NSString *dynamicCell1 = @"dynamicCell1";
static NSString *dynamicCell2 = @"dynamicCell2";
static NSString *dynamicCat6 = @"dynamicCat6";

@interface RYGOtherDynamicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) BOOL isMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGOtherDynamicViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    [MobClick beginLogPageView:@"TA的动态"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    [MobClick endLogPageView:@"TA的动态"];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"TA的动态";
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    [self.view addSubview:_mainTableView];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakself = self;
    
    [_mainTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [_mainTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    } noMoreDataTitle:@"没有更多数据"];
    _datas = [NSMutableArray array];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aRefresh) name:kReloadHomeNotification object:nil];
}

- (void)aRefresh {
    _next = 0;
    _isMoreData = YES;
    _datas = [NSMutableArray array];
    [self loadData];
}

- (void)loadData{
    RYGDynamicParam *param = [RYGDynamicParam param];
    param.type = _type;
    param.next = _next;
    param.keyword = _keyword;
    param.userid = _userid;
    NSString *path = @"feed/feed_list_new";
    [RYGHttpRequest postWithURL:path params:[param keyValues] success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        RYGDynamicList *dynamicList = [RYGDynamicList objectWithKeyValues:dic];
        [dynamicList.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGDynamicFrame *dynamicFrame = [[RYGDynamicFrame alloc]init];
            dynamicFrame.dynamicModel = obj;
            [_datas addObject:dynamicFrame];
        }];
        
        _isMoreData = [dynamicList.page_is_last intValue];
        _next = dynamicList.next;
        [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadRankingTable {
    [self.mainTableView.footer endRefreshing];
    if (_isMoreData) {
        [self.mainTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.mainTableView reloadData];
}


#pragma mark - TableViewDatasource,delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RYGDynamicFrame *dynamicFrame = _datas[indexPath.row];
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
    }else if([model.cat isEqualToString:@"5"]){
        RYGDynamicRecommend1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell2];
        if (!cell) {
            cell = [[RYGDynamicRecommend1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCell2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dynamicFrame = dynamicFrame;
        return cell;
    } else{
        RYGDynamicCat6TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCat6];
        if (!cell) {
            cell = [[RYGDynamicCat6TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCat6];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dynamicFrame = dynamicFrame;
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RYGDynamicFrame *frame = _datas[indexPath.row];
    if ([frame.dynamicModel.cat isEqualToString:@"6"]) {
        return [RYGDynamicCat6TableViewCell heightWithModel:frame];
    }
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![RYGUtility validateUserLogin]) {
        return;
    }
    RYGDynamicFrame *dynamicFrame = _datas[indexPath.row];
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
    detailViewController.feed_id = model.id;
    detailViewController.cat = model.cat;
    [[self getCurrentVC] pushViewController:detailViewController animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
