//
//  RYGMenuItemView.m
//  shoumila
//
//  Created by yinyujie on 15/8/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMenuItemView.h"

@interface RYGMenuItemView ()
{
    NSMutableArray *_titleLabels;
    NSMutableArray *_lineViews;
}

@property(nonatomic,strong)NSArray * menuTitles;

@end

@implementation RYGMenuItemView

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
    _lineViews = [[NSMutableArray alloc]init];
    NSInteger count = [self.menuTitles count];
    for (int index = 0; index < count; index++) {
        NSString *text = [self.menuTitles objectAtIndex:index];
        UIControl *menu = [[UIControl alloc]initWithFrame:CGRectMake(self.width / count * index, 0, self.width / count, self.height)];
        [menu addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        menu.tag = index;
        [self addSubview:menu];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, menu.width, menu.height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = text;
        [_titleLabels addObject:titleLabel];
        [menu addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(menu.width/2-28, 28.5, 56, 1.5)];
        lineView.backgroundColor = ColorRankMenuBackground;
        [_lineViews addObject:lineView];
        [menu addSubview:lineView];
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
        UIView *lineView = _lineViews[index];
        if (index == self.currentSelectedIndex) {
            [UIView animateWithDuration:0.25 animations:^{
                titleLabel.textColor = _transitionTextAttributes[MenuColor];
                titleLabel.font = _transitionTextAttributes[MenuFont];
                lineView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                titleLabel.textColor = _selectedTextAttributes[MenuColor];
                titleLabel.font = _selectedTextAttributes[MenuFont];
                lineView.backgroundColor = ColorRankMenuBackground;
            }];
        } else {
            titleLabel.font = _textAttributes[MenuFont];
            titleLabel.textColor = _textAttributes[MenuColor];
            lineView.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)setCurrentSelectedIndex:(NSUInteger)currentSelectedIndex {
    _currentSelectedIndex = currentSelectedIndex;
    [self updateSelectMenu];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
