//
//  RYGVipRankTableViewCell.m
//  Vip榜的cell单元格
//
//  Created by jiaocx on 15/8/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGVipRankTableViewCell.h"
#import "RYGVipPersonModel.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGGrandeMarkView.h"
#import "JSBadgeView.h"

#define VipRankTableViewCell_Top_Magin  15
#define VipRankTableViewCell_Left_Magin  10
#define VipRankTableViewCell_Logo_Left_Magin  39
#define VipRankTableViewCell_Name_Left_Magin  5
#define VipRankTableViewCell_Rank_Left_Magin  5
#define VipRankTableViewCell_Right_Magin 15
#define VipRankTableViewCell_Attention_Width 48
#define VipRankTableViewCell_Attention_Top_Magin 20
#define VipRankTableViewCell_Fans_Top_Magin 6
#define VipRankTableViewCell_Recomend_Top_Magin 18
#define VipRankTableViewCell_Recomend_Left_Magin 20

@interface RYGVipRankTableViewCell ()

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
@property(nonatomic,strong)RYGGrandeMarkView *grandMarkView;
// 粉丝
@property(nonatomic,strong)UILabel *lblFans;
// 跟他收米
@property(nonatomic,strong)UIButton *btnBuy;
// 套餐目标胜率
@property(nonatomic,strong)UILabel *lblTargetWinRateTitle;
@property(nonatomic,strong)UILabel *lblTargetWinRate;
@property(nonatomic,strong)UIView *lineView1;
// 套餐期限
@property (nonatomic,strong)UILabel *lblTimeLimitTitle;
@property (nonatomic,strong)UILabel *lblTimeLimit;
@property(nonatomic,strong)UIView *lineView2;
// 平均推荐水位
@property(nonatomic,strong)UILabel *lblAverageLevelTitle;
@property(nonatomic,strong)UILabel *lblAverageLevel;
@property(nonatomic,strong)UIView *lineView3;
// 套餐费用
@property(nonatomic,strong)UILabel *lblCostTitle;
@property(nonatomic,strong)UILabel *lblCost;

// 点击个人区域跳转TA个人主页;
@property(nonatomic,strong)UIControl *otherPersonCtl;

@end

@implementation RYGVipRankTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupCell];
    }
    return self;
}

