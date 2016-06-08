//
//  RYGActiveSectionView.m
//  活跃榜
//
//  Created by jiaocx on 15/8/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGActiveSectionView.h"
#import "RYGGrandeMarkView.h"
#import "RYGActivePersonModel.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGDistributeStickView.h"

#define ActiveRankTableViewCell_Top_Magin  15
#define ActiveRankTableViewCell_Logo_Left_Magin  39
#define ActiveRankTableViewCell_Name_Left_Magin  5
#define ActiveRankTableViewCell_Right_Magin 17

@interface RYGActiveSectionView ()

// 奖牌排名
@property(nonatomic,strong)UIImageView *weekRankMedalImageView;
// 奖牌排名
@property(nonatomic,strong)UILabel *lblWeekRankMedal;
// 头像
@property(nonatomic,strong)UIImageView *userLogoImageView;
// 用户名
@property(nonatomic,strong)UILabel *lblUserName;
// 等级标志
@property(nonatomic,strong)RYGGrandeMarkView *grandMarkView;
// 各项指数的图标示
@property(nonatomic,strong)RYGDistributeStickView *distributeStickView;
// 分数
@property(nonatomic,strong)UILabel *lblScore;

// 点击个人区域跳转TA个人主页;
@property(nonatomic,strong)UIControl *otherPersonCtl;

@end

@implementation RYGActiveSectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.width, ActiveRankSectionHeight)];
    [control addTarget:self action:@selector(onClickView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    // 奖牌排名
    _weekRankMedalImageView = [[UIImageView alloc]initWithFrame:CGRectMake((39-26) / 2,ActiveRankTableViewCell_Top_Magin + (32-30)/2 , 26, 30)];
    [self addSubview:_weekRankMedalImageView];
    
    // 奖牌排名
    _lblWeekRankMedal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), ActiveRankTableViewCell_Top_Magin, 35, 30)];
    _lblWeekRankMedal.font = [UIFont boldSystemFontOfSize:18];
    _lblWeekRankMedal.textColor = ColorRankMedal;
    _lblWeekRankMedal.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lblWeekRankMedal];
    
    // 头像
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ActiveRankTableViewCell_Logo_Left_Magin, ActiveRankTableViewCell_Top_Magin, 32, 32)];
    _userLogoImageView.layer.cornerRadius = 4;
    _userLogoImageView.layer.masksToBounds = YES;
    _userLogoImageView.backgroundColor = ColorRankMyRankBackground;
    [self addSubview:_userLogoImageView];
    
    _otherPersonCtl = [[UIControl alloc]initWithFrame:_userLogoImageView.frame];
    [_otherPersonCtl addTarget:self action:@selector(switchOtherPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_otherPersonCtl];
    
    // 用户名
    _lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + ActiveRankTableViewCell_Name_Left_Magin, ActiveRankTableViewCell_Top_Magin, self.width - ActiveRankTableViewCell_Right_Magin  - CGRectGetMaxX(_userLogoImageView.frame) - ActiveRankTableViewCell_Name_Left_Magin, 13)];
    _lblUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblUserName.font = [UIFont boldSystemFontOfSize:13];
    _lblUserName.textColor = ColorName;
    _lblUserName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_lblUserName];
    
    // 分数
    _lblScore = [[UILabel alloc]initWithFrame:CGRectMake(self.width - CGRectGetMinX(_lblUserName.frame) - Stick_Width - 17, 0, self.width - Stick_Width - 17 - CGRectGetMinX(_lblUserName.frame), self.height)];
    _lblScore.textAlignment = NSTextAlignmentRight;
    _lblScore.textColor = ColorName;
    _lblScore.font = [UIFont systemFontOfSize:10];
    [self addSubview:_lblScore];
    
    _distributeStickView = [[RYGDistributeStickView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblUserName.frame), CGRectGetMaxY(_lblUserName.frame) + 10, Stick_Width, 7)];
    [self addSubview:_distributeStickView];
    
    // 等级标志
    _grandMarkView = [[RYGGrandeMarkView alloc]init];
    [self addSubview:_grandMarkView];
}

// 根据数据重新设置cell单元格
- (void)setPersonRankingModel:(RYGActivePersonModel *)personRankingModel {
    _personRankingModel = personRankingModel;
    [self updateData];
}

//  更新数据
- (void)updateData {
    // 奖牌排名
    if ([self.personRankingModel.ranking isEqualToString:@"1"] || [self.personRankingModel.ranking isEqualToString:@"2"] || [self.personRankingModel.ranking isEqualToString:@"3"]) {
        _weekRankMedalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"active_rank_ medal%@",self.personRankingModel.ranking]];
        _weekRankMedalImageView.hidden = NO;
        _lblWeekRankMedal.hidden = YES;
    }
    else {
        _weekRankMedalImageView.hidden = YES;
        _lblWeekRankMedal.hidden = NO;
        CGSize rankSize = RYG_TEXTSIZE(self.personRankingModel.ranking, [UIFont systemFontOfSize:18]);
        CGFloat width = 34;
        if (rankSize.width > width) {
            width = rankSize.width;
        }
        _lblWeekRankMedal.frame = CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), ActiveRankTableViewCell_Top_Magin, width, 30);
        _lblWeekRankMedal.text = self.personRankingModel.ranking;
    }
    // 头像
    [_userLogoImageView setImageURLStr:self.personRankingModel.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
    // 用户名
    _lblUserName.text = self.personRankingModel.user_name;
    // 用户名
    CGSize userNameSize = RYG_TEXTSIZE(_lblUserName.text, [UIFont boldSystemFontOfSize:13]);
    CGFloat userNameWidth = MIN(userNameSize.width, self.width - ActiveRankTableViewCell_Right_Magin - CGRectGetMaxX(_userLogoImageView.frame) - ActiveRankTableViewCell_Name_Left_Magin);
    _lblUserName.frame = CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + ActiveRankTableViewCell_Name_Left_Magin, ActiveRankTableViewCell_Top_Magin,userNameWidth, userNameSize.height);
    // 等级标志
    _grandMarkView.frame = CGRectMake(CGRectGetMaxX(_lblUserName.frame), CGRectGetMinY(_lblUserName.frame), self.width - CGRectGetMaxX(_lblUserName.frame) - 15 - 3, 15);
    _grandMarkView.integralRank = self.personRankingModel.grade;
    
    _lblScore.text = [NSString stringWithFormat:@"%@分",self.personRankingModel.score];
    CGSize size = RYG_TEXTSIZE(_lblScore.text, [UIFont systemFontOfSize:10]);
    _lblScore.frame = CGRectMake(self.width - 17 - size.width, CGRectGetMaxY(_lblUserName.frame) + 10 - (size.height - 7) / 2, size.width, size.height);
    
    _distributeStickView.frame = CGRectMake(CGRectGetMinX(_lblUserName.frame), CGRectGetMaxY(_lblUserName.frame) + 10, Stick_Width, 7);
    _distributeStickView.activePersonModel = self.personRankingModel;
    
}

// 点击跳转TA个人主页
- (void)switchOtherPersonInfo {
    if ([self.delegate respondsToSelector:@selector(clickOtherPerson:)]) {
        [self.delegate clickOtherPerson:self.personRankingModel.userid];
    }
}

// 展开
- (void)onClickView {
    if (self.section >= 0) {
        if ([self.delegate respondsToSelector:@selector(onClickHeadView:)]) {
            [self.delegate onClickHeadView:self.section];
        }
    }
}

@end
