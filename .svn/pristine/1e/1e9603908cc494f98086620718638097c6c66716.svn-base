//
//  RYGScoreConfig.m
//  shoumila
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGScoreConfig.h"
#import "RYGScoreGQModel.h"
#import "RYGScoreGQList.h"
#import "RYGScoreTodayModel.h"
#import "RYGScoreTodayList.h"

@implementation RYGScoreConfig
+ (void)load
{
    [RYGScoreGQList setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGScoreGQModel"
                 };
    }];
    [RYGScoreGQModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"match" : @"RYGScoreGQEntity"
                 };
    }];
    
    [RYGScoreTodayList setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGScoreTodayModel"
                 };
    }];
    
    [RYGScoreTodayModel setupObjectClassInArray:^NSDictionary *{
        return @{
                @"match":@"RYGScoreTodayEntity"
                };
    }];
    
}

@end
