//
//  RYGGrandeMarkView.m
//  等级标志
//
//  Created by jiaocx on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGGrandeMarkView.h"
#import "RYGIntegralRankParser.h"
#import "Masonry.h"

@implementation RYGGrandeMarkView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setIntegralRank:(NSString *)integralRank {
    _integralRank = integralRank;
    [self setupGrandeMarkView];
}

- (void)setupGrandeMarkView {
    self.level = [UILabel new];
    self.level.textColor = ColorYeallow;
    self.level.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.level];
    [self.level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 0));
    }];
    self.level.text = [NSString stringWithFormat:@"Lv.%@", self.integralRank];
    return;
    //原来的样式
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _rankImages = [RYGIntegralRankParser image:self.integralRank];
     CGFloat imageWidth = 0;
    CGFloat maginLeft = 0;
    CGFloat needWidth = 0;
    CGFloat rest = self.width;
    for (int i = 0; i < [_rankImages count]; i++) {
        NSString *rankImage = [_rankImages objectAtIndex:i];
        UIImage *iconImage = [UIImage imageNamed:rankImage];
        needWidth = iconImage.size.width;
        if ([rankImage isEqualToString:@"rank_star"]) {
            maginLeft = 3;
        }
        else {
            maginLeft = 4;
        }
        // 显示不全
        if (needWidth +  maginLeft > rest) {
            if (rest < 4) {
                UIImageView *igView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth, (self.height - 2) / 2, 1, 2)];
                igView.image = [UIImage imageNamed:@"rank_rest2"];
                [self addSubview:igView];
            }
            else {
                UIImageView *igView = [[UIImageView alloc] initWithFrame:CGRectMake(3 + imageWidth, (self.height - 2) / 2, 2, 2)];
                igView.image = [UIImage imageNamed:@"rank_rest1"];
                [self addSubview:igView];
            }
//            return;
        }

        UIImageView *igView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth + maginLeft, (self.height - iconImage.size.height) / 2, iconImage.size.width, iconImage.size.height)];
        igView.image = iconImage;
        imageWidth += iconImage.size.width + maginLeft;
        rest = rest - iconImage.size.width - maginLeft;
        self.width = CGRectGetMaxX(igView.frame);
        [self addSubview:igView];
    }
}

- (CGFloat)getGrandWidth:(NSString *)integralRank {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _rankImages = [RYGIntegralRankParser image:self.integralRank];
    CGFloat imageWidth = 0;
    CGFloat maginLeft = 0;
    CGFloat needWidth = 0;
    CGFloat rest = self.width;
    for (int i = 0; i < [_rankImages count]; i++) {
        NSString *rankImage = [_rankImages objectAtIndex:i];
        UIImage *iconImage = [UIImage imageNamed:rankImage];
        needWidth = iconImage.size.width;
        if ([rankImage isEqualToString:@"rank_star"]) {
            maginLeft = 3;
        }
        else {
            maginLeft = 4;
        }
        // 显示不全
        if (needWidth +  maginLeft > rest) {
            if (rest < 4) {
                UIImageView *igView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth, (self.height - 2) / 2, 1, 2)];
                igView.image = [UIImage imageNamed:@"rank_rest2"];
                [self addSubview:igView];
            }
            else {
                UIImageView *igView = [[UIImageView alloc] initWithFrame:CGRectMake(3 + imageWidth, (self.height - 2) / 2, 2, 2)];
                igView.image = [UIImage imageNamed:@"rank_rest1"];
                [self addSubview:igView];
            }
            //            return;
        }
        
        UIImageView *igView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth + maginLeft, (self.height - iconImage.size.height) / 2, iconImage.size.width, iconImage.size.height)];
        igView.image = iconImage;
        imageWidth += iconImage.size.width + maginLeft;
        rest = rest - iconImage.size.width - maginLeft;
        self.width = CGRectGetMaxX(igView.frame);
        [self addSubview:igView];
    }
    NSLog(@"widthhhhhhhh ---- %f",self.width);
    return self.width;
}

@end
