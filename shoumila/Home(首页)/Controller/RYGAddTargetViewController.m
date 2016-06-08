//
//  RYGAddTargetViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/9/19.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAddTargetViewController.h"

@interface RYGAddTargetViewController ()
@property(nonatomic,strong) NSMutableArray  *data;
@property(nonatomic,strong) NSString        *plistPath;

@end

@implementation RYGAddTargetViewController{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快速添加标签";
    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 300, 15)];
    detail.font = [UIFont systemFontOfSize:14];
    detail.textColor = ColorSecondTitle;
    detail.text = @"选中要添加的快捷标签";
    [self.view addSubview:detail];
    _plistPath = [[NSBundle mainBundle] pathForResource:@"MenuItem" ofType:@"plist"];
    _data = [[NSMutableArray alloc] initWithContentsOfFile:_plistPath];
    
     btn1 = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREEN_SCALE, 44, 76, 30*SCREEN_SCALE)];
    [btn1 setTitle:@"我的动态" forState:UIControlStateNormal];
    [btn1 setTitleColor:ColorName forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn1.layer.cornerRadius = 4;
    btn1.layer.borderWidth = 1;
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    btn1.layer.borderColor = ColorLine.CGColor;
    [btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREEN_SCALE, 44, 76, 30*SCREEN_SCALE)];
    btn2.center = CGPointMake(SCREEN_WIDTH/2, 59);
    [btn2 setTitle:@"我的关注" forState:UIControlStateNormal];
    [btn2 setTitleColor:ColorName forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn2.layer.cornerRadius = 4;
    btn2.layer.borderWidth = 1;
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    btn2.layer.borderColor = ColorLine.CGColor;
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 91*SCREEN_SCALE, 44, 76, 30*SCREEN_SCALE)];
    [btn3 setTitle:@"我的套餐" forState:UIControlStateNormal];
    [btn3 setTitleColor:ColorName forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn3.layer.cornerRadius = 4;
    btn3.layer.borderWidth = 1;
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    btn3.layer.borderColor = ColorLine.CGColor;
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(btn3Action:) forControlEvents:UIControlEventTouchUpInside];
    
    btn4 = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREEN_SCALE, 90, 76, 30*SCREEN_SCALE)];
    [btn4 setTitle:@"我的收藏" forState:UIControlStateNormal];
    [btn4 setTitleColor:ColorName forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn4.layer.cornerRadius = 4;
    btn4.layer.borderWidth = 1;
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    btn4.layer.borderColor = ColorLine.CGColor;
    [self.view addSubview:btn4];
    [btn4 addTarget:self action:@selector(btn4Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [_data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKey:@"name"]isEqualToString:@"我的动态"]) {
            btn1.selected = YES;
            btn1.backgroundColor = ColorRankMenuBackground;
        }else if ([[obj valueForKey:@"name"]isEqualToString:@"我的关注"]){
            btn2.selected = YES;
            btn2.backgroundColor = ColorRankMenuBackground;
        }else if ([[obj valueForKey:@"name"]isEqualToString:@"我的套餐"]){
            btn3.selected = YES;
            btn3.backgroundColor = ColorRankMenuBackground;
        }else if ([[obj valueForKey:@"name"]isEqualToString:@"我的收藏"]){
            btn4.selected = YES;
            btn4.backgroundColor = ColorRankMenuBackground;
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"快速添加标签"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableArray *datas = [NSMutableArray array];
    if (btn1.isSelected) {
        [datas addObject:@{@"name":@"我的动态",@"class":@"RYGDynamicViewController"}];
    }
    if (btn2.isSelected){
        [datas addObject:@{@"name":@"我的关注",@"class":@"RYGFansViewController"}];
    }
    if (btn3.isSelected){
        [datas addObject:@{@"name":@"我的套餐",@"class":@"RYGPackageViewController"}];
    }
    if (btn4.isSelected){
        [datas addObject:@{@"name":@"我的收藏",@"class":@"RYGCollectionViewController"}];
    }
    [datas writeToFile:_plistPath atomically:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:MENU_ITEMS object:nil];
    
    [MobClick endLogPageView:@"快速添加标签"];
}

- (void)btn1Action:(UIButton *)btn{
    btn1.selected = !btn.isSelected;
    if (btn.isSelected) {
        btn1.backgroundColor = ColorRankMenuBackground;
    }else{
        btn1.backgroundColor = [UIColor whiteColor];
    }
}
- (void)btn2Action:(UIButton *)btn{
    btn2.selected = !btn.isSelected;
    if (btn.isSelected) {
        btn2.backgroundColor = ColorRankMenuBackground;
    }else{
        btn2.backgroundColor = [UIColor whiteColor];
    }
}
- (void)btn3Action:(UIButton *)btn{
    btn3.selected = !btn.isSelected;
    if (btn.isSelected) {
        btn3.backgroundColor = ColorRankMenuBackground;
    }else{
        btn3.backgroundColor = [UIColor whiteColor];
    }
}
- (void)btn4Action:(UIButton *)btn{
    btn4.selected = !btn.isSelected;
    if (btn.isSelected) {
        btn4.backgroundColor = ColorRankMenuBackground;
    }else{
        btn4.backgroundColor = [UIColor whiteColor];
    }
}

-(void)removeItem:(NSInteger)index{
    [_data writeToFile:_plistPath atomically:YES];
    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:_plistPath];
}
@end
