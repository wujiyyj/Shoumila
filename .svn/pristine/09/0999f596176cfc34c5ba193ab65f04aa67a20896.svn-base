//
//  RYGBaseParam.m
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"
#import "APService.h"

@implementation RYGBaseParam
- (id)init
{
    if (self = [super init]) {
        self.device = @"ios";

        self.client_id = [APService registrationID];
        self.token = [RYGUtility getUserInfo].token;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    }
    return self;
}

+ (instancetype)param
{
    return [[self alloc] init];
}

@end
