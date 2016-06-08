//
//  RYGOrderDetailViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGOrderDetailViewController.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGPayTypeTableViewCell.h"
#import "RYGPayResultViewController.h"
#import "RYGOrderDetailParam.h"
#import "RYGHttpRequest.h"
#import "RYGOrderDetailModel.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface RYGOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* mTableView;
    
    NSString* ali_pay_str;
    NSMutableDictionary* wx_pay_str;
    
    NSString* pay_type;
}
@property (nonatomic,strong)    RYGOrderDetailModel* orderDetailModel;

@end

@implementation RYGOrderDetailViewController
@synthesize hasPaid;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"订单详情"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"订单详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"订单详情";
    
    hasPaid = NO;
    pay_type = @"0";    //pay_type = 0  支付宝     pay_type = 1  微信支付
    
    [self loadNewData];
//    [self createMainTablView];
}

- (void)loadNewData{
    RYGOrderDetailParam *orderDetailParam = [RYGOrderDetailParam param];
    orderDetailParam.order_no = _order_no;
    [RYGHttpRequest postWithURL:OrderPay_detail params:orderDetailParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        _orderDetailModel = [RYGOrderDetailModel objectWithKeyValues:dic];
        if ([_orderDetailModel.status intValue] == 1) {
            hasPaid = NO;
        }
        else {
            hasPaid = YES;
        }
        
        if (_orderDetailModel.pay_str.count) {
            for (int i = 0; i<_orderDetailModel.pay_str.count; i++) {
                if ([[_orderDetailModel.pay_str[i] objectForKey:@"type"] intValue] == 1) {
                    ali_pay_str = [_orderDetailModel.pay_str[i]objectForKey:@"pay_str"];
                }
                else if ([[_orderDetailModel.pay_str[i] objectForKey:@"type"] intValue] == 2) {
                    wx_pay_str = [_orderDetailModel.pay_str[i]objectForKey:@"pay_obj"];
                }
            }
        }
        
        [self createMainTablView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createMainTablView {
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    mTableView.backgroundColor = ColorRankMyRankBackground;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [mTableView registerClass:[RYGPayTypeTableViewCell class] forCellReuseIdentifier:@"PayCell"];
    mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mTableView];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (hasPaid == NO) {
        return 3;
    }
    else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (hasPaid == NO) {
        if (section != 0) {
            return 0;
        }
        return 10;
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hasPaid == NO) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 62;
        }
        else if (indexPath.section == 1) {
            return 56;
        }
        else if (indexPath.section == 2) {
            return 70;
        }
        return 44;
    }
    else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 62;
        }
        else if (indexPath.section == 1) {
            return 70;
        }
        else {
            return 44;
        }
    }
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (hasPaid == NO) {
        if (section == 0) {
            return 6;
        }
        else if (section == 1) {
            //判断是否安装微信客户端
            if ([WXApi isWXAppInstalled]) {
                return 2;
            }
            else {
                return 1;
            }
        }
        return 1;
    }
    else {
        if (section == 0) {
            return 7;
        }
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hasPaid == NO) {
        if (indexPath.section == 0) {
        
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            NSArray* titleArray = [NSArray arrayWithObjects:@"限定场次",@"需要净胜",@"目标胜率",@"服务期限",@"订阅价格", nil];
            NSArray* contentArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@场",_orderDetailModel.matches],[NSString stringWithFormat:@"%@场",_orderDetailModel.target_win],[NSString stringWithFormat:@"%@％",_orderDetailModel.target_winrate],[NSString stringWithFormat:@"%@",_orderDetailModel.service_term],[NSString stringWithFormat:@"¥%@",_orderDetailModel.fee], nil];
//            NSArray* contentArray = [NSArray arrayWithObjects:@"68场",@"32场",@"90％",@"7月29日-8月29日",@"¥388.00", nil];
            
            if (indexPath.row != 5) {
                UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.height-0.5, SCREEN_WIDTH-30, 0.5)];
                bottomlineView.backgroundColor = ColorLine;
                [cell.contentView addSubview:bottomlineView];
            }
            else {
                UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height-0.5, SCREEN_WIDTH, 0.5)];
                bottomlineView.backgroundColor = ColorLine;
                [cell.contentView addSubview:bottomlineView];
            }
            
            
            if (indexPath.section == 0 && indexPath.row == 0) {
                UIImageView* photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 32, 32)];
                [photoImageView setImageURLStr:_orderDetailModel.user_logo placeholder:nil];
