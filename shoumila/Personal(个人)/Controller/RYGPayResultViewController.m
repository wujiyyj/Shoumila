//
//  RYGPayResultViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPayResultViewController.h"
#import "RYGPackageViewController.h"

@implementation RYGPayResultViewController
@synthesize isSuccess;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"支付结果"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"支付结果"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"支付结果";
    
    [self createMainView];
}

- (void)createMainView {
    
    UIImageView* payResultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, 130, 23, 23)];
    if (isSuccess) {
        payResultImageView.image = [UIImage imageNamed:@"order_success"];
    }
    else {
        payResultImageView.image = [UIImage imageNamed:@"order_failed"];
    }
    [self.view addSubview:payResultImageView];
    
    UILabel* payResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-12, 131, 100, 20)];
    if (isSuccess) {
        payResultLabel.text = @"支付成功！";
    }
    else {
        payResultLabel.text = @"支付失败！";
    }
    payResultLabel.textColor = ColorSecondTitle;
    payResultLabel.font = [UIFont boldSystemFontOfSize:17];
    payResultLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:payResultLabel];
    
    UILabel* tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-130, 170, 260, 20)];
    tipLabel.centerX = SCREEN_WIDTH/2;
    if (isSuccess) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"您可在我的>我的私人套餐中查看购买结果"];
        [str addAttribute:NSForegroundColorAttributeName value:ColorRankMedal range:NSMakeRange(0,3)];
        [str addAttribute:NSForegroundColorAttributeName value:ColorRateTitle range:NSMakeRange(3,9)];
        [str addAttribute:NSForegroundColorAttributeName value:ColorRankMedal range:NSMakeRange(12,7)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, 9)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(12, 2)];
        tipLabel.attributedText = str;
    }
    else {
        tipLabel.text = @"系统异常，请重新操作";
        tipLabel.textColor = ColorRankMedal;
    }
    tipLabel.font = [UIFont boldSystemFontOfSize:13];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    if (isSuccess) {
        UIButton* backPackageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backPackageButton.frame = CGRectMake(15, 326, SCREEN_WIDTH-30, 40);
        backPackageButton.layer.cornerRadius = 4;
        [backPackageButton setTitle:@"返回我的私人套餐" forState:UIControlStateNormal];
        [backPackageButton setBackgroundColor:ColorRankMenuBackground];
        [backPackageButton addTarget:self action:@selector(goBackPackage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backPackageButton];
        
    }
    else {
        UIButton* gotoPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        gotoPayButton.frame = CGRectMake(15, 326, SCREEN_WIDTH-30, 40);
        gotoPayButton.layer.cornerRadius = 4;
        [gotoPayButton setTitle:@"重新支付" forState:UIControlStateNormal];
        [gotoPayButton setBackgroundColor:ColorRateTitle];
        [gotoPayButton addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:gotoPayButton];
        
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(15, 381, SCREEN_WIDTH-30, 40);
        backButton.layer.cornerRadius = 4;
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setBackgroundColor:ColorRankMedal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    }
}

- (void)gotoPay {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goBackPackage {
    //跳转私人套餐
    RYGPackageViewController* packageController = [[RYGPackageViewController alloc]init];
    [self.navigationController pushViewController:packageController animated:YES];
}

@end
