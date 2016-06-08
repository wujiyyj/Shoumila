//
//  RYGScoreViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGScoreViewController.h"
#import "RYGScoreGQParam.h"
#import "RYGHttpRequest.h"
#import "RYGScoreGQList.h"
#import "RYGScoreTodayList.h"
#import "MJRefresh.h"
#import "RYGScoreHeaderView.h"
#import "RYGScoreTableViewCell.h"
#import "RYGSelectorView.h"
#import "MBProgressHUD.h"
@interface RYGScoreViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) RYGScoreGQList  *scoreGQList;
@property(nonatomic,strong) RYGScoreGQList  *scoreGQListCache;
@property(nonatomic,strong) RYGScoreGQList   *scoreTodayList;
@property(nonatomic,strong) NSMutableArray   *scoreTodayListCache;
@property(nonatomic,strong) NSMutableArray  *scoreTodayArray;
@property(nonatomic,strong) NSMutableArray  *scoreGQCellHeight;
@property(nonatomic,strong) NSString        *next;
@property(nonatomic,strong) UITableView     *mainTableView;
@property(nonatomic,assign) BOOL            isMoreData;
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UIView  *bgView;
@property(nonatomic,strong) RYGSelectorView *selectorView;
@property(nonatomic,strong) NSString    *leagues;
@property(nonatomic,strong) NSMutableSet     *leaguesParam;
@property(nonatomic,strong) NSString *gqCount;
@property(nonatomic,strong) NSString *todayCount;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) UIView *emptyView;
@property(nonatomic,assign) BOOL isNotEmpty;
@end

@implementation RYGScoreViewController{
    BOOL btnIsSelect;
    BOOL scoreQGSelected;
    BOOL scoreTodaySelected;
}

-(NSMutableSet *)leaguesParam{
    if (!_leaguesParam) {
        _leaguesParam = [NSMutableSet set];
        [_leaguesParam addObjectsFromArray:_scoreGQList.leagues];
        [_leaguesParam addObjectsFromArray:_scoreTodayList.leagues];
    }
    return _leaguesParam;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapC)];
    [_bgView addGestureRecognizer:tap];
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40) style:UITableViewStylePlain];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _emptyView = [self createEmptyView];
    [self.view addSubview:_emptyView];
    [self.view addSubview:_mainTableView];
    __weak __typeof(&*self)weakself = self;
    
    [_mainTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [_mainTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadMoreData];
    } noMoreDataTitle:@"没有更多数据"];
    
    if (_needCancel) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:kPublishVCCancelNotification object:nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self LoadData];
    _timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(LoadData) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    [MobClick beginLogPageView:@"比分"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
    }
    
    [MobClick endLogPageView:@"比分"];
}
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)aRefresh {
    _next = 0;
    _isMoreData = YES;
//    _leagues = @"";
//    _keyword = nil;
    [self LoadData];
}

#pragma mark - loadData

