//
//  RYGSlideMenuView.m
//  滑动切换页面的按钮
//
//  Created by jiaocx on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSlideMenuView.h"


@interface RYGSlideMenuView ()
{
    NSMutableArray *_titleLabels;
}

@property(nonatomic,strong)NSArray *menuTitles;
@property(nonatomic,strong)UIView *lineView;

@end

@implementation RYGSlideMenuView

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
    NSInteger count = [self.menuTitles count];
    for (int index = 0; index < count; index++) {
        NSString *text = [self.menuTitles objectAtIndex:index];
        UIControl *menu = [[UIControl alloc]initWithFrame:CGRectMake(self.width / count * index, 20, self.width / count, self.height - 20)];
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
    _lineView = [[UIView alloc]initWithFrame:CGRectMake((self.width / [self.menuTitles count] - 48) / 2 , self.height - 5 - 1, 48, 1)];
    _lineView.backgroundColor = ColorRankBackground;
    [self addSubview:_lineView];
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
                
                _lineView.frame = CGRectMake((self.width / [self.menuTitles count] - size.width) / 2 + self.width / [self.menuTitles count] * index, self.height - 5 - 1, size.width, 1);
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
    [self updateSelectMenu];
}

@end
