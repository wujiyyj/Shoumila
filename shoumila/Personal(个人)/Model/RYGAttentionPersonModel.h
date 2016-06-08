//
//  RYGAttentionPersonModel.h
//  shoumila
//
//  Created by 阴～ on 15/9/13.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGAttentionPersonModel : NSObject

// 用户id
@property(nonatomic,copy) NSString *userid;
// 用户logo
@property(nonatomic,copy) NSString *user_logo;
// 用户姓名
@property(nonatomic,copy) NSString *user_name;
// 动态数
@property(nonatomic,copy) NSString *publish_num;
// 粉丝数
@property(nonatomic,copy) NSString *funs_num;
// 推荐的未开始比赛数(int 红点)
@property(nonatomic,copy) NSString *not_beginning_num;

@end
