//
//  RYGMonthRankingViewController.m
//  月度榜
//
//  Created by jiaocx on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMonthRankingViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "RYGRankingListParam.h"
#import "RYGHttpRequest.h"
#import "RYGMonthRankingModel.h"
#import "RYGMonthRankTableViewCell.h"
#import "RYGAttentionParam.h"
#import "RYGMonthPersonModel.h"
#import "RYGUserInfoModel.h"

@interface RYGMonthRankingViewController ()<UITableViewDataSource,UITableViewDelegate,RYGMonthRankTableViewCellDelegate>

@property(nonatomic,strong)UITableView *rankingTableView;
// 加载更多
@property(nonatomic,strong)MJRefreshGifFooter *footer;
// 本周我的总利润
@property(nonatomic,strong)UILabel *lblAllProfitTitle;
@property(nonatomic,strong)UILabel *lblAllProfit;
// 我的排名
@property(nonatomic,strong)UILabel *lblMyRankTitle;
@property(nonatomic,strong)UILabel *lblMyRank;
// 排名变化标记
@property(nonatomic,strong)UIImageView *myRankChangeIcon;

@property(nonatomic,strong)RYGMonthRankingModel *rankingModel;
// 下一页的标识
@property(nonatomic,strong)NSString *next;
// 排行榜的数据
@property(nonatomic,strong)NSMutableArray *rankingList;
// 是否有更多数据
@property(nonatomic,assign) BOOL isMoreData;

// 个人信息
@property(nonatomic,strong)UIView *personInfoView;

@end

@implementation RYGMonthRankingViewController

#pragma mark -Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"月排行榜"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"月排行榜"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self aRefresh];
    [self setupRank];
    [self setupMyRankView];
}

#pragma mark- private method
#pragma mark- 初期化画面内容

- (void)setupRank {
    _rankingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    _rankingTableView.delegate = self;
    _rankingTableView.dataSource = self;
    _rankingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rankingTableView.backgroundColor = ColorRankBackground;
    [self.view addSubview:_rankingTableView];
    
    __weak __typeof(&*self)weakself = self;
    [self.rankingTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [self.rankingTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 LoadData];
    } noMoreDataTitle:@"只有前200名才能上榜哦~"];
}

#pragma mark 初期刷新，下拉刷新
- (void)aRefresh {
    _rankingList = [NSMutableArray array];
    _next = 0;
    _isMoreData = YES;
    [self LoadData];
}

#pragma mark 初期化我的排名信息
- (void)setupMyRankView {
    _personInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 22)];
    self.personInfoView.backgroundColor = ColorRankMyRankBackground;
    UITapGestureRecognizer *switchMyInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchMyInfo)];
    [self.personInfoView addGestureRecognizer:switchMyInfo];
    
    // 本周我的总利润
    _lblAllProfitTitle = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 72, self.personInfoView.height)];
    _lblAllProfitTitle.font = [UIFont systemFontOfSize:FontSecondTitle];
    _lblAllProfitTitle.textColor = ColorSecondTitle;
    _lblAllProfitTitle.textAlignment = NSTextAlignmentLeft;
    _lblAllProfitTitle.text = @"本月我的总利润：";
    [self.personInfoView addSubview:_lblAllProfitTitle];
    
    _lblAllProfit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblAllProfitTitle.frame), 0, 100, self.personInfoView.height)];
    _lblAllProfit.font = [UIFont systemFontOfSize:FontSecondTitle];
    _lblAllProfit.textColor = ColorSecondTitle;
    _lblAllProfit.textAlignment = NSTextAlignmentLeft;
    [self.personInfoView addSubview:_lblAllProfit];
    
    // 排名变化标记
    _myRankChangeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.personInfoView.width - 30 - 6, (self.personInfoView.height - 9) / 2, 6, 9)];
    [self.personInfoView addSubview:_myRankChangeIcon];
    
    _lblMyRank = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_myRankChangeIcon.frame) - 5 - 46, 0, 46, self.personInfoView.height)];
    _lblMyRank.font = [UIFont systemFontOfSize:FontSecondTitle];
    _lblMyRank.textColor = ColorSecondTitle;
    _lblMyRank.textAlignment = NSTextAlignmentLeft;
    [self.personInfoView addSubview:_lblMyRank];
    
    _lblMyRankTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblMyRank.frame)- 46, 0, 46, self.personInfoView.height)];
    _lblMyRankTitle.font = [UIFont systemFontOfSize:FontSecondTitle];
    _lblMyRankTitle.textColor = ColorSecondTitle;
    _lblMyRankTitle.textAlignment = NSTextAlignmentLeft;
    _lblMyRankTitle.text = @"我的排名：";
    [self.personInfoView addSubview:_lblMyRankTitle];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.personInfoView.height - SeparatorLineHeight, self.personInfoView.width, SeparatorLineHeight)];
    lineView.backgroundColor = ColorLine;
    [self.personInfoView addSubview:lineView];
}

#pragma mark 加载数据

