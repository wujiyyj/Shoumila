//
//  RYGMessageReferToMeInfosModel.h
//  提到我的消息的所有数据
//
//  Created by jiaocx on 15/8/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGMessageReferToMeInfosModel : NSObject

@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,copy)NSString *page_is_last;

@property(nonatomic,copy)NSString *next;

@end
