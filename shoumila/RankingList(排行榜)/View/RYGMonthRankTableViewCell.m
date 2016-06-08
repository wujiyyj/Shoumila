//
//  RYGMonthRankTableViewCell.m
//  月度榜的cell单元格
//
//  Created by jiaocx on 15/8/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMonthRankTableViewCell.h"
#import "RYGPieChartView.h"
#import "RYGMonthRecntModel.h"
#import "RYGMonthPersonModel.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGGrandeMarkView.h"
#import "AFCircleChart.h"
#import "RYGWeekRecommendView.h"
#import "JSBadgeView.h"
#import "RYGRecentRecomendView.h"
#import "RYGRecentView.h"
#import "RYGMonthRecntModel.h"

#define MonthRankTableViewCell_Top_Magin  15
#define MonthRankTableViewCell_Left_Magin  10
#define MonthRankTableViewCell_Logo_Left_Magin  39
#define MonthRankTableViewCell_Name_Left_Magin  5
#define MonthRankTableViewCell_Rank_Left_Magin  5
#define MonthRankTableViewCell_Right_Magin 15
#define MonthRankTableViewCell_Attention_Width 48
#define MonthRankTableViewCell_Attention_Top_Magin 20
#define MonthRankTableViewCell_Fans_Top_Magin 6
#define MonthRankTableViewCell_Recomend_Top_Magin 14
#define MonthRankTableViewCell_Recomend_Left_Magin 20

@interface RYGMonthRankTableViewCell ()
// 奖牌排名
@property(nonatomic,strong)UIImageView *weekRankMedalImageView;
// 奖牌排名
@property(nonatomic,strong)UILabel *lblWeekRankMedal;
// 头像
@property(nonatomic,strong)UIImageView *userLogoImageView;
// 新帖字数
@property(nonatomic,strong)JSBadgeView *badgeNew;
// 用户名
@property(nonatomic,strong)UILabel *lblUserName;
// 等级标志
@property(nonatomic,strong)UILabel *grandMarkView;
// 粉丝
@property(nonatomic,strong)UILabel *lblFans;
// 关注
@property(nonatomic,strong)UIControl *attentionCtrl;
@property(nonatomic,strong)UIImageView *attentionImageView;
// 胜率
@property (nonatomic,strong) AFCircleChart *winRateCircleChart;
// 利润率
@property (nonatomic,strong) AFCircleChart *profitRateCircleChart;
// 推荐胜／周推荐
@property(nonatomic,strong)UILabel *lblRecommendWinTitle;
@property(nonatomic,strong)RYGWeekRecommendView *weekRecommendView;
// 平均推荐水位
@property(nonatomic,strong)UILabel *lblAverageLevelTitle;
@property(nonatomic,strong)UILabel *lblAverageLevel;
// 近10场推荐情况
@property(nonatomic,strong)RYGPieChartView *pieChartView;

// 点击个人区域跳转TA个人主页;
@property(nonatomic,strong)UIControl *otherPersonCtl;

@end

@implementation RYGMonthRankTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupCell];
    }
    
    return self;
}

