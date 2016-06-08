//
//  RYGOriginalnvitationModel.h
//  回复我的原帖的信息
//
//  Created by jiaocx on 15/8/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGOriginalnvitationModel : NSObject
// 原帖id
@property(nonatomic,copy)NSString *feed_id;
// 发布者用户名
@property(nonatomic,copy)NSString *publish_user_name;
// 发布者用id
@property(nonatomic,copy)NSString *publish_userid;
// 原帖图片
@property(nonatomic,copy)NSString *pic;
// 原帖内容
@property(nonatomic,copy)NSString *content;
// 类型(int 1:跳帖子详情页 2:跳评论页)
@property(nonatomic,copy)NSString *type;
// 帖子类型
@property(nonatomic,copy)NSString *cat;

@property(nonatomic,copy)NSString *comment_id;

@end