- (void)LoadData{
    RYGScoreGQParam *gqParam = [RYGScoreGQParam param];
    gqParam.leagues = _leagues;
    gqParam.next = nil;
    gqParam.count = @"500";
    gqParam.key = _keyword;
    if (!scoreQGSelected) {
        [RYGHttpRequest postWithURL:Score_Gq params:gqParam.keyValues success:^(id json) {
            _gqCount = [json valueForKeyPath:@"data.count"];
            _isNotEmpty = [_gqCount boolValue];
            NSMutableDictionary *dic = [json valueForKey:@"data"];
            _scoreGQList = [RYGScoreGQList objectWithKeyValues:dic];
            _scoreGQListCache = _scoreGQList;
            [_scoreGQList.datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                RYGScoreGQModel *scoreGQModel = obj;
                NSUInteger count = scoreGQModel.match.count;
                CGFloat cellHeight = 23 + 88*count;
                scoreGQModel.cellHeight = cellHeight;
            }];
            [self reloadRankingTable];
        } failure:^(NSError *error) {
            [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
        }];
    }

    RYGScoreGQParam *rankingListParam1 = [RYGScoreGQParam param];
    rankingListParam1.next = @"";
    rankingListParam1.leagues = _leagues;
    rankingListParam1.key = _keyword;
    if (!scoreTodaySelected) {
        [RYGHttpRequest postWithURL:Score_Today params:rankingListParam1.keyValues success:^(id json) {
            _todayCount = [json valueForKeyPath:@"data.count"];
            NSMutableDictionary *dic = [json valueForKey:@"data"];
            _scoreTodayList = [RYGScoreGQList objectWithKeyValues:dic];
            _scoreTodayListCache = _scoreTodayList.datas;
            _scoreTodayArray = _scoreTodayList.datas;
            if (!_scoreTodayArray.count&&!_isNotEmpty) {
                _mainTableView.alpha = 0;
            }else {
                _mainTableView.alpha = 1;
                [_scoreTodayArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    RYGScoreGQModel *scoreGQModel = obj;
                    NSUInteger count = scoreGQModel.match.count;
                    CGFloat cellHeight = 23 + 88*count;
                    scoreGQModel.cellHeight = cellHeight;
                }];
                if (self.scoreTodayList.page_is_last || [self.scoreTodayList.page_is_last isEqualToString:@"0"]) {
                    _isMoreData = NO;
                }
                _next = _scoreGQList.next;
                [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
                [self reloadRankingTable];

            }
            
        } failure:^(NSError *error) {
            [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
        }];
    }
}

- (void)loadMoreData{
    RYGScoreGQParam *rankingListParam1 = [RYGScoreGQParam param];
    rankingListParam1.next = _next;
    rankingListParam1.leagues = _leagues;
    [RYGHttpRequest postWithURL:Score_Today params:rankingListParam1.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        _scoreTodayList  = [RYGScoreGQList objectWithKeyValues:dic];
        [_scoreTodayArray addObjectsFromArray:_scoreTodayList.datas];
        _scoreTodayListCache = _scoreTodayArray;
        [_scoreTodayArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGScoreGQModel *scoreGQModel = obj;
            NSUInteger count = scoreGQModel.match.count;
            CGFloat cellHeight = 23 + 88*count;
            scoreGQModel.cellHeight = cellHeight;
        }];
        if (self.scoreTodayList.page_is_last || [self.scoreTodayList.page_is_last isEqualToString:@"0"]) {
            _isMoreData = NO;
        }
        _next = _scoreGQList.next;
        [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        [self.mainTableView.header setState:MJRefreshHeaderStateIdle];
    }];

}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.view addSubview:_bgView];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.7;
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSString *searchText = searchBar.text;
    if (!searchText.length) {
        _keyword = @"";
        _leagues = nil;
        [self tapC];
        [self LoadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _keyword = searchBar.text;
    _leagues = nil;
    [self tapC];
    [self LoadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 58;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        NSString *num = [NSString stringWithFormat:@"%@",_gqCount?:@"0"];
        RYGScoreHeaderView *header = [[RYGScoreHeaderView alloc]initWithNum:num title:@"滚球"];
        UIButton  *titleBtn = [[RYGButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 50, 33)];
        titleBtn.userInteractionEnabled = NO;
        [titleBtn setTitle:@"滚球" forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleBtn setImage:[UIImage imageNamed:@"arrow_up1"] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"arrow_down1"] forState:UIControlStateSelected];
        titleBtn.selected = scoreQGSelected;
        [header addSubview:titleBtn];
        header.btnClickBlock = ^(BOOL isSelect){
            if (_scoreGQList) {
                _scoreGQList=nil;
                scoreQGSelected = YES;
                
                [_mainTableView reloadData];
            }else{
                scoreQGSelected = NO;
                _scoreGQList = _scoreGQListCache;
                [_mainTableView reloadData];
            }
            
        };
        return header;
    }else{
        NSString *num = [NSString stringWithFormat:@"%@",_todayCount?:@"0"];
        RYGScoreHeaderView *header = [[RYGScoreHeaderView alloc]initWithNum:num title:@"今日"];
        UIButton  *titleBtn = [[RYGButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 50, 33)];
        titleBtn.userInteractionEnabled = NO;
        [titleBtn setTitle:@"今日" forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleBtn setImage:[UIImage imageNamed:@"arrow_up1"] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"arrow_down1"] forState:UIControlStateSelected];
        titleBtn.selected = scoreTodaySelected;
        [header addSubview:titleBtn];
        header.btnClickBlock = ^(BOOL isSelect){
            if (_scoreTodayArray) {
                _scoreTodayArray=nil;
                titleBtn.selected = YES;
                scoreTodaySelected = YES;
                [_mainTableView reloadData];
            }else{
                scoreTodaySelected = NO;
                titleBtn.selected = NO;
                _scoreTodayArray = _scoreTodayListCache;
                [_mainTableView reloadData];
            }
        };
        return header;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _scoreGQList.datas.count;
    }else{
        return _scoreTodayArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RYGScoreGQModel *scoreGQModel = _scoreGQList.datas[indexPath.row];
        return scoreGQModel.cellHeight;
    }else{
        RYGScoreGQModel *scoreGQModel = _scoreTodayArray[indexPath.row];
        return scoreGQModel.cellHeight;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *scoreCell=@"scoreCell";
    RYGScoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:scoreCell];
    if (!cell) {
        cell=[[RYGScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scoreCell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    cell.scoreCleckBlock = _scoreCleckBlock;
    if (indexPath.section == 0) {
        cell.scoureGQModel = _scoreGQList.datas[indexPath.row];
    }else{
        cell.scoureGQModel = _scoreTodayArray[indexPath.row];
    }
    return cell;
}

#pragma mark - PrivateMetord

- (void)setUpNav{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"selector_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(seletor)];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_bar"]];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 255, 30)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜你想看的比赛";
    self.navigationItem.titleView = _searchBar;
    
}

- (void)reloadRankingTable {
    [self.mainTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.mainTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.mainTableView reloadData];
}

- (UIView *)createEmptyView{
    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIImageView* emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 135, 80, 80)];
    emptyImageView.centerX = SCREEN_WIDTH/2;
    emptyImageView.image = [UIImage imageNamed:@"default_picture"];
    [emptyView addSubview:emptyImageView];
    
    UILabel* emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 235, 200, 20)];
    emptyLabel.centerX = SCREEN_WIDTH/2;
    emptyLabel.text = @"目前暂无赛事信息，请稍后再试";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = ColorSecondTitle;
    emptyLabel.font = [UIFont systemFontOfSize:14];
    [emptyView addSubview:emptyLabel];
    return emptyView;
}


-(void)seletor{
    [_searchBar resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.7;
    }];
//    if (!_leaguesParam) {
//        _leaguesParam = _scoreGQList.leagues;
//    }
    _selectorView = [[RYGSelectorView alloc]initWithData:self.leaguesParam];
    _selectorView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    __weak RYGScoreViewController *weakSelf = self;
    _selectorView.cancelBlock = ^{
        [weakSelf tapC];
    };
    _selectorView.confirmBlock = ^(NSString *items){
        _keyword = @"";
        _leagues = items;
        [weakSelf tapC];
        [weakSelf LoadData];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_selectorView];
}

-(void)tapC{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0;
        _selectorView.alpha = 0;
    }completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_selectorView removeFromSuperview];
    }];
    
    [_searchBar resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
