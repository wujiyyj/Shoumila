//
//  RYGMessageReplyModel.h
//  回复我的消息
//
//  Created by jiaocx on 15/8/20.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGOriginalnvitationModel.h"

@class RYGOriginalnvitationModel;

@interface RYGMessageReplyModel : NSObject
// 回复者id
@property(nonatomic,copy)NSString *userid;
// 回复者头像
@property(nonatomic,copy)NSString *user_logo;
// 回复者用户名
@property(nonatomic,copy) NSString *user_name;
// 回复者等级
@property(nonatomic,copy)NSString *grade;
// 回复时间
@property(nonatomic,copy)NSString *ctime;
// 回复内容
@property(nonatomic,copy)NSString *content;
// 原帖信息
@property(nonatomic,strong)RYGOriginalnvitationModel *original;

@end
