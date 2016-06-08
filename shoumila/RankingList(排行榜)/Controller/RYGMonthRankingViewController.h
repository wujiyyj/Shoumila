//
//  RYGMonthRankingViewController.h
//  月度榜
//
//  Created by jiaocx on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"

// 切换到我的个人主页
typedef void(^SwitchMyPersonBlock)(NSString *userId);
// 切换到他的个人主页
typedef void(^SwitchOtherPersonBlock)(NSString *userId);

@interface RYGMonthRankingViewController : RYGBaseViewController

@property(nonatomic,copy)SwitchMyPersonBlock toMyPersonBlock;
@property(nonatomic,copy)SwitchOtherPersonBlock toOtherPersonBlock;

// 刷新
- (void)aRefresh;

@end
