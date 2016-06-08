//
//  RYGUserDetailModel.h
//  shoumila
//
//  Created by yinyujie on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGUserInfoModel : NSObject<NSCoding>

@property(nonatomic,copy) NSString *userid;
@property(nonatomic,copy) NSString *avatar; //用户头像
@property(nonatomic,copy) NSString *user_name;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *is_admin; //用户权限 1-管理员

@end
