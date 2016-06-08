//
//  RYGAttentionListParam.h
//  shoumila
//
//  Created by 阴～ on 15/9/13.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGAllListParam : RYGBaseParam

@property(nonatomic,copy) NSString *userid;
@property(nonatomic,copy) NSString *count;  //每页条数(可选)
@property(nonatomic,copy) NSString *next;   //向下翻页标识(可选,为空或为0时默认为第一页,返回funs_num,其余页funs_num不返回)
@property(nonatomic,copy) NSString *keyword;

@end
