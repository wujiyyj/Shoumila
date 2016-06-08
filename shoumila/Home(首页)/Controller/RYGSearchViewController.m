//
//  RYGSearchViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/8/8.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSearchViewController.h"
#import "RYGHomeDynamicViewController.h"
#import "RYGScoreViewController.h"
#import "RYGSearchUserListViewController.h"
#import "RYGHttpRequest.h"
#import "RYGBaseParam.h"
#import "RYGHotWordsCollectionViewCell.h"
#import "RYGActivePersonModel.h"
#import "RYGUserCenterViewController.h"

static NSString *hotWordsCell = @"hotWordsCell";
@interface RYGSearchViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)    UISearchBar *searchBar;
@property(nonatomic,strong)      UILabel *lab;
@property(nonatomic,strong)    NSArray  *userList;
@property(nonatomic,strong)    NSArray  *feedList;
@property(nonatomic,strong)    NSArray  *scoreList;
@property(nonatomic,strong)    NSArray  *dataSource;
@property(nonatomic,strong)    UICollectionView *hotWordsView;

@end

@implementation RYGSearchViewController{
    UIButton *searchPerson;
    UIButton *searchFeed;
    UIButton *searchScore;
    UIView  *selectLine;
    UIView  *contentView;
    NSInteger selectFlag;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"搜索"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"搜索"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpContent];
    [self loadData];
    [self setUpHotWords];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setUpHotWords{
    UICollectionViewFlowLayout *layut = [[UICollectionViewFlowLayout alloc]init];
    
    _hotWordsView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 44, SCREEN_WIDTH-30, SCREEN_HEIGHT) collectionViewLayout:layut];
    [_hotWordsView registerClass:[RYGHotWordsCollectionViewCell class] forCellWithReuseIdentifier:hotWordsCell];
    _hotWordsView.backgroundColor = [UIColor whiteColor];
    _hotWordsView.dataSource = self;
    _hotWordsView.delegate = self;
    [contentView addSubview:_hotWordsView];
    
}

- (void)loadData{
    RYGBaseParam *param = [RYGBaseParam param];
    [RYGHttpRequest getWithURL:Search_hot_words params:[param keyValues] success:^(id json) {
        NSDictionary *dic = [json valueForKey:@"data"];
        _userList = [dic valueForKey:@"user"];
        _feedList = [dic valueForKey:@"feed"];
        _scoreList = [dic valueForKey:@"score"];
        [self removeSubViews:0];
    } failure:^(NSError *error) {
        
    }];
}
- (void)setUpNav{
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"搜索感兴趣的人/帖子";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
}

- (void)setUpContent{
    selectFlag = 0;
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    [self.view addSubview:contentView];
    UIView *selectBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    selectBar.backgroundColor = ColorRankMyRankBackground;
    [self.view addSubview:selectBar];
    searchPerson = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 44)];
    [searchPerson addTarget:self action:@selector(searchPerson) forControlEvents:UIControlEventTouchUpInside];
    [searchPerson setTitle:@"找人" forState:UIControlStateNormal];
    [searchPerson setTitleColor:ColorName forState:UIControlStateNormal];
    [searchPerson setTitleColor:ColorRankMenuBackground forState:UIControlStateSelected];
    searchPerson.titleLabel.font = [UIFont systemFontOfSize:15];
    searchPerson.selected = YES;
    [selectBar addSubview:searchPerson];
    
    searchFeed = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44)];
    [searchFeed addTarget:self action:@selector(searchFeed) forControlEvents:UIControlEventTouchUpInside];
    [searchFeed setTitle:@"帖子" forState:UIControlStateNormal];
    [searchFeed setTitleColor:ColorName forState:UIControlStateNormal];
    [searchFeed setTitleColor:ColorRankMenuBackground forState:UIControlStateSelected];
    searchFeed.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectBar addSubview:searchFeed];
    
