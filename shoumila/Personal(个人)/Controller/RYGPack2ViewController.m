//
//  RYGPack2ViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

//我创建的
#import "RYGPack2ViewController.h"
#import "RYGCreatePackageTableViewCell.h"
#import "RYGPackageEditViewController.h"
#import "RYGPersonPackageViewController.h"
#import "RYGPackageCreatedListModel.h"
#import "RYGAllListParam.h"
#import "RYGHttpRequest.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

@interface RYGPack2ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* packageTableView;
}
@property (nonatomic,strong) UIView* packageView;

@property (nonatomic,strong) UILabel* xdcc_num;
@property (nonatomic,strong) UILabel* mbsl_num;
@property (nonatomic,strong) UILabel* xyjs_num;
@property (nonatomic,strong) UILabel* fwqx_num;
@property (nonatomic,strong) UILabel* tcfy_num;

@property (nonatomic,strong) UILabel* tczs_num;
@property (nonatomic,strong) UILabel* tcjxz_num;
@property (nonatomic,strong) UILabel* tccg_num;
@property (nonatomic,strong) UILabel* tcsb_num;

@property(nonatomic,strong) RYGPackageCreatedListModel *createdListModel;
@property(nonatomic,strong) NSMutableArray* createdListArray;
@property(nonatomic,strong) NSMutableDictionary* packageDic;

@property(nonatomic,assign) BOOL hasMoreData;
@property(nonatomic,copy)   NSString *next;

@end

@implementation RYGPack2ViewController
@synthesize packageView;
@synthesize xdcc_num;
@synthesize mbsl_num;
@synthesize xyjs_num;
@synthesize fwqx_num;
@synthesize tcfy_num;
@synthesize tczs_num;
@synthesize tcjxz_num;
@synthesize tccg_num;
@synthesize tcsb_num;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self aRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_createdListArray removeAllObjects];
}

