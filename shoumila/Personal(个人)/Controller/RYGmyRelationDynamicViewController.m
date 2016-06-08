//
//  RYGmyRelationDynamicViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGmyRelationDynamicViewController.h"
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

static NSString *dynamicCell = @"dynamicCell";
static NSString *dynamicCell1 = @"dynamicCell1";
static NSString *dynamicCell2 = @"dynamicCell2";

@interface RYGmyRelationDynamicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) BOOL isMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGmyRelationDynamicViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
//    _datas = [NSMutableArray array];
//    [self aRefresh];
//    [self loadData];
    
    [self createMainTableView];
}

- (void)createMainTableView {
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-44-40)];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_mainTableView];
//    __weak __typeof(&*self)weakself = self;
    
//    [_mainTableView addLegendHeaderWithRefreshingBlock:^{
//        [weakself aRefresh];
//    }];
//    __weak __typeof(&*self)weakself1 = self;
//    [_mainTableView addLegendFooterWithRefreshingBlock:^{
//        [weakself1 loadData];
//    } noMoreDataTitle:@"没有更多数据"];
}


//- (void)aRefresh {
//    _next = 0;
//    _isMoreData = YES;
//    _datas = [NSMutableArray array];
//    [self loadData];
//}
//
//- (void)loadData{
//    RYGDynamicParam *param = [RYGDynamicParam param];
//    param.type = _type;
//    param.next = _next;
//    [RYGHttpRequest postWithURL:Feed_List params:[param keyValues] success:^(id json) {
//        NSMutableDictionary *dic = [json valueForKey:@"data"];
//        RYGDynamicList *dynamicList = [RYGDynamicList objectWithKeyValues:dic];
//        [dynamicList.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            RYGDynamicFrame *dynamicFrame = [[RYGDynamicFrame alloc]init];
//            dynamicFrame.dynamicModel = obj;
//            [_datas addObject:dynamicFrame];
//        }];
//        
//        if (dynamicList.page_is_last || [dynamicList.page_is_last isEqualToString:@"0"]) {
//            _isMoreData = NO;
//        }
//        _next = dynamicList.next;
//        [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
//        
//        [self createMainTableView];
////        [self reloadRankingTable];
//    } failure:^(NSError *error) {
//        
//    }];
//}

//- (void)reloadRankingTable {
//    [self.mainTableView.footer endRefreshing];
//    if (!_isMoreData) {
//        [self.mainTableView.footer setState:MJRefreshFooterStateNoMoreData];
//    }
//    [self.mainTableView reloadData];
//}


#pragma mark - TableViewDatasource,delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = @"2323";
    
    return cell;
//    RYGDynamicFrame *dynamicFrame = _datas[indexPath.row];
//    RYGDynamicModel *model = dynamicFrame.dynamicModel;
//    if ([model.cat isEqualToString:@"1"]) {
//        RYGDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell];
//        if (!cell) {
//            cell = [[RYGDynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCell];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.dynamicFrame = dynamicFrame;
//        return cell;
//    }else if ([model.cat isEqualToString:@"2"]||[model.cat isEqualToString:@"3"]||[model.cat isEqualToString:@"4"]){
//        RYGDynamicRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell1];
//        if (!cell) {
//            cell = [[RYGDynamicRecommendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCell1];
//        }
//        cell.dynamicFrame = dynamicFrame;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else{
//        RYGDynamicRecommend1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dynamicCell2];
//        if (!cell) {
//            cell = [[RYGDynamicRecommend1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCell2];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.dynamicFrame = dynamicFrame;
//        return cell;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    RYGDynamicFrame *frame = _datas[indexPath.row];
    return 200;
}

@end
