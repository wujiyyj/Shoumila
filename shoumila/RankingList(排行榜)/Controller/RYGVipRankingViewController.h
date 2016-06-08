//
//  RYGVipRankingViewController.h
//  VIP榜
//
//  Created by jiaocx on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"

// 切换到我的个人主页
typedef void(^SwitchMyPersonBlock)(NSString *userId);
// 切换到他的个人主页
typedef void(^SwitchOtherPersonBlock)(NSString *userId);
// 跟TA收米
typedef void(^SwitchBuyBlock) (NSString *userId);

@interface RYGVipRankingViewController : RYGBaseViewController

@property(nonatomic,copy)SwitchMyPersonBlock toMyPersonBlock;
@property(nonatomic,copy)SwitchOtherPersonBlock toOtherPersonBlock;
@property(nonatomic,copy)SwitchBuyBlock toBuyBlock;

// 刷新
- (void)aRefresh;

@end
