//
//  RYGRecentView.m
//  最近（用圈表示）
//
//  Created by jiaocx on 15/8/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRecentView.h"
#import "RYGCircleView.h"

@interface RYGRecentView ()

@property(nonatomic,strong)UIView *contentView;

@end

@implementation RYGRecentView

- (id)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setRecents:(NSArray *)recents {
    _recents = recents;
    [self updateCell];
}

- (void)updateCell {
    [self.contentView removeFromSuperview];
    _contentView = [[UIView alloc]initWithFrame:self.bounds];
    
    [self addSubview:_contentView];
    if (self.recents.count <= 0) {
        return;
    }
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [RYGRecentView recentSize].width, self.height)];
    title.font = [UIFont systemFontOfSize:9];
    title.textColor = ColorSecondTitle;
    title.text = @"最近";
    [self.contentView addSubview:title];
    CGFloat cicleWidth = 0;
    CGFloat maginRgiht = CGRectGetMaxX(title.frame) + 5;
    for (int i = 0; i < [self.recents count]; i++) {
        UIColor *fillColor = [self colorWithCode:[self.recents objectAtIndex:i]];
        RYGCircleView *circle = [[RYGCircleView alloc]initWithFrame:CGRectMake(cicleWidth + maginRgiht,(self.height - kCircleCornerRadius) / 2, kCircleCornerRadius, kCircleCornerRadius) fillColor:fillColor];
        [self.contentView addSubview:circle];
        
        cicleWidth += kCircleCornerRadius + maginRgiht;
        maginRgiht = 4;
    }
}

+ (CGSize)recentSize {
    CGSize size = RYG_TEXTSIZE(@"最近",[UIFont systemFontOfSize:9]);
    return size;
}

// 1平2胜3负
- (UIColor *)colorWithCode:(NSNumber *)recentCode {
    if ([recentCode isEqualToNumber:[NSNumber numberWithInt:1]]) {
       return  Colordraw;
    }
    else if([recentCode isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        return ColorWin;
    }
    else {
       return  ColorLose;
    }
}

@end
