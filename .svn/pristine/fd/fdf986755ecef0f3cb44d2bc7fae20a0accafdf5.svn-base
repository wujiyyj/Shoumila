//
//  RYGBaseViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYGTabBar;

@protocol RYGTabBarDelegate <NSObject>

@optional
- (void)tabBar:(RYGTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

@end

@interface RYGTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<RYGTabBarDelegate> delegate;

-(void)selectedMenu:(NSUInteger)selectedIndex;

@end
