//
//  RYGSearchUserListViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/9/19.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSearchUserListViewController.h"
#import "RYGHttpRequest.h"
#import "RYGActivePersonModel.h"
#import "RYGAllListParam.h"
#import "UIImageView+WebCache.h"
#import "RYGGrandeMarkView.h"

@interface RYGSearchUserListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic) UITableView *mainTableView;
@property(nonatomic) NSMutableArray *userList;
@end

@implementation RYGSearchUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-110)];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [self.view addSubview:_mainTableView];
    _userList = [NSMutableArray array];
    [self loadData];
}

- (void)loadData{
    RYGAllListParam *param = [RYGAllListParam param];
    param.keyword = _keyword;
    [RYGHttpRequest getWithURL:User_Search params:param.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        NSArray *datas = [dic valueForKey:@"datas"];
        [datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGActivePersonModel *model = [RYGActivePersonModel objectWithKeyValues:obj];
            [_userList addObject:model];
        }];
        if (datas.count==0) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = ColorName;
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"暂无数据";
            _mainTableView.tableFooterView = label;
            
        }
        [_mainTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RYGActivePersonModel *model = _userList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    UIImageView *user_logo;
    UILabel *user_name;
    RYGGrandeMarkView *grandMarkView;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        user_logo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 32, 32)];
        [view addSubview:user_logo];
        [cell.contentView addSubview:view];
        
        CGSize nameSize = [model.user_name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        user_name  = [[UILabel alloc]initWithFrame:CGRectMake(56, 0, nameSize.width, 62)];
        user_name.font = [UIFont systemFontOfSize:13];
        user_name.textColor = ColorName;
        [cell.contentView addSubview:user_name];
        
        grandMarkView = [[RYGGrandeMarkView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(user_name.frame)+5, 21, RYGMenuWidth, 20)];
        
        [cell.contentView addSubview:grandMarkView];
        
    }
    [user_logo sd_setImageWithURL:[NSURL URLWithString:model.user_logo] placeholderImage:[UIImage imageNamed:@"user_head"]];
    user_name.text = model.user_name;
    grandMarkView.integralRank = model.grade;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_userSelectedBlock) {
        _userSelectedBlock(_userList[indexPath.row]);
    }
}

@end
