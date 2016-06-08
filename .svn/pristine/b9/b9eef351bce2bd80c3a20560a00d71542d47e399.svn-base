//
//  RYGWeekRecommendView.m
//  推荐胜/周推荐
//
//  Created by jiaocx on 15/7/31.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGWeekRecommendView.h"

@interface RYGWeekRecommendView ()

// 推荐胜
@property(nonatomic,assign)NSString * recommendWinGames;
@property (nonatomic,assign) NSInteger smallFontSize;
@property (nonatomic,strong) UIColor *recommendWinGamesColor;
// 周推荐
@property(nonatomic,assign)NSString * recommendGames;
@property (nonatomic,assign) NSInteger largeFontSize;
@property (nonatomic,strong) UIColor *recommendGamesFontColor;

@end

@implementation RYGWeekRecommendView

- (id)initWithFrame:(CGRect)frame smallFontSize:(NSInteger)smallFontSize largeFontSize:(NSInteger)largeFontSize
recommendWinGamesColor:(UIColor *)recommendWinGamesColor recommendGamesFontColor:(UIColor* )recommendGamesFontColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.smallFontSize = smallFontSize;
        self.largeFontSize = largeFontSize;
        self.recommendWinGamesColor = recommendWinGamesColor;
        self.recommendGamesFontColor = recommendGamesFontColor;
    }
    return self;
}

- (void)setRecommendWinGames:(NSString *)recommendWinGames recommendGames:(NSString *)recommendGames {
    self.recommendWinGames = recommendWinGames;
    self.recommendGames = recommendGames;
    [self setupView];
}

- (void)setupView
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSString *strRecommendWinGames = [NSString stringWithFormat:@"%@",self.recommendWinGames];
    NSMutableAttributedString *stringAS = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@场/%@场",self.recommendWinGames,self.recommendGames]];
    NSInteger index = strRecommendWinGames.length;
    // 数字
    [stringAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.largeFontSize] range:NSMakeRange(0, strRecommendWinGames.length)];
    [stringAS addAttribute:NSForegroundColorAttributeName value:self.recommendWinGamesColor
                     range:NSMakeRange(0, strRecommendWinGames.length)];
    
    // 场
    [stringAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.smallFontSize] range:NSMakeRange(index, 1)];
    [stringAS addAttribute:NSForegroundColorAttributeName value:self.recommendGamesFontColor
                     range:NSMakeRange(index, 1)];
    index = index + 1;
    // “／”
    [stringAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.largeFontSize] range:NSMakeRange(index, 1)];
    [stringAS addAttribute:NSForegroundColorAttributeName value:self.recommendGamesFontColor
                     range:NSMakeRange(index, 1)];
    index = index + 1;
    
    // 数字
    NSString *strRecommendGames = [NSString stringWithFormat:@"%@",self.recommendGames];
    [stringAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.largeFontSize] range:NSMakeRange(index, strRecommendGames.length)];
    [stringAS addAttribute:NSForegroundColorAttributeName value:self.recommendGamesFontColor
                     range:NSMakeRange(index, strRecommendGames.length)];
    index = index + strRecommendGames.length;
    // 场
    [stringAS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.smallFontSize] range:NSMakeRange(index, 1)];
    [stringAS addAttribute:NSForegroundColorAttributeName value:self.recommendGamesFontColor
                     range:NSMakeRange(index, 1)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = stringAS;

    [self addSubview:label];
}


@end