- (void)loadNewData{
    RYGAllListParam *listParam = [RYGAllListParam param];
    listParam.count = @"5";
    listParam.next = _next;
    [RYGHttpRequest postWithURL:Package_Created params:listParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.createdListModel = [RYGPackageCreatedListModel objectWithKeyValues:dic];
        [_createdListArray  addObjectsFromArray:self.createdListModel.datas];
        _packageDic = self.createdListModel.package;
        
        _next = self.createdListModel.next;
        // 没有加载更多
        if ([self.createdListModel.page_is_last isEqualToString:@"0"]) {
            _hasMoreData = YES;
        }
        else {
            _hasMoreData = NO;
        }
        [packageTableView.header setState:MJRefreshHeaderStateIdle];
        
        [self reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData
{
    [packageTableView.footer endRefreshing];
    if (!_hasMoreData) {
        [packageTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [packageTableView reloadData];
    
    if (_packageDic.count == 0) {
        
    }
    else {
        [self reloadPackageData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    _createdListArray = [[NSMutableArray alloc]init];
    _packageDic = [[NSMutableDictionary alloc]init];
    
    [self createPackageView];
    
    [self createPackageTableView];
    
//    [self aRefresh];
}

- (void)createPackageView {
    
    packageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122)];
    packageView.backgroundColor = ColorViewBackground;
//    [self.view addSubview:packageView];
    
    //限定场次
    UILabel* xdcc_label = [self createLabelFrame:CGRectMake(15, 15, 45*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"限定场次"];
    [packageView addSubview:xdcc_label];
    xdcc_num = [self createLabelFrame:CGRectMake(15, 35, 45*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:14] withColor:ColorName withText:[NSString stringWithFormat:@"%@场",@"0"]];
    [packageView addSubview:xdcc_num];
    
    UIView* line1_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(20+45*SCREEN_SCALE, 20, 0.5, 30)];
    line1_vertical_View.backgroundColor = ColorLine;
    [packageView addSubview:line1_vertical_View];
    
    //目标胜率
    UILabel* mbsl_label = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8, 15, 50*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"目标胜率"];
    [packageView addSubview:mbsl_label];
    mbsl_num = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8, 35, 50*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:14] withColor:ColorRateTitle withText:[NSString stringWithFormat:@"%@％",@"0"]];
    [packageView addSubview:mbsl_num];
    
    UIView* line2_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5, 20, 0.5, 30)];
    line2_vertical_View.backgroundColor = ColorLine;
    [packageView addSubview:line2_vertical_View];
    
    //需要净胜
    UILabel* xyjj_label = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8, 15, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"需要净胜"];
    [packageView addSubview:xyjj_label];
    xyjs_num = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8, 35, 50*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:14] withColor:ColorName withText:[NSString stringWithFormat:@"%@场",@"0"]];
    [packageView addSubview:xyjs_num];
    
    UIView* line3_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5, 20, 0.5, 30)];
    line3_vertical_View.backgroundColor = ColorLine;
    [packageView addSubview:line3_vertical_View];
    
    //服务期限
    UILabel* fwqx_label = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5+8, 15, 50*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"服务期限"];
    [packageView addSubview:fwqx_label];
    fwqx_num = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5+8, 35, 50*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:14] withColor:ColorName withText:[NSString stringWithFormat:@"%@天",@"0"]];
    [packageView addSubview:fwqx_num];
    
    UIView* line4_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5, 20, 0.5, 30)];
    line4_vertical_View.backgroundColor = ColorLine;
    [packageView addSubview:line4_vertical_View];
    
    //套餐费用
    UILabel* tcfy_label = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5+8, 15, 45*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"套餐费用"];
    [packageView addSubview:tcfy_label];
    tcfy_num = [self createLabelFrame:CGRectMake(20+45*SCREEN_SCALE+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5+8+50*SCREEN_SCALE+5+8, 35, 45*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:14] withColor:ColorName withText:[NSString stringWithFormat:@"%@元",@"0"]];
    [packageView addSubview:tcfy_num];
    
    
    UIView* middle_lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH-30, 0.5)];
    middle_lineView.backgroundColor = ColorLine;
    [packageView addSubview:middle_lineView];
    
    
    //套餐总数
    UILabel* tczs_label = [self createLabelFrame:CGRectMake(15, 70, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"套餐总数"];
    [packageView addSubview:tczs_label];
    tczs_num = [self createLabelFrame:CGRectMake(70, 70, 45, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:[NSString stringWithFormat:@"%@个",@"0"]];
    [packageView addSubview:tczs_num];
    
    //套餐进行中
    UILabel* tcjxz_label = [self createLabelFrame:CGRectMake(135*SCREEN_SCALE, 70, 50*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentLeft withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"套餐进行中"];
    [packageView addSubview:tcjxz_label];
    tcjxz_num = [self createLabelFrame:CGRectMake(185*SCREEN_SCALE+5, 70, 45*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentLeft withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:[NSString stringWithFormat:@"%@个",@"0"]];
    [packageView addSubview:tcjxz_num];
    
    //套餐成功
    UILabel* tccg_label = [self createLabelFrame:CGRectMake(15, 90, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"套餐成功"];
    [packageView addSubview:tccg_label];
    tccg_num = [self createLabelFrame:CGRectMake(70, 90, 45, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:[NSString stringWithFormat:@"%@个",@"0"]];
    [packageView addSubview:tccg_num];
    
    //套餐失败
    UILabel* tcsb_label = [self createLabelFrame:CGRectMake(135*SCREEN_SCALE, 90, 50*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentLeft withFont:[UIFont systemFontOfSize:10] withColor:ColorSecondTitle withText:@"套餐失败"];
    [packageView addSubview:tcsb_label];
    tcsb_num = [self createLabelFrame:CGRectMake(185*SCREEN_SCALE+5, 90, 45*SCREEN_SCALE, 20) withAlignment:NSTextAlignmentLeft withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:[NSString stringWithFormat:@"%@个",@"0"]];
    [packageView addSubview:tcsb_num];
    
    //套餐编辑按钮
    UIButton* tc_editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tc_editBtn.frame = CGRectMake(SCREEN_WIDTH-75, 80, 60, 23);
    [tc_editBtn setBackgroundColor:ColorRankMenuBackground];
    tc_editBtn.layer.cornerRadius = 4;
    [tc_editBtn setTitle:@"套餐编辑" forState:UIControlStateNormal];
    tc_editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [tc_editBtn addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    [packageView addSubview:tc_editBtn];
    
    UIView* bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, packageView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    bottomView.backgroundColor = ColorLine;
    [packageView addSubview:bottomView];
    
}

- (void)reloadPackageData {
    xdcc_num.text = [NSString stringWithFormat:@"%@场",[_packageDic valueForKey:@"matches"]];
    mbsl_num.text = [NSString stringWithFormat:@"%@％",[_packageDic valueForKey:@"target_winrate"]];
    xyjs_num.text = [NSString stringWithFormat:@"%@场",[_packageDic valueForKey:@"target_win"]];
    fwqx_num.text = [NSString stringWithFormat:@"%@天",[_packageDic valueForKey:@"service_term"]];
    tcfy_num.text = [NSString stringWithFormat:@"%@元",[_packageDic valueForKey:@"fee"]];
    tczs_num.text = [NSString stringWithFormat:@"%@个",[_packageDic valueForKey:@"buy_num"]];
    tcjxz_num.text = [NSString stringWithFormat:@"%@个",[_packageDic valueForKey:@"under_way"]];
    tccg_num.text = [NSString stringWithFormat:@"%@个",[_packageDic valueForKey:@"success_num"]];
    tcsb_num.text = [NSString stringWithFormat:@"%@个",[_packageDic valueForKey:@"fail_num"]];
    
}

-(UILabel*)createLabelFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment withFont:(UIFont*)font withColor:(UIColor*)color withText:(NSString*)text
{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.numberOfLines = 0;
    label.textColor = color;
    label.text = text;
    return label;
}

- (void)editButton:(UIButton*)button {
    
    if ([[_packageDic valueForKey:@"can_edit"] intValue] == 0) {
        [MBProgressHUD showError:@"该功能暂未开放，敬请期待"];
    }
    else {
        RYGPackageEditViewController* packageEditVC = [[RYGPackageEditViewController alloc]init];
        packageEditVC.package_id = [_packageDic valueForKey:@"package_id"];
        packageEditVC.service_term = [_packageDic valueForKey:@"service_term"];
        packageEditVC.matches = [_packageDic valueForKey:@"matches"];
        packageEditVC.target_win = [_packageDic valueForKey:@"target_win"];
        packageEditVC.fee = [_packageDic valueForKey:@"fee"];
        [self.navigationController pushViewController:packageEditVC animated:YES];
    }
    
    
    
//    RYGPersonPackageViewController* personPackageVC = [[RYGPersonPackageViewController alloc]init];
//    [self.navigationController pushViewController:personPackageVC animated:YES];
}

- (void)createPackageTableView {
    packageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    packageTableView.delegate = self;
    packageTableView.dataSource = self;
    packageTableView.backgroundColor = ColorRankMyRankBackground;
    [packageTableView registerClass:[RYGCreatePackageTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [packageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    packageTableView.tableHeaderView = packageView;
    packageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(&*self)weakself = self;
    [packageTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [packageTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadNewData];
    } noMoreDataTitle:@"没有更多数据"];
    [self.view addSubview:packageTableView];
}

#pragma mark 初期刷新，下拉刷新
- (void)aRefresh {
    _createdListArray = [[NSMutableArray alloc]init];
    _next = @"0";
    _hasMoreData = YES;
    [self loadNewData];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _createdListArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 126;
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = ColorRankMyRankBackground;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView* orderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 17)];
        orderImageView.image = [UIImage imageNamed:@"user_package_order"];
        [cell.contentView addSubview:orderImageView];
        
        UILabel* orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 100, 20)];
        orderLabel.text = @"订单详情";
        orderLabel.font = [UIFont systemFontOfSize:13];
        orderLabel.textColor = ColorSecondTitle;
        [cell.contentView addSubview:orderLabel];
        
        return cell;
    }
    RYGCreatePackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = ColorRankMyRankBackground;
    cell.packageCreatedModel = _createdListArray[indexPath.section-1];
    
//    //修改UITableview服用重叠的问题
//    for(UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    
    return cell;
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
