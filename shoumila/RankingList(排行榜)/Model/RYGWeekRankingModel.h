//
//  RYGWeekRankingModel.h
//  周榜单
//
//  Created by jiaocx on 15/7/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGMyRankingModel.h"
#import "RYGWeekPersonModel.h"

@interface RYGWeekRankingModel : NSObject

@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,strong)RYGMyRankingModel *my_ranking;

@property(nonatomic,copy)NSString *page_is_last;

@property(nonatomic,copy)NSString *next;

@end
