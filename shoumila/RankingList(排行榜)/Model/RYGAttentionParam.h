//
//  RYGAttentionParam.h
//  用户关注／取消关注
//
//  Created by jiaocx on 15/8/13.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGAttentionParam : RYGBaseParam

// 被关注用户id
@property(nonatomic,copy)NSString *userid;
// 操作
@property(nonatomic,copy)NSString *op;

@end