- (void)setupCell {
    
    self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, MonthRankCellHeight);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 奖牌排名
    _weekRankMedalImageView = [[UIImageView alloc]initWithFrame:CGRectMake((39-28) / 2,MonthRankTableViewCell_Top_Magin + (32-26)/2 , 28, 26)];
    [self.contentView addSubview:_weekRankMedalImageView];
    
    // 奖牌排名
    _lblWeekRankMedal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), MonthRankTableViewCell_Top_Magin, 35, 30)];
    _lblWeekRankMedal.font = [UIFont systemFontOfSize:18];
    _lblWeekRankMedal.textColor = ColorRankMedal;
    _lblWeekRankMedal.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lblWeekRankMedal];
    
    // 头像
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MonthRankTableViewCell_Logo_Left_Magin, MonthRankTableViewCell_Top_Magin, 32, 32)];
    _userLogoImageView.layer.cornerRadius = 4;
    _userLogoImageView.layer.masksToBounds = YES;
    _userLogoImageView.backgroundColor = ColorRankMyRankBackground;
    [self.contentView addSubview:_userLogoImageView];
    
    // 新帖字数
    // 添加一个提醒数字按钮
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(MonthRankTableViewCell_Logo_Left_Magin, MonthRankTableViewCell_Top_Magin, 32, 32)];
    [self.contentView addSubview:control];
    _badgeNew = [[JSBadgeView alloc]initWithParentView:control];
    
    // 用户名
    _lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + MonthRankTableViewCell_Name_Left_Magin, MonthRankTableViewCell_Top_Magin, self.contentView.width - MonthRankTableViewCell_Right_Magin -  MonthRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - MonthRankTableViewCell_Name_Left_Magin, 13)];
    _lblUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblUserName.font = [UIFont systemFontOfSize:13];
    _lblUserName.textColor = ColorName;
    _lblUserName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblUserName];
    
    // 等级标志
    _grandMarkView = [[UILabel alloc]init];
    _grandMarkView.textColor = ColorYeallow;
    _grandMarkView.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_grandMarkView];
    
    // 粉丝
    _lblFans = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblUserName.frame), CGRectGetMaxY(_lblUserName.frame) + MonthRankTableViewCell_Fans_Top_Magin, self.contentView.width - MonthRankTableViewCell_Right_Magin -  MonthRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - MonthRankTableViewCell_Name_Left_Magin, 10)];
    _lblFans.font = [UIFont systemFontOfSize:10];
    _lblFans.textColor = ColorRankMedal;
    _lblFans.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblFans];
    
    _otherPersonCtl = [[UIControl alloc]initWithFrame:CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), 0, self.width - CGRectGetMinX(_lblFans.frame), MonthRankCellHeight - 15 - 60)];
    [_otherPersonCtl addTarget:self action:@selector(switchOtherPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_otherPersonCtl];
    
    // 关注
    _attentionCtrl = [[UIControl alloc]initWithFrame:CGRectMake(self.contentView.width - MonthRankTableViewCell_Right_Magin - MonthRankTableViewCell_Attention_Width, MonthRankTableViewCell_Attention_Top_Magin, MonthRankTableViewCell_Attention_Width, 23)];
    [_attentionCtrl addTarget:self action:@selector(clickAttentionBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_attentionCtrl];
    
    _attentionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MonthRankTableViewCell_Attention_Width, 23)];
    _attentionImageView.image  = [UIImage imageNamed:@"un_attention"];
    [_attentionCtrl addSubview:_attentionImageView];
    
    // 胜率
    _winRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(20,MonthRankCellHeight - 15 - 60, 60, 60)];
    [_winRateCircleChart setLineWidth:6  inLineWidth:4 atValue:50 totalValue:100 chartColor:[UIColor redColor]
                    descriptionString:@"胜率"];
    _winRateCircleChart.valuesFontSize = 15;
    _winRateCircleChart.descriptionFontSize = 10;
    [_winRateCircleChart animatePath];
    [self.contentView addSubview:self.winRateCircleChart];
    
    // 利润率
    _profitRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_winRateCircleChart.frame) + 15,CGRectGetMinY(_winRateCircleChart.frame), 60, 60)];
    [_profitRateCircleChart setLineWidth:6 inLineWidth:4 atValue:50 totalValue:100 chartColor:[UIColor redColor]
                       descriptionString:@"利润率"];
    _profitRateCircleChart.valuesFontSize = 15;
    _profitRateCircleChart.descriptionFontSize = 10;
    [_profitRateCircleChart animatePath];
    [self.contentView addSubview:self.profitRateCircleChart];
    
    // 平均推荐水位
    CGSize averageLevelTitleSize = RYG_TEXTSIZE(@"平均推荐水位", [UIFont systemFontOfSize:9]);
    _lblAverageLevelTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.width - MonthRankTableViewCell_Right_Magin - averageLevelTitleSize.width, CGRectGetMaxY(_attentionCtrl.frame) + MonthRankTableViewCell_Recomend_Top_Magin, averageLevelTitleSize.width, averageLevelTitleSize.height)];
    _lblAverageLevelTitle.font = [UIFont systemFontOfSize:9];
    _lblAverageLevelTitle.textColor = ColorSecondTitle;
    _lblAverageLevelTitle.textAlignment = NSTextAlignmentRight;
    _lblAverageLevelTitle.text = @"平均推荐水位";
    [self.contentView addSubview:_lblAverageLevelTitle];
    
    CGSize lblAverageLevelSize = RYG_TEXTSIZE(@"28", [UIFont systemFontOfSize:12]);
    _lblAverageLevel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblAverageLevelTitle.frame), CGRectGetMaxY(_lblAverageLevelTitle.frame) + 4, _lblAverageLevelTitle.width,lblAverageLevelSize.height)];
    _lblAverageLevel.font = [UIFont systemFontOfSize:12];
    _lblAverageLevel.textColor = ColorRateTitle;
    _lblAverageLevel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lblAverageLevel];
    
    // 推荐胜／周推荐
    CGSize recommendWinTitleSize = RYG_TEXTSIZE(@"推荐胜/月推荐", [UIFont systemFontOfSize:9]);
    _lblRecommendWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblAverageLevelTitle.frame) - recommendWinTitleSize.width - 28,CGRectGetMaxY(_attentionCtrl.frame) + MonthRankTableViewCell_Recomend_Top_Magin, recommendWinTitleSize.width + 28, recommendWinTitleSize.height)];
    _lblRecommendWinTitle.font = [UIFont systemFontOfSize:9];
    _lblRecommendWinTitle.textColor = ColorSecondTitle;
    _lblRecommendWinTitle.textAlignment = NSTextAlignmentCenter;
    _lblRecommendWinTitle.text = @"推荐胜/月推荐";

    [self.contentView addSubview:_lblRecommendWinTitle];
    
    CGSize weekRecommendViewSize = RYG_TEXTSIZE(@"28", [UIFont systemFontOfSize:12]);
    //
    _weekRecommendView = [[RYGWeekRecommendView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblRecommendWinTitle.frame), CGRectGetMinY(_lblAverageLevel.frame), _lblRecommendWinTitle.width, weekRecommendViewSize.height) smallFontSize:9 largeFontSize:12 recommendWinGamesColor:ColorRateTitle recommendGamesFontColor:ColorName];
    
    [self.contentView addSubview:_weekRecommendView];
    
    _pieChartView = [[RYGPieChartView alloc]initWithFrame:CGRectMake(self.contentView.width - 15 - 139, CGRectGetMaxY(_weekRecommendView.frame) + 7, 139, 32)];
    [self.contentView addSubview:_pieChartView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, MonthRankCellHeight - SeparatorLineHeight, self.contentView.width, SeparatorLineHeight)];
    lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:lineView];
}