//                photoImageView.image = [UIImage imageNamed:@"user_data"];
                photoImageView.layer.cornerRadius = 4;
                [cell.contentView addSubview:photoImageView];
                
                UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 15, 80, 15)];
//                nameLabel.text = @"小凯撒";
                nameLabel.text = [NSString stringWithFormat:@"%@",_orderDetailModel.user_name];
                nameLabel.textColor = ColorName;
                nameLabel.font = [UIFont systemFontOfSize:12];
                [cell.contentView addSubview:nameLabel];
                
                UILabel* packageLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 30, 60, 15)];
                packageLabel.text = @"套餐";
                packageLabel.textColor = ColorName;
                packageLabel.font = [UIFont systemFontOfSize:11];
                [cell.contentView addSubview:packageLabel];
            }
            else if (indexPath.section == 0) {
                UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, 80, 20)];
                titleLabel.text = [titleArray objectAtIndex:indexPath.row-1];
                titleLabel.textColor = ColorName;
                titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:titleLabel];
                
                UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 11, 150, 20)];
                contentLabel.text = [contentArray objectAtIndex:indexPath.row-1];
                contentLabel.textColor = ColorName;
                contentLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:contentLabel];
            }
            
            return cell;
        }
        else if (indexPath.section == 1) {
            RYGPayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.paywayImage.image = [UIImage imageNamed:@"order_zhifubao"];
                cell.paywayLabel.text = @"支付宝支付";
                cell.paywayTipsLabel.text = @"推荐安装支付宝客户端的用户使用";
                [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"order_select"] forState:UIControlStateNormal];
                
                pay_type = @"0";
                
                UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                lineView.backgroundColor = ColorLine;
                [cell.contentView addSubview:lineView];
                
                UIView* middlelineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.height-0.5, SCREEN_WIDTH-30, 0.5)];
                middlelineView.backgroundColor = ColorLine;
                [cell.contentView addSubview:middlelineView];
            }
            else if (indexPath.row == 1) {
                cell.paywayImage.image = [UIImage imageNamed:@"order_weixin"];
                cell.paywayLabel.text = @"微信支付";
                cell.paywayTipsLabel.text = @"推荐安装微信5.0及以上版本的用户使用";
                [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
                
                UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height-0.5, SCREEN_WIDTH, 0.5)];
                lineView.backgroundColor = ColorLine;
                [cell.contentView addSubview:lineView];
            }
            cell.userInteractionEnabled = YES;
            cell.selectButton.tag = indexPath.row+100;
            [cell.selectButton addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = ColorRankMyRankBackground;
            
            UIButton* gotoPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            gotoPayButton.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, 40);
            gotoPayButton.layer.cornerRadius = 4;
            [gotoPayButton setTitle:@"去支付" forState:UIControlStateNormal];
            [gotoPayButton setBackgroundColor:ColorRateTitle];
            [gotoPayButton addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:gotoPayButton];
            
            return cell;
        }
    }
    else {
        if (indexPath.section == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            NSArray* titleArray = [NSArray arrayWithObjects:@"购买类型",@"推荐场次",@"目标胜率",@"服务时间",@"订阅价格",@"创建时间", nil];
            NSArray* contentArray = [NSArray arrayWithObjects:@"达人套餐",[NSString stringWithFormat:@"%@",_orderDetailModel.matches],[NSString stringWithFormat:@"%@％",_orderDetailModel.target_winrate],[NSString stringWithFormat:@"%@",_orderDetailModel.service_term],[NSString stringWithFormat:@"¥%@",_orderDetailModel.fee],[NSString stringWithFormat:@"%@",_orderDetailModel.ctime], nil];
//            NSArray* contentArray = [NSArray arrayWithObjects:@"达人套餐",@"109",@"90％",@"7月29日-8月29日",@"¥388.00",@"2015-6-1 21:43", nil];
            
            if (indexPath.row != 6) {
                UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.height-0.5, SCREEN_WIDTH-30, 0.5)];
                bottomlineView.backgroundColor = ColorLine;
                [cell.contentView addSubview:bottomlineView];
            }
            else {
                UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.height-0.5, SCREEN_WIDTH, 0.5)];
                bottomlineView.backgroundColor = ColorLine;
                [cell.contentView addSubview:bottomlineView];
            }
            
            
            if (indexPath.section == 0 && indexPath.row == 0) {
                UIImageView* photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 32, 32)];
                [photoImageView setImageURLStr:_orderDetailModel.user_logo placeholder:nil];
