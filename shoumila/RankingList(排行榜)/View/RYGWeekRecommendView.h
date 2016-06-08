//
//  RYGWeekRecommendView.h
//  推荐胜/周推荐
//
//  Created by jiaocx on 15/7/31.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYGWeekRecommendView : UIView

- (id)initWithFrame:(CGRect)frame smallFontSize:(NSInteger)smallFontSize largeFontSize:(NSInteger)largeFontSize
recommendWinGamesColor:(UIColor *)recommendWinGamesColor recommendGamesFontColor:(UIColor* )recommendGamesFontColor;
- (void)setRecommendWinGames:(NSString *)recommendWinGames recommendGames:(NSString *)recommendGames ;

@end
