//
//  RYGSmsSendParam.h
//  shoumila
//
//  Created by yinyujie on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGSmsSendParam : RYGBaseParam

@property(nonatomic,copy) NSString *mobile; //手机号码
@property(nonatomic,copy) NSString *type;   //短信用途 1：注册验证  2：取回密码验证 3: 第三方账号绑定

@end
