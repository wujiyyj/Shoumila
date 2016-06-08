//
//  RYGMessageManager.m
//  管理消息中心
//
//  Created by jiaocx on 15/9/14.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageManager.h"
#import "RYGMessageRequestParam.h"
#import "RYGHttpRequest.h"
#import "RYGMessageInfosModel.h"


@implementation RYGMessageManager

+ (instancetype)shareMessageManager
{
    static RYGMessageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RYGMessageManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void)unreadMessageCont:(MessageTotalCompleteBlock )messageTotalCompleteBlock {
    RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
    [RYGHttpRequest postWithURL:Message_Total_Num params:messageRequestParam.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        RYGMessageCount *messageCount = [RYGMessageCount objectWithKeyValues:dic];
        if (messageTotalCompleteBlock) {
            messageTotalCompleteBlock(messageCount);
        }
    } failure:^(NSError *error) {
        
    }];

}


// 消息请求
- (void)messageSendAsynchronousRequest{
    RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
    messageRequestParam.next = 0;
   __block NSMutableArray *messageList = [[NSMutableArray alloc]init];
    __weak __typeof(&*self)weakSelf = self;
    [RYGHttpRequest postWithURL:Message_List params:messageRequestParam.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        RYGMessageInfosModel *messageInfosModel = [RYGMessageInfosModel objectWithKeyValues:dic];
        // 为空或为0时默认为第一页
        if (messageInfosModel) {
            if (messageInfosModel.comment_me) {
                messageInfosModel.comment_me.mtype = @"1";
                [messageList addObject:messageInfosModel.comment_me];
            }
            
            if (messageInfosModel.at_me) {
                messageInfosModel.at_me.mtype = @"2";
                [messageList addObject:messageInfosModel.at_me];
            }

            if (messageInfosModel.praise_me) {
                messageInfosModel.praise_me.mtype = @"3";
                [messageList addObject:messageInfosModel.praise_me];
            }
            if (messageInfosModel.msg_center) {
                messageInfosModel.msg_center.mtype = @"4";
                [messageList addObject:messageInfosModel.msg_center];
            }
            
            RYGMessageBaseModel *replyModel = [[RYGMessageBaseModel alloc]init];
            replyModel.text = @"有问题还不问我？你造吗！";
            replyModel.ctime = @"";
            replyModel.num = @"";
            replyModel.mtype = @"5";
            [messageList addObject:replyModel];
        }
        
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:messageInfosModel.page_is_last forKey:kRYGMessagePageLast];
        [userDefault synchronize];

        [messageList addObjectsFromArray:messageInfosModel.datas];
        [weakSelf saveMessagePageModuleList:messageList];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRYGMessageRefreshNotification object:self];
    } failure:^(NSError *error) {
        
    }];
}

- (void)saveMessagePageModuleList:(NSArray *)messageList
{
    if (messageList && messageList.count > 0) {
       [[RYGDataCache sharedInstance] writeData:messageList toFile:kRYGMessageModelFileName];
    }
}

NSString * const kRYGMessageModelFileName = @"RYGMessageModelFileName";
NSString * const kRYGMessageRefreshNotification = @"RYGMessageRefreshNotification";
NSString * const  kRYGMessagePageLast = @"kRYGMessagePageLast";

@end
