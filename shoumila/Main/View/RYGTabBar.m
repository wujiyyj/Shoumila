//
//  RYGBaseViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGTabBar.h"
#import "RYGTabBarButton.h"
#import "UIImage+MJ.h"
@interface RYGTabBar()
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) RYGTabBarButton *selectedButton;
@end

@implementation RYGTabBar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

       
    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    RYGTabBarButton *button = [[RYGTabBarButton alloc] init];
    [self addSubview:button];
    [self.tabBarButtons addObject:button];
    button.item = item;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(RYGTabBarButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

-(void)selectedMenu:(NSUInteger)selectedIndex {
    RYGTabBarButton *button = [self.tabBarButtons objectAtIndex:selectedIndex];
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整加号按钮的位置
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    // 按钮的frame数据
    CGFloat buttonH = h;
    CGFloat buttonW = w / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.tabBarButtons.count; index++) {
        RYGTabBarButton *button = self.tabBarButtons[index];
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
         buttonX += buttonW;
        button.tag = index;
    }
}
@end
