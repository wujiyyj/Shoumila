//
//  RYGRecentRecomendView.m
//  近10场推荐情况
//
//  Created by jiaocx on 15/8/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRecentRecomendView.h"

@interface RYGRecentRecomendView ()

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,assign)NSInteger winCount;
@property(nonatomic,assign)NSInteger loseCount;
@property(nonatomic,assign)NSInteger drawCount;

@end

@implementation RYGRecentRecomendView

- (id)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        self.winCount = 0;
        self.loseCount = 0;
        self.drawCount = 0;
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
    [self prepareRecent];
    if (self.recents.count <= 0) {
        UILabel *lblNo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        lblNo.font = [UIFont systemFontOfSize:9];
        lblNo.textColor = ColorSecondTitle;
        lblNo.text = @"最近暂无推荐比赛";
        [self.contentView addSubview:lblNo];
        return;
    }
    
    NSMutableString *strContent = [[NSMutableString alloc]initWithString:@"近10场推荐情况，"];
    
    NSInteger index = strContent.length;
    NSMutableString *strWin;
    if (self.winCount >= 0) {
        strWin = [NSString stringWithFormat:@"%ld胜 ",self.winCount];
        [strContent appendString:strWin];
    }
    
    NSString *strDraw;
    if (self.drawCount >= 0) {
        strDraw = [NSString stringWithFormat:@"%ld平 ",self.drawCount];
        [strContent appendString:strDraw];
    }
    
    NSString *strLose;
    if (self.loseCount >= 0) {
        strLose = [NSString stringWithFormat:@"%ld负",self.loseCount];
        [strContent appendString:strLose];
    }
    
    
    NSMutableAttributedString *stringAS = [[NSMutableAttributedString alloc] initWithString:strContent];
    // 胜利
    [stringAS addAttribute:NSForegroundColorAttributeName value:ColorWin
                     range:NSMakeRange(index, strWin.length)];
    index += strWin.length;
    
    // 平
    [stringAS addAttribute:NSForegroundColorAttributeName value:Colordraw
                     range:NSMakeRange(index, strDraw.length)];
    index += strDraw.length;
    // 负
    [stringAS addAttribute:NSForegroundColorAttributeName value:ColorLose
                     range:NSMakeRange(index, strLose.length)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:9];
    label.textColor = ColorSecondTitle;
    label.attributedText = stringAS;
    
    [self.contentView addSubview:label];
}

- (void )prepareRecent {
    self.drawCount  = 0;
    self.winCount = 0;
    self.loseCount = 0;
    // 1平2胜3负
    for (int i = 0; i < [self.recents count]; i++) {
        NSNumber *recentCode = [self.recents objectAtIndex:i];
        if ([recentCode isEqual:[NSNumber numberWithInt:1]]) {
            ++self.drawCount;
        }
        else if([recentCode isEqual:[NSNumber numberWithInt:2]])
        {
            ++self.winCount;
        }
        else {
            ++self.loseCount;
        }
    }
}

// 1平2胜3负
- (UIColor *)colorWithCode:(NSString *)recentCode {
    if ([recentCode isEqual:[NSNumber numberWithInt:1]]) {
        return  Colordraw;
    }
    else if([recentCode isEqual:[NSNumber numberWithInt:2]])
    {
        return ColorWin;
    }
    else {
        return  ColorLose;
    }
}

@end
