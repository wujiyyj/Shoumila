//
//  RYGUtility.h
//  shoumila
//
//  Created by 贾磊 on 15/9/13.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGUtility : NSObject
+ (UINavigationController *)getCurrentVC;
+(RYGUserInfoModel *)getUserInfo;
+(BOOL)validateUserLogin;
+(BOOL)isLogin;
@end