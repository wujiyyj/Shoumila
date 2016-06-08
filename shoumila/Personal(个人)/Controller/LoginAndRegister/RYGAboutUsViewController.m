//
//  RYGAboutUsViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/1.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAboutUsViewController.h"

@interface RYGAboutUsViewController ()
{
    UIView* logoView;
    UITableView* mainTableView;
}
@end

@implementation RYGAboutUsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"关于"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"关于"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"关于我们";
    
    [self createHeaderView];
    [self createMainView];
    
}

- (void)createHeaderView {
    logoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    logoView.userInteractionEnabled = YES;
    logoView.backgroundColor = ColorRankMyRankBackground;
    [self.view addSubview:logoView];
    
    UIImageView* photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 40, 90, 90)];
    [photoImageView setImage:[UIImage imageNamed:@"user_logo"]];
    photoImageView.center = CGPointMake(SCREEN_WIDTH/2, 85);
    [logoView addSubview:photoImageView];
    
    UILabel* infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 145, 90, 15)];
    infoLabel.centerX = SCREEN_WIDTH/2;
    infoLabel.text = @"收米啦 0.0.1";
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textColor = ColorSecondTitle;
    [logoView addSubview:infoLabel];
}

- (void)createMainView {
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 44*3) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = NO;
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray* titleArray = [NSArray arrayWithObjects:@"介绍",@"版本",@"给我们好评！", nil];
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 20)];
    titleLabel.text = titleArray[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = ColorName;
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.row != 2) {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.contentView.size.height-0.5, SCREEN_WIDTH-30, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    else {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    if (indexPath.row == 0) {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    
    if (indexPath.row != 1) {
        UIImageView* arr_icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-23, 14, 8, 14)];
        arr_icon.image = [UIImage imageNamed:@"user_arrow"];
        [cell.contentView addSubview:arr_icon];
    }
    else {
        UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-215, 12, 200, 20)];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.text = @"0.0.1";
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = ColorRankMedal;
        [cell.contentView addSubview:contentLabel];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"row = %ld",indexPath.row);
    if (indexPath.row == 0) {
        
        
    }
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