//                photoImageView.image = [UIImage imageNamed:@"user_data"];
                photoImageView.layer.cornerRadius = 4;
                [cell.contentView addSubview:photoImageView];
                
                UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 15, 80, 15)];
//                nameLabel.text = @"小凯撒";
                nameLabel.text = [NSString stringWithFormat:@"%@",_orderDetailModel.user_name];
                nameLabel.textColor = ColorName;
                nameLabel.font = [UIFont systemFontOfSize:12];
                [cell.contentView addSubview:nameLabel];
                
                UILabel* packageLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 30, 60, 15)];
                packageLabel.text = @"套餐";
                packageLabel.textColor = ColorName;
                packageLabel.font = [UIFont systemFontOfSize:11];
                [cell.contentView addSubview:packageLabel];
            }
            else if (indexPath.section == 0) {
                UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, 80, 20)];
                titleLabel.text = [titleArray objectAtIndex:indexPath.row-1];
                titleLabel.textColor = ColorName;
                titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:titleLabel];
                
                UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 11, 150, 20)];
                contentLabel.text = [contentArray objectAtIndex:indexPath.row-1];
                contentLabel.textColor = ColorName;
                contentLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:contentLabel];
            }
            
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = ColorRankMyRankBackground;
            
            UILabel* paidStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 40)];
            paidStatusLabel.layer.masksToBounds = YES;
            paidStatusLabel.layer.cornerRadius = 4;
            if ([_orderDetailModel.status intValue] == 2) {
                [paidStatusLabel setBackgroundColor:ColorGreen];
                paidStatusLabel.text = @"已支付";
            } else if ([_orderDetailModel.status intValue] == 3 || [_orderDetailModel.status intValue] == 5) {
                [paidStatusLabel setBackgroundColor:ColorLine];
                paidStatusLabel.text = @"退款中";
            } else if ([_orderDetailModel.status intValue] == 4) {
                [paidStatusLabel setBackgroundColor:ColorLine];
                paidStatusLabel.text = @"已退款";
            } else if ([_orderDetailModel.status intValue] == 6) {
                [paidStatusLabel setBackgroundColor:ColorLine];
                paidStatusLabel.text = @"已关闭";
            }
            paidStatusLabel.textAlignment = NSTextAlignmentCenter;
            paidStatusLabel.textColor = [UIColor whiteColor];
            paidStatusLabel.font = [UIFont systemFontOfSize:17];
            [cell.contentView addSubview:paidStatusLabel];
            
