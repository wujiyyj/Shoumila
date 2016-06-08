//
//  RYGVirtualAccountViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGVirtualAccountViewController.h"
#import "RYGAccountDetailViewController.h"
#import "RYGAccountViewController.h"
#import "RYGSubmitApplicationViewController.h"

@interface RYGVirtualAccountViewController ()
{
    UIView* headerView;
}

@end

@implementation RYGVirtualAccountViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"我的帐户"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"我的帐户"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"我的账户";
    
    [self createMainView];
}

- (void)createMainView {
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 107)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = ColorRankMenuBackground;
    [self.view addSubview:headerView];
    
    //账户余额
    UILabel* nameLabel = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/2-40, 24, 80, 16) withAlignment:NSTextAlignmentRight withFont:[UIFont boldSystemFontOfSize:14] withColor:[UIColor whiteColor] withText:@"帐户余额"];
    [headerView addSubview:nameLabel];
    
    UILabel* integerPriceLabel = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/2-150, 50, 160, 30) withAlignment:NSTextAlignmentRight withFont:[UIFont boldSystemFontOfSize:30] withColor:[UIColor whiteColor] withText:[NSString stringWithFormat:@"%@",_money]];
    [headerView addSubview:integerPriceLabel];
    
    UILabel* decimalPriceLabel = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/2+10, 55, 50, 25) withAlignment:NSTextAlignmentLeft withFont:[UIFont boldSystemFontOfSize:16] withColor:[UIColor whiteColor] withText:@".00元"];
    [headerView addSubview:decimalPriceLabel];
    
    UIImageView* arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-23, 40, 8, 14)];
    arrowImageView.image = [UIImage imageNamed:@"user_arrow"];
    [headerView addSubview:arrowImageView];
    
    UIButton* accountDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountDetailButton.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, headerView.height);
    [accountDetailButton addTarget:self action:@selector(goToAccountDetail) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:accountDetailButton];
    
    UIButton* drawCashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    drawCashButton.frame = CGRectMake(0, 117, SCREEN_WIDTH, 44);
    [drawCashButton setBackgroundColor:ColorRankBackground];
    [drawCashButton addTarget:self action:@selector(drawCash) forControlEvents:UIControlEventTouchUpInside];
    [drawCashButton setTitle:@"提现" forState:UIControlStateNormal];
    [drawCashButton setTitleColor:ColorName forState:UIControlStateNormal];
    drawCashButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    drawCashButton.layer.borderWidth = 0.5;
    [self.view addSubview:drawCashButton];
    
    UIButton* gotoOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoOrderButton.frame = CGRectMake(0, 171, SCREEN_WIDTH, 44);
    [gotoOrderButton setBackgroundColor:ColorRankBackground];
    [gotoOrderButton addTarget:self action:@selector(gotoOrder) forControlEvents:UIControlEventTouchUpInside];
    [gotoOrderButton setTitle:@"订单" forState:UIControlStateNormal];
    [gotoOrderButton setTitleColor:ColorName forState:UIControlStateNormal];
    gotoOrderButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    gotoOrderButton.layer.borderWidth = 0.5;
    [self.view addSubview:gotoOrderButton];
}

-(UILabel*)createLabelFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment withFont:(UIFont*)font withColor:(UIColor*)color withText:(NSString*)text
{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.numberOfLines = 1;
    label.textColor = color;
    label.text = text;
    return label;
}

- (void)drawCash
{
    //提现
    RYGSubmitApplicationViewController* submitApplicationVC = [[RYGSubmitApplicationViewController alloc]init];
    submitApplicationVC.cashMoney = _money;
    [self.navigationController pushViewController:submitApplicationVC animated:YES];
}

- (void)gotoOrder
{
    //订单
    RYGAccountViewController* accountController = [[RYGAccountViewController alloc]init];
    [self.navigationController pushViewController:accountController animated:YES];
}

- (void)goToAccountDetail
{
    RYGAccountDetailViewController* accountDetailVC = [[RYGAccountDetailViewController alloc]init];
    [self.navigationController pushViewController:accountDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
