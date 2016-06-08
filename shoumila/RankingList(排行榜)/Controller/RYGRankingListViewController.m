//
//  RYGRankingListViewController.m
//  排行榜
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRankingListViewController.h"
#import "RYGWeekRankingViewController.h"
#import "RYGMonthRankingViewController.h"
#import "RYGVipRankingViewController.h"
#import "RYGActiveRankingViewController.h"
#import "RYGSlideMenuView.h"
#import "RYGScrollPageView.h"
#import "RYGUserCenterViewController.h"
#import "RYGLoginViewController.h"
#import "RYGPersonPackageViewController.h"
#import "RYGUtility.h"

@interface RYGRankingListViewController ()

@property (nonatomic, strong)RYGSlideMenuView *slideMenuVieiw;
@property (nonatomic, strong)RYGScrollPageView *scrollView;
@property (nonatomic, strong)NSArray *subViewControllers;
@property (nonatomic, assign)BOOL isBack;

@end

@implementation RYGRankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *menuTitles = [NSArray arrayWithObjects:@"周榜单", @"月度榜", @"VIP榜",@"活跃榜",nil];
    _slideMenuVieiw = [[RYGSlideMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64) menuTitles:menuTitles];
    _slideMenuVieiw.textAttributes = @{MenuFont:[UIFont systemFontOfSize:14], MenuColor:ColorRankUnSelectedTitle};
    _slideMenuVieiw.selectedTextAttributes = @{MenuFont:[UIFont systemFontOfSize:15], MenuColor:ColorViewBackground};
    _slideMenuVieiw.transitionTextAttributes = @{MenuFont:[UIFont systemFontOfSize:16], MenuColor:ColorViewBackground};
    _slideMenuVieiw.currentSelectedIndex = 0;
    __weak __typeof(&*self)weakSelf = self;
    _slideMenuVieiw.selectBlock = ^(NSInteger index) {
        weakSelf.scrollView.currentPage = index;
        [weakSelf menuSelectChange:index];
    };
    [self.view addSubview:_slideMenuVieiw];
    
    _scrollView = [[RYGScrollPageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height) withPageNums:menuTitles.count];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollBlock = ^(NSInteger index) {
        weakSelf.slideMenuVieiw.currentSelectedIndex = index;
    };
    [self.view addSubview:_scrollView];
    [self initSubViewControllers];
    self.isBack = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self removeSystemTabBarItem];
    if (self.isBack) {
        self.isBack = NO;
        [self backRefresh];
    }
    
    [MobClick beginLogPageView:@"排行榜"];
}