- (NSArray *)getMonthRecntModels {
    NSMutableArray *linesData = [[NSMutableArray alloc]init];
    return linesData;
}

- (void)setPersonRankingModel:(RYGMonthPersonModel *)personRankingModel {
    _personRankingModel = personRankingModel;
    [self updateCell];
}

- (void)updateCell {
    // 奖牌排名
    if ([self.personRankingModel.ranking isEqualToString:@"1"] || [self.personRankingModel.ranking isEqualToString:@"2"] || [self.personRankingModel.ranking isEqualToString:@"3"]) {
        _weekRankMedalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"month_rank_ medal%@",self.personRankingModel.ranking]];
        _weekRankMedalImageView.hidden = NO;
        _lblWeekRankMedal.hidden = YES;
    }
    else {
        _weekRankMedalImageView.hidden = YES;
        _lblWeekRankMedal.hidden = NO;
        _lblWeekRankMedal.text = self.personRankingModel.ranking;
        CGSize rankSize = RYG_TEXTSIZE(self.personRankingModel.ranking, [UIFont systemFontOfSize:18]);
        CGFloat width = 34;
        if (rankSize.width > width) {
            width = rankSize.width;
        }
        _lblWeekRankMedal.frame = CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), MonthRankTableViewCell_Top_Magin, width, 30);
    }
    
    // 头像
    [_userLogoImageView setImageURLStr:self.personRankingModel.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
    _badgeNew.badgeText = self.personRankingModel.not_beginning_num;
    ;
    // 用户名
    _lblUserName.text = self.personRankingModel.user_name;
    // 用户名
    CGSize userNameSize = RYG_TEXTSIZE(_lblUserName.text, [UIFont systemFontOfSize:13]);
    CGFloat userNameWidth = MIN(userNameSize.width, self.contentView.width - MonthRankTableViewCell_Right_Magin -  MonthRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - MonthRankTableViewCell_Name_Left_Magin);
    _lblUserName.frame = CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + MonthRankTableViewCell_Name_Left_Magin, MonthRankTableViewCell_Top_Magin,userNameWidth, userNameSize.height);
    // 等级标志
    _grandMarkView.frame = CGRectMake(CGRectGetMaxX(_lblUserName.frame)+5, CGRectGetMinY(_lblUserName.frame), self.contentView.width - CGRectGetMaxX(_lblUserName.frame) - MonthRankTableViewCell_Attention_Width - 15 - 3, 15);
    _grandMarkView.text = [NSString stringWithFormat:@"Lv.%@", self.personRankingModel.grade];
    // 关注
    [self updateAttentionStatus:self.personRankingModel.is_attention];
    RYGUserInfoModel *userInfoModel = [RYGUtility getUserInfo];
    if ([self.personRankingModel.userid isEqualToString:userInfoModel.userid]) {
        _attentionCtrl.hidden = YES;
    }
    else {
        _attentionCtrl.hidden = NO;
    }

    // 粉丝
    // 粉丝
    if (self.personRankingModel.funs_num) {
        _lblFans.text = [NSString stringWithFormat:@"粉丝 %@人",self.personRankingModel.funs_num];
    }
    else {
        _lblFans.text = @"粉丝 0人";
    }
    // 胜率
    [self.winRateCircleChart reAnimateChartAtValue:[self.personRankingModel.win_rate integerValue] totalValue:100];
    // 利润率
    [self.profitRateCircleChart reAnimateChartAtValue:[self.personRankingModel.profit_margin integerValue] totalValue:100];
    // 推荐胜/周推荐
    NSString *strWin;
    NSString *strRecommend;
    if (self.personRankingModel.win_count) {
        strWin = self.personRankingModel.win_count;
    }
    else {
        strWin = @"--";
    }
    if (self.personRankingModel.recommend_count) {
        strRecommend = self.personRankingModel.recommend_count;
    }
    else {
        strRecommend = @"--";
    }
    [_weekRecommendView setRecommendWinGames:strWin recommendGames:strRecommend];    // 平均推荐水位
    if (self.personRankingModel.water_level) {
        _lblAverageLevel.text = [NSString stringWithFormat:@"%0.2f",[self.personRankingModel.water_level floatValue]];
    }
    else {
        _lblAverageLevel.text = @"--";
    }
    
    NSMutableArray *models = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.personRankingModel.recent.count; i++) {
        RYGMonthRecntModel *model = [RYGMonthRecntModel objectWithKeyValues:[self.personRankingModel.recent objectAtIndex:i]];
        [models addObject:model];
    }
    _pieChartView.linesData = models;
    
}

