//
//  RYGApplyRefundViewController.m
//  shoumila
//
//  Created by 阴～ on 15/10/2.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import "RYGApplyRefundViewController.h"
#import "RYGOrderDetailParam.h"
#import "RYGHttpRequest.h"

@interface RYGApplyRefundViewController ()

@end

@implementation RYGApplyRefundViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"申请退款";
    
    [self createMainView];
}

- (void)createMainView {
    UIImageView* emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 109, 85, 58)];
    emptyImageView.centerX = SCREEN_WIDTH/2;
    emptyImageView.image = [UIImage imageNamed:@"user_personEmpty"];
    [self.view addSubview:emptyImageView];
    
    UILabel* failLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 187, 260, 30)];
    failLabel.centerX = SCREEN_WIDTH/2;
    failLabel.text = @"套餐不小心失败了，是否申请退款？";
    failLabel.textAlignment = NSTextAlignmentCenter;
    failLabel.textColor = ColorSecondTitle;
    failLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:failLabel];
    
    UIButton* noRefundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    noRefundButton.frame = CGRectMake(15, SCREEN_HEIGHT-260, SCREEN_WIDTH-30, 40);
    [noRefundButton setTitle:@"不退款，鼓励VIP达人再接再厉" forState:UIControlStateNormal];
    [noRefundButton setBackgroundColor:ColorButtonGreen];
    noRefundButton.layer.cornerRadius = 4;
    noRefundButton.tag = 1;
    [noRefundButton addTarget:self action:@selector(pressRefundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noRefundButton];
    
    UIButton* refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refundButton.frame = CGRectMake(15, SCREEN_HEIGHT-205, SCREEN_WIDTH-30, 40);
    [refundButton setTitle:@"申请退款，再看看其他的" forState:UIControlStateNormal];
    [refundButton setBackgroundColor:ColorRateTitle];
    refundButton.layer.cornerRadius = 4;
    refundButton.tag = 2;
    [refundButton addTarget:self action:@selector(pressRefundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refundButton];
}

- (void)pressRefundButton:(UIButton*)button {
    //申请退款
    RYGOrderDetailParam *orderDetailParam = [RYGOrderDetailParam param];
    orderDetailParam.order_no = _order_no;
    if (button.tag == 1) {
        //不退款
        orderDetailParam.back = @"0";
    }
    else if (button.tag == 2) {
        //退款
        orderDetailParam.back = @"1";
    }
    [RYGHttpRequest postWithURL:User_MoneyBack params:orderDetailParam.keyValues success:^(id json) {
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            //申请成功
            NSLog(@"申请成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
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
