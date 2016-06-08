//
//  RYGBuyPackageTableViewCell.h
//  shoumila
//
//  Created by 阴～ on 15/8/16.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGPackageBoughtModel.h"

@protocol RYGBuyPackageTableViewCellDelegate <NSObject>

- (void)clickDYButton:(NSString *)order_no;

- (void)clickTKButton:(NSString *)order_no;

@end

@interface RYGBuyPackageTableViewCell : UITableViewCell

@property(nonatomic,weak)id<RYGBuyPackageTableViewCellDelegate>delegate;

@property(nonatomic,strong)RYGPackageBoughtModel *packageBoughtModel;

@end
