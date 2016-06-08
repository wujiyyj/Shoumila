//
//  RYGMessageCenterModel.h
//  消息中心的数据
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGConetentModel : NSObject

@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *color;

@end

@interface RYGDataModel : NSObject

@property(nonatomic,strong)NSMutableArray *content;
// 提现申请金额
@property(nonatomic,copy)NSString *amount;
// 提现申请日期
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *userid;
// 套餐名称
@property(nonatomic,copy)NSString *package_name;
// 人数
@property(nonatomic,copy)NSString *peple_num;
// 名次上升
@property(nonatomic,copy)NSString *ranking_up;
// 等级上升
@property(nonatomic,copy)NSString *grade_up;
// 奖励金额
@property(nonatomic,copy)NSString *invite_reward;
//
@property(nonatomic,copy)NSString *feed_id;
//
@property(nonatomic,copy)NSString *cat;
// 最大连红
@property(nonatomic,copy)NSString *max_continuous_win;


@end

@interface RYGMessageCenterModel : NSObject
// 消息ID
@property(nonatomic,copy)NSString *message_id;
// 类型
@property(nonatomic,copy)NSString *type;
// 时间
@property(nonatomic,copy)NSString *in_time;
// 消息
@property(nonatomic,strong)RYGDataModel *data;

@end
