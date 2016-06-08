//
//  RYGAccountTableViewCell.h
//  shoumila
//
//  Created by 阴～ on 15/9/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGOrderPayModel.h"

typedef NS_ENUM(NSInteger, OrderTypeStatus) {
    OrderTypeStatusPaiding          = 1,
    OrderTypeStatusPayed            = 2,
    OrderTypeStatusRefunding        = 3,
    OrderTypeStatusRefunded         = 4,
    OrderTypeStatusRefundFail       = 5,
    OrderTypeStatusClosed           = 6,
};

@interface RYGAccountTableViewCell : UITableViewCell

@property (nonatomic,assign)    NSInteger orderStatus;
@property (nonatomic,strong)    UIImageView* photoImageView;
@property (nonatomic,strong)    UILabel* packageLabel;
@property (nonatomic,strong)    UILabel* nameLabel;
@property (nonatomic,strong)    UILabel* priceLabel;
@property (nonatomic,strong)    UILabel* orderLabel;
@property (nonatomic,strong)    UILabel* orderNumLabel;
@property (nonatomic,strong)    UILabel* paystateLabel;
@property (nonatomic,strong)    UIImageView* payImageView;
@property (nonatomic,strong)    RYGOrderPayModel* orderPayModel;

@end
