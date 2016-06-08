//
//  RYGRankingConfig.m
//  shoumila
//
//  Created by jiaocx on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRankingConfig.h"
#import "RYGMyRankingModel.h"

#import "RYGWeekRankingModel.h"
#import "RYGWeekPersonModel.h"

#import "RYGMonthRankingModel.h"
#import "RYGMonthPersonModel.h"
#import "RYGMonthRecntModel.h"

#import "RYGVipRankingModel.h"
#import "RYGVipPersonModel.h"

#import "RYGActiveRankingModel.h"
#import "RYGActivePersonModel.h"



@implementation RYGRankingConfig

/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
    
    // 周榜单的数据模型
    [RYGWeekRankingModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGWeekPersonModel",
                 @"my_ranking" : @"RYGMyRankingModel"
                 };
    }];
   
   // 月度榜的数据模型
    [RYGMonthRankingModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGMonthPersonModel",
                 @"my_ranking" : @"RYGMyRankingModel",
                 @"recent":@"RYGMonthRecntModel"
                 };
    }];
    // VIP榜
    [RYGVipRankingModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGVipPersonModel",
                 @"my_ranking" : @"RYGMyRankingModel",
                 };
    }];
    
    // 活跃榜
    [RYGActiveRankingModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGActivePersonModel",
                 @"my_ranking" : @"RYGMyRankingModel"
                 };
    }];
    
    
    
}

@end
