//
//  RYGUtility.m
//  shoumila
//
//  Created by 贾磊 on 15/9/13.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGUtility.h"
#import "RYGLoginViewController.h"

@implementation RYGUtility

//获取当前窗口导航控制器
+ (UINavigationController *)getCurrentVC
{
    UITabBarController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    UITabBarController *tabVc = result.childViewControllers[1];
    NSInteger index = tabVc.selectedIndex;
    
    return tabVc.viewControllers[index];
}

+(RYGUserInfoModel *)getUserInfo{
    NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
    RYGUserInfoModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return user;
}

+(BOOL)validateUserLogin{
    if ((nil != [RYGUtility getUserInfo].token) && ![[RYGUtility getUserInfo].token isEqualToString:@""]) {
        return YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNSNotification object:nil];
    return NO;
}

+(BOOL)isLogin {
    if ((nil != [RYGUtility getUserInfo].token) && ![[RYGUtility getUserInfo].token isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end
