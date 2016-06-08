//
//  RYGUserLoginParam.h
//  shoumila
//
//  Created by yinyujie on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGUserLoginParam : RYGBaseParam

@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *third_uid;
@property(nonatomic,copy) NSString *third_token;
@property(nonatomic,copy) NSString *code;
//@property(nonatomic,copy) NSString *device; //手机平台(必选 ios or android)
//@property(nonatomic,copy) NSString *client_id;  //设备唯一标识(必选,推送用)
@property(nonatomic,copy) NSString *rkey;

@end
