//
//  RYGDateUtility.m
//  shoumila
//
//  Created by jiaocx on 15/8/17.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDateUtility.h"

@implementation RYGDateUtility


+ (NSString *)humanableInfoFromDate: (NSDate *) theDate {
    NSString *info;
    
    NSTimeInterval delta = - [theDate timeIntervalSinceNow];
    if (delta < 60) {
        // 1分钟之内
        info = @"刚刚";
    } else {
        delta = delta / 60;
        if (delta < 60) {
            // n分钟前
            info = [NSString stringWithFormat:@"%lu分钟之前",(NSUInteger)delta];
        } else {
            delta = delta / 60;
            if (delta < 24) {
                // n小时前
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH时mm分"];
                info = [dateFormatter stringFromDate:theDate];
            } else {
                delta = delta / 24;
                if ((NSInteger)delta == 1) {
                    //昨天
                    info = [NSString stringWithFormat:@"昨天"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH时mm分"];
                    info = [dateFormatter stringFromDate:theDate];
                }  else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM月dd号 HH时mm分"];
                    info = [dateFormatter stringFromDate:theDate];
                }
            }
        }
    }
    return info;
}

+ (NSString *)hourMinInfoFromDate:(NSDate *)theDate {
    NSString *info;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    info = [dateFormatter stringFromDate:theDate];
    
    return info;
}


@end
