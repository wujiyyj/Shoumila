//
//  RYGMessageInfoModel.h
//  消息信息的所有数据
//
//  Created by jiaocx on 15/8/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGMessageBaseModel.h"

@interface RYGMessageInfosModel : NSObject

@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,copy)NSString *page_is_last;

@property(nonatomic,copy)NSString *next;

// 消息中心
@property(nonatomic,strong)RYGMessageBaseModel *msg_center;
// 赞我的
@property(nonatomic,strong)RYGMessageBaseModel *praise_me;
// 回复我的
@property(nonatomic,strong)RYGMessageBaseModel *comment_me;
// 提到我的
@property(nonatomic,strong)RYGMessageBaseModel *at_me;

@end
