//
//  RYGPackageViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPackageViewController.h"
#import "RYGPack1ViewController.h"
#import "RYGPack2ViewController.h"

@interface RYGPackageViewController ()

@end

@implementation RYGPackageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"私人套餐"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"私人套餐"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RYGPack1ViewController* pack1Controller = [[RYGPack1ViewController alloc]init];
    RYGPack2ViewController* pack2Controller = [[RYGPack2ViewController alloc]init];
    [self setViewControllers:@[pack1Controller, pack2Controller] titles:@[@"我购买的",@"我创建的"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
