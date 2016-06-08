//
//  RYGSlideMenuView.m
//  滑动切换页面的按钮
//
//  Created by jiaocx on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGHomeSlideMenuView.h"


@interface RYGHomeSlideMenuView ()
{
    NSMutableArray *_titleLabels;
}

@property(nonatomic,strong)NSArray * menuTitles;
@property(nonatomic,strong)UIView *lineView;


@end

@implementation RYGHomeSlideMenuView

- (id)initWithFrame:(CGRect)frame menuTitles:(NSArray *)menuTitles {
    self = [super initWithFrame:frame];
    if (self ) {
        self.backgroundColor = ColorRankMenuBackground;
        _menuTitles = menuTitles;
        [self setupMenus];
    }
    return self;
}

- (void)setupMenus {
    _titleLabels = [[NSMutableArray alloc]init];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    
    [leftBtn addTarget:self action:@selector(sliderLeft) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:leftBtn];
    UIButton *sliderLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sliderLeftBtn addTarget:self action:@selector(sliderLeft) forControlEvents:UIControlEventTouchUpInside];
    sliderLeftBtn.frame = CGRectMake(15, 30, 20, 20);
    [sliderLeftBtn setBackgroundImage:[UIImage imageNamed:@"leftIcon"] forState:UIControlStateNormal];
    [self addSubview:sliderLeftBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.frame = CGRectMake(SCREEN_WIDTH - 68, 30, 20, 20);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    publishBtn.frame = CGRectMake(SCREEN_WIDTH - 35, 30, 20, 20);
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [self addSubview:publishBtn];
    UIButton *publishBtnBig = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtnBig.frame = CGRectMake(SCREEN_WIDTH - 45, 0, 45, 45);
    [publishBtnBig addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:publishBtnBig];
    NSInteger count = [self.menuTitles count];
    for (int index = 0; index < count; index++) {
        NSString *text = [self.menuTitles objectAtIndex:index];
        UIControl *menu = [[UIControl alloc]initWithFrame:CGRectMake(60*index+(CGRectGetMidX(sliderLeftBtn.frame)+60)*SCREEN_SCALE, 20, 50, self.height - 20)];
        [menu addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        menu.tag = index;
        [self addSubview:menu];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, menu.width, menu.height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = text;
        [_titleLabels addObject:titleLabel];
        [menu addSubview:titleLabel];
    }
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 5 - 1, 48, 1)];
    _lineView.backgroundColor = ColorRankBackground;
    [self addSubview:_lineView];
}

- (void)sliderLeft{
    if (self.sliderLeftBlock) {
        self.sliderLeftBlock();
    }
}

- (void)searchAction{
    if (self.searchBlock) {
        self.searchBlock();
    }
}

- (void)publishAction{
    if (self.publishBlock) {
        self.publishBlock();
    }
}

- (void)menuClick:(id)sender {
    UIControl *menu = sender;
    NSInteger index = menu.tag;
    [self setSelectedIndex:index];
}

- (void)setSelectedIndex:(NSInteger)index {
    self.currentSelectedIndex = index;
    if (self.selectBlock) {
        self.selectBlock(index);
    }
}

- (void)updateSelectMenu {
    for (int index = 0; index < [self.menuTitles count]; index++) {
        UILabel *titleLabel = _titleLabels[index];
        if (index == self.currentSelectedIndex) {
            [UIView animateWithDuration:0.25 animations:^{
                titleLabel.textColor = _transitionTextAttributes[MenuColor];
                titleLabel.font = _transitionTextAttributes[MenuFont];
                CGSize size = RYG_TEXTSIZE(titleLabel.text, _transitionTextAttributes[MenuFont]);
                
                _lineView.frame = CGRectMake(60*index+95*SCREEN_SCALE-2, self.height - 5 - 1, size.width, 1);
            } completion:^(BOOL finished) {
                titleLabel.textColor = _selectedTextAttributes[MenuColor];
                titleLabel.font = _selectedTextAttributes[MenuFont];
            }];
        } else {
            titleLabel.font = _textAttributes[MenuFont];
            titleLabel.textColor = _textAttributes[MenuColor];
        }
    }
}

- (void)setCurrentSelectedIndex:(NSUInteger)currentSelectedIndex {
    _currentSelectedIndex = currentSelectedIndex;
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeNotification object:[NSNumber numberWithInteger:currentSelectedIndex]];
    [self updateSelectMenu];
}

@end
