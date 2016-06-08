//
//  RYGMessageReferToMeModel.h
//  提到我的消息的数据
//
//  Created by jiaocx on 15/8/21.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGOriginalnvitationModel.h"

@interface RYGMessageReferToMeModel : NSObject

// 回复者id
@property(nonatomic,copy)NSString *userid;
// 回复者头像
@property(nonatomic,copy)NSString *user_logo;
// 回复者用户名
@property(nonatomic,copy) NSString *user_name;
// 等级
@property(nonatomic,copy)NSString *grade;
// 时间
@property(nonatomic,copy)NSString *ctime;
// 回复Title
@property(nonatomic,copy)NSString *content;

// 原帖信息
@property(nonatomic,strong)RYGOriginalnvitationModel *original;

@end
