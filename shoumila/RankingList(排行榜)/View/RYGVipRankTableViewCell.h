//
//  RYGVipRankTableViewCell.h
//  Vip榜的cell单元格
//
//  Created by jiaocx on 15/8/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYGVipPersonModel;

@protocol RYGVipRankTableViewCellDelegate <NSObject>

- (void)clickOtherPerson:(NSString *)userId;

- (void)switchBuy:(NSString *)userId;

@end

#define VipRankCellHeight 110

@interface RYGVipRankTableViewCell : UITableViewCell

@property(nonatomic,weak)id<RYGVipRankTableViewCellDelegate>delegate;

@property(nonatomic,strong)RYGVipPersonModel *personRankingModel;


@end
