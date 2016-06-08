//
//  RYGRankingListParam.h
//  shoumila
//
//  Created by 贾磊 on 15/7/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGRankingListParam : RYGBaseParam

//每页条数(可选)
@property(nonatomic,copy) NSString *count;

//向下翻页标识(可选,为空或为0时默认为第一页,返回my_ranking,其余页my_ranking不返回)
@property(nonatomic,copy) NSString *next;
@end
