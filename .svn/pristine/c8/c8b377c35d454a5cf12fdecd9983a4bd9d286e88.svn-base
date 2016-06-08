//
//  RYGPersonalConfig.m
//  shoumila
//
//  Created by yinyujie on 15/8/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPersonalConfig.h"

#import "RYGPersonalCenterModel.h"
#import "RYGPersonalUserModel.h"
#import "RYGPersonalDatasModel.h"

#import "RYGAttentionListModel.h"
#import "RYGAttentionPersonModel.h"

#import "RYGFansListModel.h"
#import "RYGFansPersonModel.h"

#import "RYGBlackListModel.h"
#import "RYGBlackPersonModel.h"

#import "RYGPackageBoughtListModel.h"
#import "RYGPackageBoughtModel.h"

#import "RYGPackageCreatedListModel.h"
#import "RYGPackageCreatedModel.h"

#import "RYGOrderListModel.h"
#import "RYGOrderPayModel.h"

#import "RYGWinLoseListModel.h"
#import "RYGWinLosePersonModel.h"

@implementation RYGPersonalConfig

/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
    
    // StatusResult类中的statuses数组中存放的是Status模型
    // StatusResult类中的ads数组中存放的是Ad模型
//    [RYGPersonalCenterModel setupObjectClassInArray:^NSDictionary *{
//        return @{
//                 @"datas" : @"RYGPersonalDatasModel",
//                 @"user" : @"RYGPersonalUserModel"
//                 };
//    }];
    
    [RYGAttentionListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGAttentionPersonModel"
                 };
    }];
    
    [RYGFansListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGFansPersonModel"
                 };
    }];
    
    [RYGBlackListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGBlackPersonModel"
                 };
    }];
    
    [RYGPackageBoughtListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGPackageBoughtModel"
                 };
    }];
    
    [RYGPackageCreatedListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGPackageCreatedModel"
                 };
    }];
    
    [RYGOrderListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGOrderPayModel"
                 };
    }];
    
    [RYGWinLoseListModel setupObjectClassInArray:^NSDictionary *{
        return  @{
                  @"datas" : @"RYGWinLosePersonModel"
                  };
    }];
    
    // 相当于在StatusResult.m中实现了+objectClassInArray方法
}

@end
