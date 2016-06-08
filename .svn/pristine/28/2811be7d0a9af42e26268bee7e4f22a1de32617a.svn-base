//
//  RYGIntegralRankParser.m
//  // 根据等级取得等级图标
//
//  Created by jiaocx on 15/7/31.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGIntegralRankParser.h"
//星星图标
#define rank_star "rank_star"
// 奖牌图标
#define rank_medal "rank_medal"
// 奖杯图片
#define rank_cup  "rank_cup"

@implementation RYGIntegralRankParser

+ (NSArray *)image:(NSString *)rankCode {
    NSMutableArray *ranks = [[NSMutableArray alloc]init];
    NSInteger rank = [rankCode integerValue];
    NSInteger  cup = rank / 16;
    rank =  rank % 16;
    NSInteger medal  = rank / 4;
    rank = rank % 4;
    NSInteger start = rank;
    for (int i = 0; i < cup; i++) {
        [ranks addObject:@rank_cup];
    }
    for (int j = 0; j < medal ; j++) {
        [ranks addObject:@rank_medal];
    }
    for (int k = 0; k < start ; k++) {
        [ranks addObject:@rank_star];
    }
    return ranks;
}

@end
