//
//  RYGFansViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGFansViewController.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGAllListParam.h"
#import "RYGHttpRequest.h"
#import "RYGFansListModel.h"
#import "RYGFansPersonModel.h"
#import "RYGUserCenterViewController.h"

//粉丝
@interface RYGFansViewController ()

@property(nonatomic,strong) RYGFansListModel* fansListModel;
@property(nonatomic,strong) RYGFansPersonModel* fansPersonModel;
@property(nonatomic,strong) NSMutableArray* fansListArray;
@property(nonatomic,strong) NSDictionary* fans_num_dic;

@end

@implementation RYGFansViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"粉丝";
    [MobClick beginLogPageView:@"粉丝"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"粉丝"];
}

- (void)loadNewData{
    RYGAllListParam *listParam = [RYGAllListParam param];
    listParam.userid = _userid;
    [RYGHttpRequest postWithURL:User_FunsList params:listParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.fansListModel = [RYGFansListModel objectWithKeyValues:dic];
        [_fansListArray addObjectsFromArray:self.fansListModel.datas];
        _fans_num_dic = self.fansListModel.funs_num;
        
        [self reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData
{
    [self createContentView];
    [self createFansView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"粉丝";
    self.view.backgroundColor = ColorRankBackground;
    
    _fansListArray = [[NSMutableArray alloc]init];
    _fans_num_dic = [[NSDictionary alloc]init];
    
    [self loadNewData];
}

- (void)createContentView
{
    UIView* contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    contentView.backgroundColor = ColorRankMyRankBackground;
    [self.view addSubview:contentView];
    
    UILabel* myFansLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 110, 30)];
    myFansLabel.text = @"关注我的粉丝数：";
    myFansLabel.textAlignment = NSTextAlignmentLeft;
    myFansLabel.textColor = [UIColor blackColor];
    myFansLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:myFansLabel];
    
    UILabel* myFansNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 0, 100, 30)];
    myFansNumberLabel.text = [NSString stringWithFormat:@"%@人",[_fans_num_dic objectForKey:@"funs_num"]];
    myFansNumberLabel.textAlignment = NSTextAlignmentLeft;
    myFansNumberLabel.textColor = ColorRateTitle;
    myFansNumberLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:myFansNumberLabel];
    
    UILabel* newFansLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-126, 0, 100, 30)];
    newFansLabel.textAlignment = NSTextAlignmentRight;
    newFansLabel.text = [NSString stringWithFormat:@"今日新增：%@人",[_fans_num_dic objectForKey:@"today_add_num"]];
    newFansLabel.textColor = [UIColor blackColor];
    newFansLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:newFansLabel];
    
    UIImageView* arrow_upImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-21, 10, 6, 9)];
    arrow_upImageView.image = [UIImage imageNamed:@"user_arrow_up"];
    [contentView addSubview:arrow_upImageView];
}

- (void)createFansView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(42, 62)];//设置cell的尺寸
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置其边界
    
    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH-30, SCREEN_HEIGHT-64-30) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = ColorRankBackground;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [self.view addSubview:collectionView];
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _fansListArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    _fansPersonModel = [_fansListArray objectAtIndex:indexPath.item];
    
    UIImageView* fansImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 32, 32)];
    [fansImageView setImageURL:[NSURL URLWithString:_fansPersonModel.user_logo] placeholder:[UIImage imageNamed:@"user_head"]];
//    [fansImageView setImage:[UIImage imageNamed:@"user_package"]];
    [fansImageView.layer setCornerRadius:4];
    [cell addSubview:fansImageView];
    
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(-2, 61.5, 46, 0.5)];
    if (indexPath.row == _fansListArray.count-1) {
        lineView.frame = CGRectMake(-SCREEN_WIDTH, 61.5, SCREEN_WIDTH*2, 0.5);
    }
    lineView.backgroundColor = ColorLine;
    [cell addSubview:lineView];
    
    cell.backgroundColor = ColorRankBackground;
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(42, 62);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, -2, 0, -2);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor yellowColor];
    _fansPersonModel = [_fansListArray objectAtIndex:indexPath.item];
    
    NSString* userId = _fansPersonModel.userid;
    RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
    otherPersonViewController.userId = userId;//@"70043800";
    [self.navigationController pushViewController:otherPersonViewController animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
