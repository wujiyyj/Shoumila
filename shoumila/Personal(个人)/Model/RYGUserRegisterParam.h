//
//  RYGUserRegisterParam.h
//  shoumila
//
//  Created by yinyujie on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGUserRegisterParam : RYGBaseParam

@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *vercode;
//@property(nonatomic,copy) NSString *device;
//@property(nonatomic,copy) NSString *client_id;
@property(nonatomic,copy) NSString *rkey;

@end
