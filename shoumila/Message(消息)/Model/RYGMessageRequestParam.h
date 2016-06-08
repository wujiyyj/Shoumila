//
//  RYGMessageRequestParam.h
//  消息的请求参数
//
//  Created by jiaocx on 15/8/25.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGMessageRequestParam : RYGBaseParam

// 每页条数(可选)
@property(nonatomic,copy) NSString *count;

// 向下翻页标识
@property(nonatomic,copy) NSString *next;

// 关注的人的消息 关注的人
@property(nonatomic,copy) NSString *from_id;
//
@property(nonatomic,copy) NSString *userid;

@end
