//
//  RYGUserChangePasswdParam.h
//  shoumila
//
//  Created by Xmj on 15/11/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGUserChangePasswdParam : RYGBaseParam

@property(nonatomic,copy) NSString *pwd_old;
@property(nonatomic,copy) NSString *pwd_new;
@property(nonatomic,copy) NSString *rkey;

@end