- (void)LoadData{
    RYGRankingListParam *rankingListParam = [RYGRankingListParam param];
    rankingListParam.next = _next;
    [RYGHttpRequest postWithURL:Ranking_Month_list params:rankingListParam.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.rankingModel = [RYGMonthRankingModel objectWithKeyValues:dic];
        [_rankingList addObjectsFromArray:self.rankingModel.datas];
        _next = self.rankingModel.next;
        // 没有加载更多
        if (self.rankingModel.page_is_last || [self.rankingModel.page_is_last isEqualToString:@"0"]) {
            _isMoreData = NO;
        }
        [self.rankingTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 更新排行榜的列表
- (void)reloadRankingTable {
    // 是否登录
    if ([RYGUtility isLogin]) {
        self.rankingTableView.tableHeaderView = self.personInfoView;
    }
    else{
        self.rankingTableView.tableHeaderView = nil;
    }
    
    [self.rankingTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.rankingTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self updateHeadContent];
    [self.rankingTableView reloadData];
}

#pragma mark 更新我排名的信息
- (void)updateHeadContent {
    _lblAllProfit.text = self.rankingModel.my_ranking.margin;
    _lblMyRank.text = self.rankingModel.my_ranking.ranking;
    if ([self.rankingModel.my_ranking.ranking_floating isEqualToString:@"1"]) {
        _myRankChangeIcon.image = [UIImage imageNamed:@"arrow_up"];
    }
    else if([self.rankingModel.my_ranking.ranking_floating isEqualToString:@"2"])
    {
        _myRankChangeIcon.image = [UIImage imageNamed:@"arrow_down"];
        
    }
    else {
        _myRankChangeIcon.image = [UIImage imageNamed:@"no_change"];
    }
    
    CGSize myRankSize =  RYG_TEXTSIZE(_lblMyRank.text,[UIFont systemFontOfSize:FontSecondTitle]);
    _lblMyRank.frame = CGRectMake(CGRectGetMinX(_myRankChangeIcon.frame) - 5 - myRankSize.width, 0, myRankSize.width, _lblMyRank.height);
    _lblMyRankTitle.frame = CGRectMake(CGRectGetMinX(_lblMyRank.frame)- 46, 0, 46, _lblMyRankTitle.height);
}

#pragma mark-
#pragma mark UITableViewDataSource UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.rankingList && self.rankingList.count>0) {
        return self.rankingList.count;
    }
    return 0;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MonthRankCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *weekRankCellIdentify=@"WeekRankCellIdentify";
    RYGMonthRankTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:weekRankCellIdentify];
    if (!cell) {
        cell=[[RYGMonthRankTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weekRankCellIdentify];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    if (self.rankingList.count > 0) {
        cell.personRankingModel = [self.rankingList objectAtIndex:indexPath.row];
        cell.delegate=self;
        cell.cellIndex = indexPath.row;
    }

    return cell;
}

// 点击我的排名,进入"我的个人主页";
- (void)switchMyInfo {
    RYGUserInfoModel *userInfoModel = [RYGUtility getUserInfo];
    if (self.toMyPersonBlock) {
        self.toMyPersonBlock(userInfoModel.userid);
    }
}

#pragma mark-
#pragma mark RYGWeekRankTableViewCellDelegate
- (void)clickOtherPerson:(NSString *)userId {
    if (self.toOtherPersonBlock) {
        self.toOtherPersonBlock(userId);
    }
}

- (void)clickAttentionButton:(NSString *)userId op:(NSString *)op index:(NSInteger)index{
    // 是否登录
    if ([RYGUtility isLogin]) {
        RYGAttentionParam *attentionParam = [RYGAttentionParam param];
        attentionParam.userid = userId;
        attentionParam.op = op;
        __weak __typeof(&*self)weakself = self;
        [RYGHttpRequest postWithURL:User_Attention params:attentionParam.keyValues success:^(id json) {
            NSNumber *code = [json valueForKey:@"code"];
            if (code && code.integerValue == 0) {
                RYGMonthPersonModel *model = [weakself.rankingList objectAtIndex:index];
                if ([op isEqualToString:@"0"]) {
                    model.is_attention = @"1";
                }
                else {
                    model.is_attention = @"2";
                }
            }
            [self reloadRankingTable];
        } failure:^(NSError *error) {
            
        }];
    }
    else {
        
    }

}
- (void)setModel {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];

    CGFloat PointStartX = 0.0f; // 起始点坐标
    CGFloat currentPointY = 16;
    for (int i = 0; i < 30; i++) {
        if (i == 0) {
            currentPointY = 15;
        }
        else if(i == 1) {
            currentPointY = 14;
        }
        else if(i == 2) {
            currentPointY = 13;
        }
        else if(i == 3) {
            currentPointY = 15;
        }
        else if(i == 4) {
            currentPointY = 11;
        }
        else if(i == 11) {
            currentPointY = 14;
        }
        else if(i == 15) {
            currentPointY = 12;
        }
        else if(i == 19) {
            currentPointY = 11;
        }
        else if(i == 23) {
            currentPointY = 25;
        }

        CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
        [tempArray addObject:NSStringFromCGPoint(currentPoint)]; // 把坐标添加进新数组
        PointStartX += 1 + 1; // 生成下一个点的x轴
    }
}

- (void)dealloc {
    NSLog(@"RYGMonthRankingViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
