//
//  RYGPersonalDatasModel.h
//  shoumila
//
//  Created by yinyujie on 15/8/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGPersonalDatasModel : NSObject

// 利润率
@property(nonatomic,copy) NSString *profit_margin;
// 胜率
@property(nonatomic,copy) NSString *win_rate;
// 平均水位
@property(nonatomic,assign) float water_level;
// 推荐场次
@property(nonatomic,copy) NSString *recommend_count;
// 胜利场次
@property(nonatomic,copy) NSString *win_count;
//
@property(nonatomic,copy) NSString *win_rate_yp;
//
@property(nonatomic,copy) NSString *win_rate_dx;
//
@property(nonatomic,copy) NSString *win_rate_jc;
//
@property(nonatomic,copy) NSString *margin_sum;
//
@property(nonatomic,copy) NSString *stability;
// 近10场情况(1平2胜3负)
@property(nonatomic,copy) NSArray *recent_ten;
//
@property(nonatomic,copy) NSArray *recent;
//
@property(nonatomic,copy) NSString *max_continuous_win;

@property(nonatomic,copy) NSString *profit_max;

@property(nonatomic,copy) NSString *profit_min;


@end
