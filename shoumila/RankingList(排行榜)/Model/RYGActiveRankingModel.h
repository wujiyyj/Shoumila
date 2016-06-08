//
//  RYGActiveRankingModel.h
//  活跃榜信息
//
//  Created by jiaocx on 15/8/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGMyRankingModel.h"

@interface RYGActiveRankingModel : NSObject

@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,strong)RYGMyRankingModel *my_ranking;

@property(nonatomic,copy)NSString *page_is_last;

@property(nonatomic,copy)NSString *next;

@end
