//
//  RYGMessageModelConfig.m
//  shoumila
//
//  Created by jiaocx on 15/8/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageModelConfig.h"
#import "RYGMessageInfosModel.h"
#import "RYGMessageModel.h"
#import "RYGMessageReplyInfosModel.h"
#import "RYGMessageReplyModel.h"
#import "RYGMessageReferToMeInfosModel.h"
#import "RYGMessageReferToMeModel.h"
#import "RYGMessagePraiseInfosModel.h"
#import "RYGMessagePraiseModel.h"
#import "RYGMessageCenterInfosModel.h"
#import "RYGMessageCenterModel.h"
#import "RYGAttendedPersonDynamicMessageInfosModel.h"
#import "RYGAttendedPersonDynamicMessageModel.h"
#import "RYGPraiseUserModel.h"

@implementation RYGMessageModelConfig

/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
    
    // 消息列表
    [RYGMessageInfosModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGMessageBaseModel"
                 };
    }];
    
    // 回复我的消息列表
    [RYGMessageReplyInfosModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGMessageReplyModel"
                 };
    }];

    // 提到我的
    [RYGMessageReferToMeInfosModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGMessageReferToMeModel"
                 };
    }];
    [RYGMessagePraiseModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"praise_users" : @"RYGPraiseUserModel"
                 };
    }];
    
    // 赞过我的
    [RYGMessagePraiseInfosModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGMessagePraiseModel"
                 };
    }];
    
    // 消息心中心
    [RYGMessageCenterInfosModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGMessageCenterModel"
                 };
    }];
    
    [RYGDataModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"content" : @"RYGConetentModel"
                 };
    }];
    
    // 被关注的人的动态消息
    [RYGAttendedPersonDynamicMessageInfosModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGAttendedPersonDynamicMessageModel"
                 };
    }];
    
    [RYGDynamicDataModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"text_content" : @"RYGDynamicConetentModel"
                 };
    }];
    
}

@end
