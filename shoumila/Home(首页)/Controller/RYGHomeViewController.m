//
//  RYGRankingListViewController.m
//  排行榜
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGHomeViewController.h"
#import "RYGHomeDynamicViewController.h"
#import "RYGHomeSlideMenuView.h"
#import "RYGScrollPageView.h"
#import "RYGHomeBeforeViewController.h"
#import "RYGHomeGunQiuViewController.h"
#import "RYGSearchViewController.h"
#import "RYGNavigationController.h"
#import "RYGPublishViewController.h"

@interface RYGHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)RYGHomeSlideMenuView *slideMenuVieiw;
@property (nonatomic, strong)RYGScrollPageView *scrollView;
@property (nonatomic, strong)NSArray *subViewControllers;
@property (nonatomic, strong)UIButton *btn;
@end

@implementation RYGHomeViewController{
    float fromX;
    float toX;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fromX = 0;
    toX = RYGMenuWidth;
    NSArray *menuTitles = [NSArray arrayWithObjects:@"动态", @"赛前", @"滚球",nil];
    _slideMenuVieiw = [[RYGHomeSlideMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64) menuTitles:menuTitles];
    _slideMenuVieiw.textAttributes = @{MenuFont:[UIFont systemFontOfSize:14], MenuColor:ColorRankUnSelectedTitle};
    _slideMenuVieiw.selectedTextAttributes = @{MenuFont:[UIFont systemFontOfSize:15], MenuColor:ColorViewBackground};
    _slideMenuVieiw.transitionTextAttributes = @{MenuFont:[UIFont systemFontOfSize:16], MenuColor:ColorViewBackground};
    _slideMenuVieiw.currentSelectedIndex = 0;
    __weak __typeof(&*self)weakSelf = self;
    _slideMenuVieiw.selectBlock = ^(NSInteger index) {
        weakSelf.scrollView.currentPage = index;
        [weakSelf menuSelectChange:index];
    };
    _slideMenuVieiw.sliderLeftBlock = ^{
        [weakSelf silderHomeView];
    };
    _slideMenuVieiw.searchBlock = ^{
        [weakSelf searchAction];
    };
    _slideMenuVieiw.publishBlock = ^{
        [weakSelf publishAction];
    };
    [self.view addSubview:_slideMenuVieiw];
    
    _scrollView = [[RYGScrollPageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height) withPageNums:menuTitles.count];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollsToTop = NO;
    _scrollView.scrollBlock = ^(NSInteger index) {
        weakSelf.slideMenuVieiw.currentSelectedIndex = index;
    };
    [self.view addSubview:_scrollView];
    [self initSubViewControllers];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuViewNotify:) name:MENU_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goHomeView) name:HOMEVIEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToUserCenter) name:USERCENTER_NOTIFICATION object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self removeSystemTabBarItem];
    
    [MobClick beginLogPageView:@"首页"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"首页"];
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
        
        RYGHomeDynamicViewController *homeDynamicViewController = [[RYGHomeDynamicViewController alloc]init];
        homeDynamicViewController.type = @"0";
        [subViewControllers addObject:homeDynamicViewController];
        [[homeDynamicViewController view] setFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        [self.scrollView addSubview:[homeDynamicViewController view]];
        
        RYGHomeDynamicViewController *beforeViewController = [[RYGHomeDynamicViewController alloc] init];
        beforeViewController.type = @"1";
        [subViewControllers addObject:beforeViewController];
        [[beforeViewController view] setFrame:CGRectMake(self.view.width, 0, self.scrollView.width, self.scrollView.height)];
        [self.scrollView addSubview:[beforeViewController view]];
        
        RYGHomeDynamicViewController *gunQiuController = [RYGHomeDynamicViewController new];
        gunQiuController.type = @"2";
        [subViewControllers addObject:gunQiuController];
        [[gunQiuController view] setFrame:CGRectMake(self.view.width * 2, 0, self.scrollView.width, self.scrollView.height)];
        [self.scrollView addSubview:[gunQiuController view]];
        _subViewControllers = subViewControllers;
    }
}

// 点击榜单menu
- (void)menuSelectChange:(NSInteger)index
{
    self.scrollView.contentOffset = CGPointMake(self.view.width * index, 0);
}

- (void)menuViewNotify:(NSNotification *)notification{
    if (notification) {
        UIViewController *obj = [notification object];
        [self.navigationController pushViewController:obj animated:YES];
    }
    [self silderHomeView];
}

- (void)goToUserCenter{
    self.tabBarController.selectedIndex = 4;
    [self silderHomeView];
}
- (void)goHomeView{
    self.tabBarController.selectedIndex = 0;
//    [self silderHomeView];
}
- (void)silderHomeView{
    if (![RYGUtility validateUserLogin]) {
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:MENU_ITEMS object:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.view.left = toX;
    }];
    
    if (toX!=0) {
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _btn.backgroundColor = [UIColor blackColor];
        [UIView animateWithDuration:0.3 animations:^{
            _btn.left = toX;
        }];
        
        [_btn addTarget:self action:@selector(silderHomeView) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:_btn];
        _btn.alpha = 0.2;
    }else{
        [_btn removeFromSuperview];
        _btn.alpha = 0;
    }
    
    float flag = toX;
    toX = fromX;
    fromX = flag;
}

- (void)searchAction{

    RYGSearchViewController *searchController = [[RYGSearchViewController alloc]init];
    RYGNavigationController *nav = [[RYGNavigationController alloc]initWithRootViewController:searchController];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)publishAction{
    if (![RYGUtility validateUserLogin]) {
        return;
    }
    RYGPublishViewController *publishController = [[RYGPublishViewController alloc]init];
    RYGNavigationController *nav = [[RYGNavigationController alloc]initWithRootViewController:publishController];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
@end
