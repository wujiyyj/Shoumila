//
//  RYGAttendedPersonDynamicMessageModel.h
//  被关注的人的动态消息数据
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGDynamicConetentModel : NSObject

@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *color;

@end

@interface RYGDynamicPublishUserModel : NSObject

// 用户名
@property(nonatomic,copy)NSString *userid;
// 用户姓名
@property(nonatomic,copy) NSString *name;
// 用户logo
@property(nonatomic,copy)NSString *avatar;
// 等级
@property(nonatomic,copy)NSString *grade;
// 连红
@property(nonatomic,copy)NSString *max_continuous_win;

@end

@interface RYGDynamicDataModel : NSObject

// cat 帖子类型(int 1:普通帖子 2:连红推荐 3:周榜单冠军推荐 4:月榜单冠军推荐 5:邀请推荐)
@property(nonatomic,copy)NSString *cat;
// 原帖id
@property(nonatomic,copy)NSString *feed_id;
// type (int 0:普通帖子 1:赛前 2:滚球)
@property(nonatomic,copy)NSString *type;
// 收米套餐
@property(nonatomic,copy)NSString *package_name;
// 内容
@property(nonatomic,strong)NSMutableArray *text_content;
// 内容
@property(nonatomic,copy)NSString *content;
// 用户名
@property(nonatomic,copy)NSString *userid;
// 用户姓名
@property(nonatomic,copy) NSString *user_name;
// 用户logo
@property(nonatomic,copy)NSString *user_logo;
// 等级
@property(nonatomic,copy)NSString *grade;
// 图片
@property(nonatomic,strong)NSArray *pics;
// 用户分数
@property(nonatomic,copy) NSString *score;
// 分享数
@property(nonatomic,copy) NSString *share_num;
// 点赞数
@property(nonatomic,copy) NSString *praise_num;
// 回复数
@property(nonatomic,copy) NSString *comment_num;
//  (int 本人是否已赞 1已赞 0未赞)
@property(nonatomic,copy) NSString *self_is_praised;
//  (int 本人是否已评论 1已评 2未评)
@property(nonatomic,copy) NSString *self_is_commented;
//  (int 自己是否分享 1已分享 2未分享)
@property(nonatomic,copy) NSString *self_is_shared;
//
@property(nonatomic,strong)RYGDynamicPublishUserModel *publish_user;
// (string 发布时间)
@property(nonatomic,copy)NSString *publish_time;
// (int 印章类型)
@property(nonatomic,copy)NSString *stamp;
// (string 分享url)
@property(nonatomic,copy)NSString *share_url;

@end

@interface RYGAttendedPersonDynamicMessageModel : NSObject
// 原帖id
@property(nonatomic,copy)NSString *feed_id;
//  消息ID
@property(nonatomic,copy)NSString *message_id;
// 类型 普通动态 赛事动态 type = 13;套餐 type = 14
@property(nonatomic,copy)NSString *type;
// 时间
@property(nonatomic,copy)NSString *in_time;
// 数据
@property(nonatomic,strong)RYGDynamicDataModel *data;

@end
