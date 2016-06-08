//
//  RYGFeedAttentionViewController.m
//  shoumila
//
//  Created by 阴～ on 15/10/28.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import "RYGFeedAttentionViewController.h"
#import "RYGHttpRequest.h"
#import "RYGDynamicList.h"
#import "MJRefresh.h"
#import "RYGDynamicTableViewCell.h"
#import "RYGDynamicModel.h"
#import "RYGDynamicFrame.h"
#import "RYGDynamicRecommendTableViewCell.h"
#import "RYGDynamicRecommend1TableViewCell.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGAllListParam.h"

static NSString *dynamicCell = @"dynamicCell";
static NSString *dynamicCell1 = @"dynamicCell1";
static NSString *dynamicCell2 = @"dynamicCell2";

@interface RYGFeedAttentionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView* mAttentionTableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) BOOL isMoreData;
@property(nonatomic,copy)   NSString *next;
@property(nonatomic,copy)   NSString *type;

@end

@implementation RYGFeedAttentionViewController
@synthesize mAttentionTableView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"我的关注"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"我的关注"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorRankBackground;
    self.navigationItem.title = @"我的关注";
    [self initSubViews];
    [self aRefresh];
}

- (void)initSubViews
{
    mAttentionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    mAttentionTableView.delegate = self;
    mAttentionTableView.dataSource = self;
    [mAttentionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mAttentionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakself = self;
    [mAttentionTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [mAttentionTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    } noMoreDataTitle:@"没有更多数据"];
    [self.view addSubview:mAttentionTableView];
    
}

- (void)aRefresh {
    _next = @"0";
    _isMoreData = YES;
    _datas = [NSMutableArray array];
    [self loadData];
}

- (void)loadData{
    RYGAllListParam *param = [RYGAllListParam param];
    param.count = @"5";
    param.next = _next;
    [RYGHttpRequest postWithURL:Feed_myAttention params:[param keyValues] success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        RYGDynamicList *dynamicList = [RYGDynamicList objectWithKeyValues:dic];
        [dynamicList.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGDynamicFrame *dynamicFrame = [[RYGDynamicFrame alloc]init];
            dynamicFrame.dynamicModel = obj;
            [_datas addObject:dynamicFrame];
        }];
        
        if ([dynamicList.page_is_last isEqualToString:@"0"]) {
            _isMoreData = YES;
        }
        else {
            _isMoreData = NO;
        }
        _next = dynamicList.next;
        [self.mAttentionTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadRankingTable {
    [self.mAttentionTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.mAttentionTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    if (_datas.count) {
        [self.mAttentionTableView reloadData];
    }
    
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
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RYGDynamicFrame *frame = _datas[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RYGDynamicFrame *dynamicFrame = _datas[indexPath.row];
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
    detailViewController.feed_id = model.id;
    detailViewController.cat = model.cat;
    [[self getCurrentVC] pushViewController:detailViewController animated:YES];
    
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
