//
//  RYGMessageBaseModel.h
//  shoumila
//
//  Created by jiaocx on 15/9/11.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGMessageBaseModel : NSObject<NSCoding>

// 未读消息数
@property(nonatomic,copy)NSString *num;
// 消息内容
@property(nonatomic,copy)NSString *text;
// 最近一条消息时间
@property(nonatomic,copy)NSString *ctime;

@property(nonatomic,copy)NSString *mtype;

// 关注的用户id
@property(nonatomic,copy)NSString *userid;
// 用户头像
@property(nonatomic,copy)NSString *user_logo;
// 用户名
@property(nonatomic,copy)NSString *user_name;

@end