//    searchScore = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, 44)];
//    [searchScore addTarget:self action:@selector(searchScore) forControlEvents:UIControlEventTouchUpInside];
//    [searchScore setTitle:@"比分" forState:UIControlStateNormal];
//    [searchScore setTitleColor:ColorName forState:UIControlStateNormal];
//    [searchScore setTitleColor:ColorRankMenuBackground forState:UIControlStateSelected];
//    searchScore.titleLabel.font = [UIFont systemFontOfSize:15];
//    [selectBar addSubview:searchScore];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = ColorLine;
    [selectBar addSubview:lineView];
    
    selectLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-20, 44, 40, 1)];
    selectLine.backgroundColor = ColorRankMenuBackground;
    [selectBar addSubview:selectLine];
    
}

-(void)searchPerson{
    selectFlag = 0;
    [self removeSubViews:selectFlag];
    searchPerson.selected = YES;
    searchFeed.selected = NO;
    searchScore.selected = NO;
    selectLine.left = SCREEN_WIDTH/4-20;
    
}

-(void)searchFeed{
    selectFlag = 1;
    [self removeSubViews:selectFlag];
    searchFeed.selected = YES;
    searchScore.selected = NO;
    searchPerson.selected = NO;
    selectLine.left = SCREEN_WIDTH*3/4 - 20;
}

-(void)searchScore{
    selectFlag = 2;
    [self removeSubViews:selectFlag];
    searchScore.selected = YES;
    searchPerson.selected = NO;
    searchFeed.selected = NO;
    selectLine.left = SCREEN_WIDTH*5/6-22;
}

- (void)removeSubViews:(NSInteger)selectFlag{
    
    NSArray *array = contentView.subviews;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    array = self.childViewControllers;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromParentViewController];
    }];
    switch (selectFlag) {
        case 0:
            _dataSource = _userList;
            break;
        case 1:
            _dataSource = _feedList;
            break;
        default:
            _dataSource = _scoreList;
            break;
    }
    UILabel * lal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    lal.backgroundColor = [UIColor whiteColor];
    lal.text = @"    大家都在搜";
    lal.textColor = ColorSecondTitle;
    lal.font = [UIFont systemFontOfSize:14.0f];
    [contentView addSubview:lal];
    [contentView addSubview:_hotWordsView];
    [_hotWordsView reloadData];
}
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchResult:searchBar.text];
    searchBar.text = @"";
}

- (void)searchResult:(NSString *)searchText{
    switch (selectFlag) {
        case 0:
        {
            RYGSearchUserListViewController *userList = [[RYGSearchUserListViewController alloc]init];
            userList.keyword = searchText;
            userList.userSelectedBlock = ^(RYGActivePersonModel *userModel){
                RYGUserCenterViewController *usercenterVC = [[RYGUserCenterViewController alloc]init];
                usercenterVC.userId = userModel.userid;
                [self.navigationController pushViewController:usercenterVC animated:YES];
            };
            [self addChildViewController:userList];
            [contentView addSubview:userList.view];
        }
            break;
        case 1:
        {
            RYGHomeDynamicViewController *dynamicVC = [[RYGHomeDynamicViewController alloc]init];
            dynamicVC.keyword = searchText;
            [self addChildViewController:dynamicVC];
            [contentView addSubview:dynamicVC.view];
            break;
        }
        case 2:
        {
            RYGScoreViewController *scoreViewController = [[RYGScoreViewController alloc]init];
            scoreViewController.keyword = searchText;
            [self addChildViewController:scoreViewController];
            [contentView addSubview:scoreViewController.view];
        }
            break;
        default:
            break;
    }
    [_searchBar resignFirstResponder];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RYGHotWordsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotWordsCell forIndexPath:indexPath];
    cell.title.text = _dataSource[indexPath.row];
    cell.title.frame = CGRectMake(0, 0, cell.width, cell.height);
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize size = RYG_TEXTSIZE(_dataSource[indexPath.row], [UIFont systemFontOfSize:14.0f]);
    size.width = size.width + 20.0f;
    size.height = size.height + 15.0f;
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *keyWords = _dataSource[indexPath.row];
    [self searchResult:keyWords];
}

@end