// 初期化cell
- (void)setupCell {
    self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, VipRankCellHeight);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 奖牌排名
    _weekRankMedalImageView = [[UIImageView alloc]initWithFrame:CGRectMake((39-28) / 2,VipRankTableViewCell_Top_Magin + (32-23)/2 , 28, 23)];
    [self.contentView addSubview:_weekRankMedalImageView];
    
    // 奖牌排名
    _lblWeekRankMedal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), VipRankTableViewCell_Top_Magin, 35, 30)];
    _lblWeekRankMedal.font = [UIFont systemFontOfSize:18];
    _lblWeekRankMedal.textColor = ColorRankMedal;
    _lblWeekRankMedal.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lblWeekRankMedal];
    
    // 头像
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(VipRankTableViewCell_Logo_Left_Magin, VipRankTableViewCell_Top_Magin, 32, 32)];
    _userLogoImageView.layer.cornerRadius = 4;
    _userLogoImageView.layer.masksToBounds = YES;
    _userLogoImageView.backgroundColor = ColorRankMyRankBackground;
    [self.contentView addSubview:_userLogoImageView];
    
    // 新帖字数
    // 添加一个提醒数字按钮
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(VipRankTableViewCell_Logo_Left_Magin, VipRankTableViewCell_Top_Magin, 32, 32)];
    [self.contentView addSubview:control];
    _badgeNew = [[JSBadgeView alloc]initWithParentView:control];
    
    // 用户名
    _lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + VipRankTableViewCell_Name_Left_Magin, VipRankTableViewCell_Top_Magin, self.contentView.width - VipRankTableViewCell_Right_Magin -  VipRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - VipRankTableViewCell_Name_Left_Magin, 13)];
    _lblUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblUserName.font = [UIFont systemFontOfSize:13];
    _lblUserName.textColor = ColorName;
    _lblUserName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblUserName];
    
    // 等级标志
    _grandMarkView = [[RYGGrandeMarkView alloc]init];
    [self.contentView addSubview:_grandMarkView];
    
    // 粉丝
    _lblFans = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblUserName.frame), CGRectGetMaxY(_lblUserName.frame) + VipRankTableViewCell_Fans_Top_Magin, self.contentView.width - VipRankTableViewCell_Right_Magin -  VipRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - VipRankTableViewCell_Name_Left_Magin, 10)];
    _lblFans.font = [UIFont systemFontOfSize:10];
    _lblFans.textColor = ColorRankMedal;
    _lblFans.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblFans];
    
    _otherPersonCtl = [[UIControl alloc]initWithFrame:CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), 0, self.contentView.width - CGRectGetMinX(_lblFans.frame), VipRankCellHeight - 15 - 60)];
    [_otherPersonCtl addTarget:self action:@selector(switchOtherPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_otherPersonCtl];
    
    // 跟他收米
    _btnBuy = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.width - 15 - 64, 20, 64, 23)];
    _btnBuy.backgroundColor = ColorRankMenuBackground;
    _btnBuy.layer.cornerRadius = 2;
    _btnBuy.layer.masksToBounds = YES;
    [_btnBuy setTintColor:ColorRankBackground];
    [_btnBuy setTitle:@"跟TA收米" forState:UIControlStateNormal];
    [_btnBuy.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_btnBuy addTarget:self action:@selector(clickBuyButton) forControlEvents:UIControlEventTouchUpInside];
    [_btnBuy setTitleColor:ColorRankBackground forState:UIControlStateNormal];
    [self.contentView addSubview:_btnBuy];
    
    
    // 套餐目标胜率
    CGSize titleSize = RYG_TEXTSIZE(@"套餐目标胜率", [UIFont systemFontOfSize:10]);
    CGFloat total = 72 * 3 + 3 + titleSize.width + 5;
    _lblTargetWinRateTitle = [[UILabel alloc]initWithFrame:CGRectMake((self.contentView.width - total) / 2, CGRectGetMaxY(_userLogoImageView.frame) + 15, titleSize.width, titleSize.height)];
    _lblTargetWinRateTitle.textColor = ColorSecondTitle;
    _lblTargetWinRateTitle.font = [UIFont systemFontOfSize:10];
    _lblTargetWinRateTitle.text = @"套餐目标胜率";
    [self.contentView addSubview:_lblTargetWinRateTitle];
    
    CGSize size = RYG_TEXTSIZE(@"70%", [UIFont systemFontOfSize:14]);
    _lblTargetWinRate = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblTargetWinRateTitle.frame), CGRectGetMaxY(_lblTargetWinRateTitle.frame) + 6, _lblTargetWinRateTitle.width, size.height)];
    _lblTargetWinRate.textColor = ColorRateTitle;
    _lblTargetWinRate.font = [UIFont systemFontOfSize:14];
    _lblTargetWinRate.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lblTargetWinRate];
    
    _lineView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblTargetWinRateTitle.frame) + 5, VipRankCellHeight - 32 - 12, SeparatorLineHeight, 32)];
    _lineView1.backgroundColor = ColorLine;
    [self.contentView addSubview:_lineView1];
    
    // 套餐期限
    _lblTimeLimitTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lineView1.frame), CGRectGetMinY(_lblTargetWinRateTitle.frame), 72, titleSize.height)];
    _lblTimeLimitTitle.textColor = ColorSecondTitle;
    _lblTimeLimitTitle.font = [UIFont systemFontOfSize:10];
    _lblTimeLimitTitle.textAlignment = NSTextAlignmentCenter;
    _lblTimeLimitTitle.text = @"套餐期限";
    [self.contentView addSubview:_lblTimeLimitTitle];
    
    _lblTimeLimit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblTimeLimitTitle.frame), CGRectGetMinY(_lblTargetWinRate.frame), _lblTimeLimitTitle.width, size.height)];
    _lblTimeLimit.textColor = ColorSecondTitle;
    _lblTimeLimit.font = [UIFont systemFontOfSize:14];
    _lblTimeLimit.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lblTimeLimit];
    
    _lineView2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblTimeLimit.frame), VipRankCellHeight - 32 - 12, SeparatorLineHeight, 32)];
    _lineView2.backgroundColor = ColorLine;
    [self.contentView addSubview:_lineView2];

    // 平均推荐水位
    _lblAverageLevelTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lineView2.frame), CGRectGetMinY(_lblTargetWinRateTitle.frame), 72, titleSize.height)];
    _lblAverageLevelTitle.textColor = ColorName;
    _lblAverageLevelTitle.font = [UIFont systemFontOfSize:10];
    _lblAverageLevelTitle.textAlignment = NSTextAlignmentCenter;
    _lblAverageLevelTitle.text = @"平均水位";
    [self.contentView addSubview:_lblAverageLevelTitle];
    
    _lblAverageLevel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblAverageLevelTitle.frame), CGRectGetMinY(_lblTargetWinRate.frame), _lblTimeLimitTitle.width, size.height)];
    _lblAverageLevel.textColor = ColorRateTitle;
    _lblAverageLevel.font = [UIFont systemFontOfSize:14];
    _lblAverageLevel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lblAverageLevel];
    
    _lineView3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblAverageLevel.frame), VipRankCellHeight - 32 - 12, SeparatorLineHeight, 32)];
    _lineView3.backgroundColor = ColorLine;
    [self.contentView addSubview:_lineView3];

    // 套餐费用
    _lblCostTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lineView3.frame), CGRectGetMinY(_lblTargetWinRateTitle.frame), 72, titleSize.height)];
    _lblCostTitle.textColor = ColorSecondTitle;
    _lblCostTitle.font = [UIFont systemFontOfSize:10];
    _lblCostTitle.textAlignment = NSTextAlignmentCenter;
    _lblCostTitle.text = @"套餐费用";
    [self.contentView addSubview:_lblCostTitle];
    
    _lblCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblCostTitle.frame), CGRectGetMinY(_lblTargetWinRate.frame), _lblCostTitle.width, size.height)];
    _lblCost.textColor = ColorName;
    _lblCost.font = [UIFont systemFontOfSize:14];
    _lblCost.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lblCost];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, VipRankCellHeight - SeparatorLineHeight, self.contentView.width, SeparatorLineHeight)];
    lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:lineView];
}

