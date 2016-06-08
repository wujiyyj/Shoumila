//
//  RYGBaseViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGTabBarViewController.h"
#import "RYGTabBar.h"
#import "RYGNavigationController.h"
#import "RYGHomeViewController.h"
#import "RYGScoreViewController.h"
#import "RYGRankingListViewController.h"
#import "RYGMessageViewController.h"
#import "RYGUserCenterViewController.h"

@interface RYGTabBarViewController () <RYGTabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) RYGTabBar *customTabBar;
@end

@implementation RYGTabBarViewController{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    RYGTabBar *customTabBar = [[RYGTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    [self.customTabBar selectedMenu:self.selectedIndex];
    
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(RYGTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
    if(!(to || from)){
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeNotification object:nil];
    }
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{

    _tabBarItems = [[NSMutableArray alloc]init];
    RYGHomeViewController *home = [[RYGHomeViewController alloc] init];
    
    [self setupChildViewController:home title:@"动态" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];

    RYGScoreViewController *score = [[RYGScoreViewController alloc] init];
    [self setupChildViewController:score title:@"比分" imageName:@"tabbar_score" selectedImageName:@"tabbar_score_selected"];

    RYGRankingListViewController *rankingList = [[RYGRankingListViewController alloc] init];
    [self setupChildViewController:rankingList title:@"排行榜" imageName:@"tabbar_rankingList_center" selectedImageName:@"tabbar_rankingList_selected"];
    
    RYGMessageViewController *message = [[RYGMessageViewController alloc] init];
    [self setupChildViewController:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    
    RYGUserCenterViewController *userCenter = [[RYGUserCenterViewController alloc] init];
    [self setupChildViewController:userCenter title:@"我的" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RYGNavigationController *nav = [[RYGNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    [_tabBarItems addObject:childVc.tabBarItem];
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

@end