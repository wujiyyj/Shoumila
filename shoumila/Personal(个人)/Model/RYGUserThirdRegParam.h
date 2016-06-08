//
//  RYGUserThirdRegParam.h
//  shoumila
//
//  Created by yinyujie on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGUserThirdRegParam : RYGBaseParam

@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *vercode;
@property(nonatomic,copy) NSString *user_name;
@property(nonatomic,copy) NSString *third_uid;  //第三方(weibo)用户id(必选)
@property(nonatomic,copy) NSString *third_token;    //第三方(weibo)token (必选)
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *figureurl;
//@property(nonatomic,copy) NSString *device; //手机平台(必选 ios or android)
//@property(nonatomic,copy) NSString *client_id;  //设备唯一标识(必选,推送用)

@end
