//
//  RYGBaseViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"

@interface RYGBaseViewController ()

@end

@implementation RYGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorViewBackground;
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pressLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //创建一个高20的假状态栏背景
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    //将它的颜色设置成你所需要的，这里我选择了黑色，表示我很沉稳
    statusBarView.backgroundColor=ColorTabBarButtonTitleSelected;
    //这里我的思路是：之前不理想的状态是状态栏颜色也变成了导航栏的颜色，但根据这种情况，反而帮助我判断出此时的状态栏也是导航栏的一部分，而状态栏文字浮于上方，因此理论上直接在导航栏上添加一个subview就是他们中间的那一层了。
    //推得这样的代码：
    [self.navigationController.navigationBar addSubview:statusBarView];
    //修改导航栏文字颜色，这里我选择白色，表示我很纯洁
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置导航栏的背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nava_bar"] forBarMetrics:UIBarMetricsDefault];
}

- (void)pressLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
