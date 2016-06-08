//
//  RYGUserRefundParam.h
//  shoumila
//
//  Created by Xmj on 15/10/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGUserRefundParam : RYGBaseParam

@property(nonatomic,copy) NSString *money;  //金额
@property(nonatomic,copy) NSString *name;   //姓名
@property(nonatomic,copy) NSString *mobile;   //手机号
@property(nonatomic,copy) NSString *id_number;        //身份证号
@property(nonatomic,copy) NSString *bank;     //银行
@property(nonatomic,copy) NSString *account;    //帐号

@end
