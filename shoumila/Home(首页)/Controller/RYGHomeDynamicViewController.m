//
//  RYGDynamicViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/8/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGHomeDynamicViewController.h"
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
#import "RYGDynamicCat6TableViewCell.h"
#import "RYGDynamicGroupTableViewCell.h"

static NSString *dynamicCell = @"dynamicCell";
static NSString *dynamicCell1 = @"dynamicCell1";
static NSString *dynamicCell2 = @"dynamicCell2";
static NSString *dynamicCat6 = @"dynamicCat6";
static NSString *dynamicGroup = @"dynamicGroup";
static NSString *CACHE_DATA = @"CACHE_DATA";

@interface RYGHomeDynamicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) BOOL isMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGHomeDynamicViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    [self.view addSubview:_mainTableView];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.scrollsToTop = YES;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakself = self;
    
    [_mainTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh:nil];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [_mainTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    } noMoreDataTitle:@"没有更多数据"];
    _datas = [NSMutableArray array];
    if (self.userName) {
        self.title = [NSString stringWithFormat:@"%@的滚球动态",self.userName];
    }
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aRefresh:) name:kReloadHomeNotification object:nil];
}

- (void)aRefresh:(NSNotification *)notification {
    if ([notification object]) {
        _type = [notification object];
    }
    _next = 0;
    _isMoreData = YES;
    @try {
        [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    @catch (NSException *exception) {
        
    }
    
    [self loadNewData];
}

- (void)loadData{
//    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:CACHE_DATA];
//    [self parseData:dic];

    RYGDynamicParam *param = [RYGDynamicParam param];
    param.type = _type;
    param.next = _next;
    param.keyword = _keyword;
    param.userid = self.userid;
    NSString *path = self.urlPath?:([_type isEqual:@"0"]||(_type.intValue == 0))?@"feed/feed_list_new":@"feed/feed_list";
    [RYGHttpRequest postWithURL:path params:[param keyValues] success:^(id json) {
        [self parseData:json];
    } failure:^(NSError *error) {
        [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
    }];
}

- (void)loadNewData{
    RYGDynamicParam *param = [RYGDynamicParam param];
    param.type = _type;
    param.next = _next;
    param.keyword = _keyword;
    param.userid = self.userid;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"加载中...";
    [hud show:YES];
    [hud hide:YES afterDelay:0.5];
    NSString *path = self.urlPath?:([_type isEqual:@"0"]||(_type.intValue == 0))?@"feed/feed_list_new":@"feed/feed_list";
    [RYGHttpRequest postWithURL:path params:[param keyValues] success:^(id json) {
//        [[NSUserDefaults standardUserDefaults] setObject:json forKey:CACHE_DATA];
         _datas = [NSMutableArray array];
        [self parseData:json];
    } failure:^(NSError *error) {
        [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
    }];
}

- (void)parseData:(id)data{
    NSMutableDictionary *dic = [data valueForKey:@"data"];
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
        if ([model.type isEqual:@"2"]&& !self.isFeedgqList&& ([self.type isEqual:@"0"]||(_type.intValue == 0))) {
            RYGDynamicGroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dynamicGroup];
            if (!cell) {
                cell = [[RYGDynamicGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicGroup];
            }
            cell.dynamicFrame = dynamicFrame;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        RYGDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell];
        
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
    if ([frame.dynamicModel.cat isEqualToString:@"1"]&&[frame.dynamicModel.type  isEqual: @"2"]) {
        return [RYGDynamicGroupTableViewCell heightWithModel:frame];
    }
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![RYGUtility validateUserLogin]) {
        return;
    }
    
    RYGDynamicFrame *dynamicFrame = _datas[indexPath.row];
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    if ([model.cat isEqual:@"1"]&&[model.type isEqual:@"2"]) {
        RYGHomeDynamicViewController *home = [[RYGHomeDynamicViewController alloc]init];
        home.urlPath = @"feed/gq_list";
        home.isFeedgqList = YES;
        home.userid = model.publish_user.userid;
        home.userName = model.publish_user.name;
        UINavigationController *nav = [self getCurrentVC]?:self.navigationController;
        [nav pushViewController:home animated:YES];
        return;
    }
    RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
    detailViewController.feed_id = model.id;
    detailViewController.cat = model.cat;
    UINavigationController *nav = [self getCurrentVC]?:self.navigationController;
    [nav pushViewController:detailViewController animated:YES];
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
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
