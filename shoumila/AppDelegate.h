//
//  AppDelegate.h
//  shoumila
//
//  Created by 贾磊 on 15/7/21.
//  Copyright (c) 2015年 贾磊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RYGViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)RYGViewController *viewController;
@property(nonatomic,strong)NSString *device_token;

- (void)updateMessageItem;


@end