// 根据数据重新设置cell单元格
- (void)setPersonRankingModel:(RYGVipPersonModel *)personRankingModel {
    _personRankingModel = personRankingModel;
    [self updateCell];
}

- (void)updateCell {
    // 奖牌排名
    if ([self.personRankingModel.ranking isEqualToString:@"1"] || [self.personRankingModel.ranking isEqualToString:@"2"] || [self.personRankingModel.ranking isEqualToString:@"3"]) {
        _weekRankMedalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"vip_rank_ medal%@",self.personRankingModel.ranking]];
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
        _lblWeekRankMedal.frame = CGRectMake(CGRectGetMinX(_weekRankMedalImageView.frame), VipRankTableViewCell_Top_Magin, width, 30);
    }
    
    // 头像
    [_userLogoImageView setImageURLStr:self.personRankingModel.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
    // 用户名
    _lblUserName.text = self.personRankingModel.user_name;
    // 用户名
    CGSize userNameSize = RYG_TEXTSIZE(_lblUserName.text, [UIFont systemFontOfSize:13]);
    CGFloat userNameWidth = MIN(userNameSize.width, self.contentView.width - VipRankTableViewCell_Right_Magin -  VipRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - VipRankTableViewCell_Name_Left_Magin);
    _lblUserName.frame = CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + VipRankTableViewCell_Name_Left_Magin, VipRankTableViewCell_Top_Magin,userNameWidth, userNameSize.height);
    // 等级标志
    _grandMarkView.frame = CGRectMake(CGRectGetMaxX(_lblUserName.frame), CGRectGetMinY(_lblUserName.frame), self.contentView.width - CGRectGetMaxX(_lblUserName.frame) - VipRankTableViewCell_Attention_Width - 15 - 3, 15);
    _grandMarkView.integralRank = self.personRankingModel.grade;
    // 粉丝
    if (self.personRankingModel.funs_num) {
        _lblFans.text = [NSString stringWithFormat:@"粉丝 %@人",self.personRankingModel.funs_num];
    }
    else {
        _lblFans.text = @"粉丝 0人";
    }
    // 套餐目标胜率
    self.lblTargetWinRate.text = [NSString stringWithFormat:@"%@%%",self.personRankingModel.target_win_rate];
    // 套餐期限
    self.lblTimeLimit.text = [NSString stringWithFormat:@"%@天",self.personRankingModel.package_period];
    // 平均推荐水位
    self.lblAverageLevel.text = [NSString stringWithFormat:@"%0.2f",[self.personRankingModel.water_level floatValue]];
    // 套餐费用
    self.lblCost.text = [NSString stringWithFormat:@"%@元",self.personRankingModel.package_coast];
    
}

// 点击跳转TA个人主页
- (void)switchOtherPersonInfo {
    if ([self.delegate respondsToSelector:@selector(clickOtherPerson:)]) {
        [self.delegate clickOtherPerson:self.personRankingModel.userid];
    }
}

// 点击跟TA收米,直接跳转购买
- (void)clickBuyButton {
    // 是否登录
    if (![RYGUtility isLogin])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNSNotification object:nil];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(switchBuy:)]) {
        [self.delegate switchBuy:self.personRankingModel.userid];
    }
}


@end
