//
//  RYGMessageManager.h
//  管理消息中心
//
//  Created by jiaocx on 15/9/14.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGDataCache.h"
#import "RYGMessageCount.h"

typedef void(^MessageTotalCompleteBlock) (RYGMessageCount *messageCount);

@interface RYGMessageManager : NSObject

+ (instancetype)shareMessageManager;
- (void)messageSendAsynchronousRequest;
- (void)unreadMessageCont:(MessageTotalCompleteBlock)messageTotalCompleteBlock;

@end

// 常量
extern NSString * const kRYGMessageModelFileName;             // 首页主模块部分文件名

extern NSString * const kRYGMessageRefreshNotification;

extern NSString * const  kRYGMessagePageLast;
