//
//  RYGDynamicConfig.m
//  shoumila
//
//  Created by 贾磊 on 15/9/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicConfig.h"
#import "RYGDynamicList.h"
#import "RYGDynamicModel.h"
#import "RYGCommentModel.h"

@implementation RYGDynamicConfig
+(void)load{
    [RYGDynamicList setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"datas" : @"RYGDynamicModel"
                 };
    }];
    
    [RYGDynamicModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"comment_list" : @"RYGCommentModel"
                 };
    }];
    [RYGCommentModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"thread":@"RYGThreadModel"
                 };
    }];
}
@end
