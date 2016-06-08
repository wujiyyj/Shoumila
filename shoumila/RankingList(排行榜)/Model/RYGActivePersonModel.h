//
//  RYGActivePersonModel.h
//  活跃榜个人信息
//
//  Created by jiaocx on 15/8/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGActivePersonModel : NSObject

// 排名
@property(nonatomic,copy) NSString *ranking;
// 用户id
@property(nonatomic,copy) NSString *userid;
// 用户logo
@property(nonatomic,copy) NSString *user_logo;
// 用户姓名
@property(nonatomic,copy) NSString *user_name;
// 等级
@property(nonatomic,copy)NSString *grade;
// 用户分数
@property(nonatomic,copy) NSString *score;
// 发帖数
@property(nonatomic,copy) NSString *publish_num;
// 回复数
@property(nonatomic,copy) NSString *comment_num;
// 转发数
@property(nonatomic,copy) NSString *share_num;
// 点赞数
@property(nonatomic,copy) NSString *praise_num;
// 回复天数
@property(nonatomic,copy) NSString *active_num;
// 邀请数
@property(nonatomic,copy) NSString *invite_num;

@end
