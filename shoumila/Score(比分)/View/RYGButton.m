//
//  RYGButton.m
//  shoumila
//
//  Created by 贾磊 on 15/8/26.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGButton.h"

@implementation RYGButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, 36, 33);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(36, 13, 14, 8);
}
@end
