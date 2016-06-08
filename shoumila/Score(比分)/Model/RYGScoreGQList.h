//
//  RYGScoreGQList.h
//  shoumila
//
//  Created by 贾磊 on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGScoreGQModel.h"

@interface RYGScoreGQList : NSObject
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)NSArray *leagues;
@property(nonatomic,copy)NSString *page_is_last;
@property(nonatomic,copy)NSString *next;

@end
