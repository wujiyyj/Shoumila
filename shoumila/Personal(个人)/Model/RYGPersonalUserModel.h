//
//  RYGPersonalUserModel.h
//  shoumila
//
//  Created by yinyujie on 15/8/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGPersonalUserModel : NSObject<NSCoding>

@property(nonatomic,copy) NSString *userid;
@property(nonatomic,copy) NSString *user_logo; //用户头像
@property(nonatomic,copy) NSString *user_name;
@property(nonatomic,copy) NSString *can_edit;   //是否可以订阅
@property(nonatomic,copy) NSString *score;      //活跃积分
//@property(nonatomic,copy) NSString *praise_num;
@property(nonatomic,copy) NSString *user_praise_num;
@property(nonatomic,copy) NSString *funs_num;
@property(nonatomic,copy) NSString *favorite_num;
@property(nonatomic,copy) NSString *attention_num;
@property(nonatomic,copy) NSString *grade;
@property(nonatomic,copy) NSString *money;
@property(nonatomic,copy) NSString *is_praise;
@property(nonatomic,copy) NSString *is_attention;

@property(nonatomic,copy) NSString *publish_num;    //发帖数
@property(nonatomic,copy) NSString *share_num;      //分享数
@property(nonatomic,copy) NSString *comment_num;    //评论数
@property(nonatomic,copy) NSString *praise_num;     //点赞数
@property(nonatomic,copy) NSString *invite_num;     //邀请数
@property(nonatomic,copy) NSString *active_num;     //活跃天数
@property(nonatomic,copy) NSString *visit_num;      //被访问数
@property(nonatomic,copy) NSString *match_num;      //推荐比赛数
@property(nonatomic,copy) NSString *max_continuous_tag;     //最大连红标签
@property(nonatomic,copy) NSString *win_tag;        //几中几标签

@property(nonatomic,copy) NSString *rank_week;
@property(nonatomic,copy) NSString *rank_month;
@property(nonatomic,copy) NSString *rank_active;
@property(nonatomic,copy) NSString *rank_vip;

@end