// 点击跳转TA个人主页
- (void)switchOtherPersonInfo {
    if ([self.delegate respondsToSelector:@selector(clickOtherPerson:)]) {
        [self.delegate clickOtherPerson:self.personRankingModel.userid];
    }
}

// 点击关注:关注此人到我的关注下
- (void)clickAttentionBtn {
    // 是否登录
    if (![RYGUtility isLogin])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNSNotification object:nil];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(clickAttentionButton:op:index:)]) {
        if ([self.personRankingModel.is_attention isEqualToString:@"2"]) {
            [self.delegate clickAttentionButton:self.personRankingModel.userid op:@"0" index:self.cellIndex];
        }
        else {
            [self.delegate clickAttentionButton:self.personRankingModel.userid op:@"1" index:self.cellIndex];
        }
        self.attentionCtrl.userInteractionEnabled = NO;
    }
}

- (void)updateAttentionStatus:(NSString *)isAttention {
    self.attentionCtrl.userInteractionEnabled = YES;
    // 1:关注 2:未关注
    if ([isAttention isEqualToString:@"2"]) {
        _attentionImageView.image = [UIImage imageNamed:@"un_attention"];
    }
    else {
        _attentionImageView.image = [UIImage imageNamed:@"attentioned"];
        
    }
}
@end
