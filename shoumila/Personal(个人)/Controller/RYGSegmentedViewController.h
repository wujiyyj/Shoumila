//
//  RYGSegmentedViewController.h
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"

@interface RYGSegmentedViewController : RYGBaseViewController

@property(nonatomic, strong) UIViewController *selectedViewController;
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

- (void)setViewControllers:(NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title;

@end
