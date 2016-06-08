//
//  RYGWinLosePersonModel.h
//  shoumila
//
//  Created by 阴～ on 16/4/10.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGWinLosePersonModel : NSObject

// 用户id
@property(nonatomic,copy) NSString *publish_id;
// 联赛
@property(nonatomic,copy) NSString *leagues;
// 主队
@property(nonatomic,copy) NSString *ht;
// 客队
@property(nonatomic,copy) NSString *vt;
// 发布时间
@property(nonatomic,copy) NSString *publish_time;
// 玩法
@property(nonatomic,copy) NSString *rules;
// content
@property(nonatomic,copy) NSString *content;
// 
@property(nonatomic,copy) NSString *type;
// 结果(int) 1全输 2输半 3走水 4赢半 5赢 0无结果
@property(nonatomic,copy) NSString *result;
//
@property(nonatomic,copy) NSString *margin;


@end
