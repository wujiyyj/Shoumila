//
//  MJViewController.m
//  侧滑菜单
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "RYGViewController.h"
#import "RYGMenuViewController.h"
#import "RYGHomeViewController.h"
#import "RYGTabBarViewController.h"
#import "AppDelegate.h"

@interface RYGViewController ()

@end

@implementation RYGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RYGMenuViewController *menuVc = [[RYGMenuViewController alloc] init];
    menuVc.view.width = RYGMenuWidth;
    menuVc.view.top = 0;
    [self.view addSubview:menuVc.view];
    [self addChildViewController:menuVc];
    
    _centerVc = [[RYGTabBarViewController alloc] init];
    _centerVc.view.frame = self.view.bounds;
    [self.view addSubview:_centerVc.view];
    [self addChildViewController:_centerVc];
    AppDelegate* myDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [myDelegate updateMessageItem];
    
}

@end
