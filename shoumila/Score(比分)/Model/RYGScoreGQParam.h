//
//  RYGScoreGQParam.h
//  shoumila
//
//  Created by 贾磊 on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGBaseParam.h"

@interface RYGScoreGQParam :RYGBaseParam
//每页条数(可选)
@property(nonatomic,copy) NSString *count;

@property(nonatomic,copy) NSString *next;
@property(nonatomic,copy) NSString *leagues;
@property(nonatomic,copy) NSString *key;
@end