//            UILabel* refundingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, SCREEN_WIDTH-30, 40)];
//            refundingLabel.layer.masksToBounds = YES;
//            refundingLabel.layer.cornerRadius = 4;
//            [refundingLabel setBackgroundColor:ColorLine];
//            refundingLabel.text = @"退款中";
//            refundingLabel.textAlignment = NSTextAlignmentCenter;
//            refundingLabel.textColor = [UIColor whiteColor];
//            refundingLabel.font = [UIFont systemFontOfSize:17];
//            [cell.contentView addSubview:refundingLabel];
//            
//            UILabel* refundedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 115, SCREEN_WIDTH-30, 40)];
//            refundedLabel.layer.masksToBounds = YES;
//            refundedLabel.layer.cornerRadius = 4;
//            [refundedLabel setBackgroundColor:ColorLine];
//            refundedLabel.text = @"已退款";
//            refundedLabel.textAlignment = NSTextAlignmentCenter;
//            refundedLabel.textColor = [UIColor whiteColor];
//            refundedLabel.font = [UIFont systemFontOfSize:17];
//            [cell.contentView addSubview:refundedLabel];
//            
//            UILabel* closedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 165, SCREEN_WIDTH-30, 40)];
//            closedLabel.layer.masksToBounds = YES;
//            closedLabel.layer.cornerRadius = 4;
//            [closedLabel setBackgroundColor:ColorLine];
//            closedLabel.text = @"已关闭";
//            closedLabel.textAlignment = NSTextAlignmentCenter;
//            closedLabel.textColor = [UIColor whiteColor];
//            closedLabel.font = [UIFont systemFontOfSize:17];
//            [cell.contentView addSubview:closedLabel];
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UIButton* zfbbutton = (UIButton*)[self.view viewWithTag:100];
        UIButton* wxbutton = (UIButton*)[self.view viewWithTag:101];
        if (indexPath.row == 0) {
            
            //选择支付宝支付
            pay_type = @"0";
            
            [zfbbutton setBackgroundImage:[UIImage imageNamed:@"order_select"] forState:UIControlStateNormal];
            [wxbutton setBackgroundImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
        }
        else if (indexPath.row == 1) {
            
            //选择微信支付
            pay_type = @"1";
            
            [zfbbutton setBackgroundImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
            [wxbutton setBackgroundImage:[UIImage imageNamed:@"order_select"] forState:UIControlStateNormal];
        }
        
    }
}

- (void)gotoPay {
    //gotoPay
    NSLog(@"go to Pay");
    
    if ([pay_type intValue] == 0) {
        //支付宝
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"com.ruyigu.shoumila";
        NSString *signedString = ali_pay_str;
        
        if (signedString != nil) {
            [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                //【callback 处理支付结果】
                NSLog(@"reslut = %@",resultDic);
                
                NSString* resultStatus = [resultDic objectForKey:@"resultStatus"];
                NSLog(@"resultStatus = %@",resultStatus);
                
                RYGPayResultViewController* payResultVC = [[RYGPayResultViewController alloc]init];
                //支付成功
                if ([resultStatus intValue] == 9000) {
                    payResultVC.isSuccess = YES;
                }
                else {
                    //支付失败
                    payResultVC.isSuccess = NO;
                }
                [self.navigationController pushViewController:payResultVC animated:YES];
                
            }];
        }
        
    }
    else if ([pay_type intValue] == 1) {
        //微信支付
        
        
        
        
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [NSString stringWithFormat:@"%@",[wx_pay_str objectForKey:@"mch_id"]];
        request.prepayId= [NSString stringWithFormat:@"%@",[wx_pay_str objectForKey:@"prepay_id"]];
        request.package = [NSString stringWithFormat:@"%@",[wx_pay_str objectForKey:@"_package"]];
        request.nonceStr= [NSString stringWithFormat:@"%@",[wx_pay_str objectForKey:@"nonce_str"]];
        request.timeStamp = [[NSString stringWithFormat:@"%@",[wx_pay_str objectForKey:@"timestamp"]] intValue];
        request.sign= [NSString stringWithFormat:@"%@",[wx_pay_str objectForKey:@"sign"]];
        [WXApi sendReq:request];

        
    }
    
//    RYGPayResultViewController* payResultVC = [[RYGPayResultViewController alloc]init];
//    payResultVC.isSuccess = YES;
//    [self.navigationController pushViewController:payResultVC animated:YES];
}

- (void)selectPayWay:(UIButton*)button
{
    UIButton* zfbbutton = (UIButton*)[self.view viewWithTag:100];
    UIButton* wxbutton = (UIButton*)[self.view viewWithTag:101];
    if (button.tag == 100) {
        
        //选择支付宝支付
        pay_type = @"0";
        
        [zfbbutton setBackgroundImage:[UIImage imageNamed:@"order_select"] forState:UIControlStateNormal];
        [wxbutton setBackgroundImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
    }
    else if (button.tag == 101) {
        
        //选择微信支付
        pay_type = @"1";
        
        [zfbbutton setBackgroundImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
        [wxbutton setBackgroundImage:[UIImage imageNamed:@"order_select"] forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