- (void)backRefresh {
    for (int i = 0; i < [self.subViewControllers count]; i++) {
        // 周榜单
        if ([[self.subViewControllers objectAtIndex:i] isKindOfClass:[RYGWeekRankingViewController class]] ) {
            RYGWeekRankingViewController *weekViewController = [self.subViewControllers objectAtIndex:i];
            [weekViewController aRefresh];
        }
        else if([[self.subViewControllers objectAtIndex:i] isKindOfClass:[RYGMonthRankingViewController class]] ) {
            RYGMonthRankingViewController *monthViewControl = [self.subViewControllers objectAtIndex:i];
            [monthViewControl aRefresh];
        }
        else if([[self.subViewControllers objectAtIndex:i] isKindOfClass:[RYGVipRankingViewController class]] ) {
            RYGVipRankingViewController *vipViewController = [self.subViewControllers objectAtIndex:i];
            [vipViewController aRefresh];
        }
        else if([[self.subViewControllers objectAtIndex:i] isKindOfClass:[RYGActiveRankingViewController class]] ) {
            RYGActiveRankingViewController *activeViewController = [self.subViewControllers objectAtIndex:i];
            [activeViewController aRefresh];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isBack = YES;
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:@"排行榜"];
}

- (void)removeSystemTabBarItem
{
    for (UIView *subView in self.tabBarController.tabBar.subviews) {
        if ([subView isKindOfClass:[UIControl class]]) {
            subView.hidden = YES;
            [subView removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViewControllers
{
    if (_subViewControllers == nil)
    {
        NSMutableArray *subViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
        
        RYGWeekRankingViewController *weekViewController = [RYGWeekRankingViewController new];
        __weak __typeof(&*self)weakSelf = self;
        weekViewController.toMyPersonBlock = ^(NSString *userId) {
            [weakSelf switchMyInfo:userId];
        };
        weekViewController.toOtherPersonBlock = ^(NSString *userId) {
            [weakSelf switchOtherInfo:userId];
        };
        [subViewControllers addObject:weekViewController];
        [[weekViewController view] setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        [self.scrollView addSubview:[weekViewController view]];
        
        RYGMonthRankingViewController *monthViewControl = [[RYGMonthRankingViewController alloc] init];
        monthViewControl.toMyPersonBlock = ^(NSString *userId) {
            [weakSelf switchMyInfo:userId];
        };
        monthViewControl.toOtherPersonBlock = ^(NSString *userId) {
            [weakSelf switchOtherInfo:userId];
        };
        [subViewControllers addObject:monthViewControl];
        [[monthViewControl view] setFrame:CGRectMake(self.view.width, 0, self.scrollView.width, self.scrollView.height)];
        [self.scrollView addSubview:[monthViewControl view]];
        
        RYGVipRankingViewController *vipViewController = [RYGVipRankingViewController new];
        vipViewController.toMyPersonBlock = ^(NSString *userId) {
            [weakSelf switchMyInfo:userId];
        };
        vipViewController.toOtherPersonBlock = ^(NSString *userId) {
            [weakSelf switchOtherInfo:userId];
        };
        vipViewController.toBuyBlock = ^(NSString *userId) {
//            [weakSelf switchBuy:userId];
        };
        [subViewControllers addObject:vipViewController];
        [[vipViewController view] setFrame:CGRectMake(self.view.width * 2, 0, self.scrollView.width, self.scrollView.height)];
        [self.scrollView addSubview:[vipViewController view]];
        
        RYGActiveRankingViewController *activeViewController = [RYGActiveRankingViewController new];
        activeViewController.toMyPersonBlock = ^(NSString *userId) {
            [weakSelf switchMyInfo:userId];
        };
        activeViewController.toOtherPersonBlock = ^(NSString *userId) {
            [weakSelf switchOtherInfo:userId];
        };
        [subViewControllers addObject:activeViewController];
        [[activeViewController view] setFrame:CGRectMake(self.view.width * 3, 0, self.scrollView.width, self.scrollView.height)];
        [self.scrollView addSubview:[activeViewController view]];
        
        _subViewControllers = subViewControllers;
    }
}

// 点击榜单menu
- (void)menuSelectChange:(NSInteger)index
{
    self.scrollView.contentOffset = CGPointMake(self.view.width * index, 0);
}

// 点击我的排名,进入"我的个人主页";
- (void)switchMyInfo:(NSString *)userId {
    // 是否登录
    RYGUserInfoModel *userInfoModel = [RYGUtility getUserInfo];
    if (userInfoModel.token && ![userInfoModel.token isEqualToString:@""]) {
        RYGUserCenterViewController *myPersonViewController = [[RYGUserCenterViewController alloc]init];
        [self.navigationController pushViewController:myPersonViewController animated:YES];
    }
    else {
        RYGLoginViewController *loginViewController = [[RYGLoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

#pragma mark-
#pragma mark RYGWeekRankTableViewCellDelegate
- (void)switchOtherInfo:(NSString *)userId {
    RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
    otherPersonViewController.userId = userId;
    [self.navigationController pushViewController:otherPersonViewController animated:YES];
}

- (void)switchBuy:(NSString *)userId {
    //跳转私人套餐
    RYGPersonPackageViewController* personPackageVC = [[RYGPersonPackageViewController alloc]init];
    personPackageVC.userid = userId;
    [self.navigationController pushViewController:personPackageVC animated:YES];
}

@end
