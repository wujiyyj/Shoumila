//
//  RYGAttendedMessageModel.h
//  关注我的消息
//
//  Created by jiaocx on 15/9/11.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RYGMessageBaseModel.h"

@interface RYGAttendedMessageModel : RYGMessageBaseModel<NSCoding>

// 关注的用户id
@property(nonatomic,copy)NSString *userId;
// 用户头像
@property(nonatomic,copy)NSString *user_logo;
// 用户名
@property(nonatomic,copy)NSString *user_name;


@end
