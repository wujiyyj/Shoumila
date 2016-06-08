//
//  RYGAccountTableViewCell.m
//  shoumila
//
//  Created by 阴～ on 15/9/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAccountTableViewCell.h"
#import "UIImageView+RYGWebCache.h"

@implementation RYGAccountTableViewCell
@synthesize orderStatus;
@synthesize photoImageView;
@synthesize packageLabel;
@synthesize nameLabel;
@synthesize priceLabel;
@synthesize orderLabel;
@synthesize orderNumLabel;
@synthesize payImageView;
@synthesize paystateLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    orderStatus = 2;
    [self createAccountCell];
}

- (void)createAccountCell {
    
    UIView* topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLineView.backgroundColor = ColorLine;
    [self.contentView addSubview:topLineView];
    
    photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
//    [photoImageView setImageURLStr:@"" placeholder:nil];
    photoImageView.image = [UIImage imageNamed:@"user_data"];
    [self.contentView addSubview:photoImageView];
    
    packageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 40, 20)];
    packageLabel.text = @"套餐";
    packageLabel.textColor = ColorSecondTitle;
    packageLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:packageLabel];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 80, 20)];
//    nameLabel.text = @"小凯撒";
    nameLabel.textColor = ColorName;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    
    payImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 70, 55)];
//    if (orderStatus == OrderTypeStatusPaiding) {    //待支付
//        payImageView.image = [UIImage imageNamed:@"order_readyPay"];
//    }
//    else if (orderStatus == OrderTypeStatusPayed) { //已支付
//        payImageView.image = [UIImage imageNamed:@"order_hadPay"];
//    }
//    else if (orderStatus == OrderTypeStatusRefunded) {  //已退款
//        payImageView.image = [UIImage imageNamed:@"order_refund"];
//    }
//    else if (orderStatus == OrderTypeStatusRefunding) {     //退款中
//        payImageView.image = [UIImage imageNamed:@"order_paying"];
//    }
    
    [self.contentView addSubview:payImageView];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
//    priceLabel.text = @"¥5000";
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont systemFontOfSize:13];
    [payImageView addSubview:priceLabel];
    
    paystateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 50, 15)];
//    if (orderStatus == OrderTypeStatusPaiding) {    //待支付
//        paystateLabel.text = @"待支付";
//    }
//    else if (orderStatus == OrderTypeStatusPayed) { //已支付
//        paystateLabel.text = @"已支付";
//    }
//    else if (orderStatus == OrderTypeStatusRefunded) {  //已退款
//        paystateLabel.text = @"已退款";
//    }
//    else if (orderStatus == OrderTypeStatusRefunding) {     //退款中
//        paystateLabel.text = @"退款中";
//    }
    
    paystateLabel.textAlignment = NSTextAlignmentCenter;
    paystateLabel.textColor = [UIColor whiteColor];
    paystateLabel.font = [UIFont systemFontOfSize:12];
    [payImageView addSubview:paystateLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 75, SCREEN_WIDTH-30, 0.5)];
    lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:lineView];
    
    orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 75, 170, 30)];
//    orderLabel.text = @"下单日期：2015-6-1";
    orderLabel.textColor = ColorRankMedal;
    orderLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:orderLabel];
    
    orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 75, 155, 30)];
    orderNumLabel.textAlignment = NSTextAlignmentRight;
//    orderNumLabel.text = @"订单号：x9897281637101";
    orderNumLabel.textColor = ColorRankMedal;
    orderNumLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:orderNumLabel];
    
    UIView* bottonLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    bottonLineView.backgroundColor = ColorLine;
    [self.contentView addSubview:bottonLineView];
    
}

- (void)setOrderPayModel:(RYGOrderPayModel *)orderPayModel {
    _orderPayModel = orderPayModel;
//    [photoImageView setImageURLStr:_orderPayModel. placeholder:nil];
    
    nameLabel.text = [NSString stringWithFormat:@"%@",_orderPayModel.user_name];
    
    priceLabel.text = [NSString stringWithFormat:@"¥%@",_orderPayModel.fee];
    orderLabel.text = [NSString stringWithFormat:@"下单日期：%@",_orderPayModel.ctime];
    orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",_orderPayModel.order_no];
    
    orderStatus = [_orderPayModel.status intValue];
    if (orderStatus == OrderTypeStatusPaiding) {    //待支付
        paystateLabel.text = @"待支付";
        payImageView.image = [UIImage imageNamed:@"order_readyPay"];
    }
    else if (orderStatus == OrderTypeStatusPayed) { //已支付
        paystateLabel.text = @"已支付";
        payImageView.image = [UIImage imageNamed:@"order_hadPay"];
    }
    else if (orderStatus == OrderTypeStatusRefunding) {     //退款中
        paystateLabel.text = @"退款中";
        payImageView.image = [UIImage imageNamed:@"order_paying"];
    }
    else if (orderStatus == OrderTypeStatusRefunded) {  //已退款
        paystateLabel.text = @"已退款";
        payImageView.image = [UIImage imageNamed:@"order_refund"];
    }
    else if (orderStatus == OrderTypeStatusRefundFail) {  //已退款
        paystateLabel.text = @"退款失败";
        payImageView.image = [UIImage imageNamed:@"order_refund"];
    }
    else if (orderStatus == OrderTypeStatusClosed) {  //已退款
        paystateLabel.text = @"已关闭";
        payImageView.image = [UIImage imageNamed:@"order_refund"];
    }
    
}

@end
