//
//  RYGPersonalUserModel.m
//  shoumila
//
//  Created by yinyujie on 15/8/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPersonalUserModel.h"

@implementation RYGPersonalUserModel

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self encode:aCoder];
}

@end
