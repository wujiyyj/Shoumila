//
//  RYGSubscribeTableViewCell.m
//  shoumila
//
//  Created by yinyujie on 15/8/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSubscribeTableViewCell.h"
#import "JSBadgeView.h"
#import "UIImageView+RYGWebCache.h"

#define WeekRankTableViewCell_Top_Magin  15
#define WeekRankTableViewCell_Left_Magin  10
#define WeekRankTableViewCell_Logo_Left_Magin  39
#define WeekRankTableViewCell_Name_Left_Magin  10
#define WeekRankTableViewCell_Rank_Left_Magin  5
#define WeekRankTableViewCell_Right_Magin 15
#define WeekRankTableViewCell_Attention_Width 60
#define WeekRankTableViewCell_Attention_Top_Magin 20
#define WeekRankTableViewCell_Fans_Top_Magin 10
#define WeekRankTableViewCell_Recomend_Top_Magin 18
#define WeekRankTableViewCell_Recomend_Left_Magin 20
#define WeekRankCellHeight 62

@interface RYGSubscribeTableViewCell ()

// 头像
@property(nonatomic,strong)UIImageView *userLogoImageView;
// 新帖字数
@property(nonatomic,strong)JSBadgeView *badgeNew;
// 用户名
@property(nonatomic,strong)UILabel *lblUserName;
// 粉丝
@property(nonatomic,strong)UILabel *lblFans;
// 关注
@property(nonatomic,strong)UIButton *cancelAttentionCtrl;
@property(nonatomic,strong)UIImageView *attentionImageView;
// 点击个人区域跳转TA个人主页;
@property(nonatomic,strong)UIControl *otherPersonCtl;

@end

@implementation RYGSubscribeTableViewCell

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
    self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, 62);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 61.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:lineView];
    
    // 头像
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, WeekRankTableViewCell_Top_Magin, 32, 32)];
    _userLogoImageView.layer.cornerRadius = 4;
    _userLogoImageView.layer.masksToBounds = YES;
    _userLogoImageView.backgroundColor = ColorRankMyRankBackground;
    _userLogoImageView.userInteractionEnabled = YES;
    // 头像
//    _userLogoImageView.image = [UIImage imageNamed:@"user_data"];
//    [_userLogoImageView setImageURLStr:@"" placeholder:nil];
    [self.contentView addSubview:_userLogoImageView];
    
    // 新帖字数
    // 添加一个提醒数字按钮
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(15, WeekRankTableViewCell_Top_Magin, 32, 32)];
    if ([RYGUtility getCurrentVC]) {
        [self.contentView addSubview:control];
    }
    _badgeNew = [[JSBadgeView alloc]initWithParentView:control];
    _badgeNew.badgeText = @"20";
    
    // 用户名
    _lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + WeekRankTableViewCell_Name_Left_Magin, WeekRankTableViewCell_Top_Magin, self.contentView.width - WeekRankTableViewCell_Right_Magin -  WeekRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - WeekRankTableViewCell_Name_Left_Magin, 13)];
    // 用户名
//    _lblUserName.text = @"阿克力";
    _lblUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblUserName.font = [UIFont boldSystemFontOfSize:13];
    _lblUserName.textColor = ColorName;
    _lblUserName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblUserName];
    
    // 粉丝
    _lblFans = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblUserName.frame), CGRectGetMaxY(_lblUserName.frame) + WeekRankTableViewCell_Fans_Top_Magin, self.contentView.width - WeekRankTableViewCell_Right_Magin -  WeekRankTableViewCell_Attention_Width - CGRectGetMaxX(_userLogoImageView.frame) - WeekRankTableViewCell_Name_Left_Magin, 10)];
    // 粉丝
//    _lblFans.text = [NSString stringWithFormat:@"%d粉丝 ｜ %d动态",118,35];
    _lblFans.font = [UIFont boldSystemFontOfSize:10];
    _lblFans.textColor = ColorRankMedal;
    _lblFans.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblFans];
    
    _otherPersonCtl = [[UIControl alloc]initWithFrame:CGRectMake(10, 4, 100, 54)];
    [_otherPersonCtl addTarget:self action:@selector(switchOtherPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_otherPersonCtl];
    
    // 取消关注
    _cancelAttentionCtrl = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelAttentionCtrl.frame = CGRectMake(self.contentView.width - WeekRankTableViewCell_Right_Magin - WeekRankTableViewCell_Attention_Width, WeekRankTableViewCell_Attention_Top_Magin, WeekRankTableViewCell_Attention_Width, 23);
    [_cancelAttentionCtrl setBackgroundImage:[UIImage imageNamed:@"user_cancel_attention"] forState:UIControlStateNormal];
    [_cancelAttentionCtrl addTarget:self action:@selector(clickCancelAttentionButton) forControlEvents:UIControlEventTouchUpInside];

    if ([RYGUtility getCurrentVC]) {
        [self.contentView addSubview:_cancelAttentionCtrl];
    }
}

// 根据数据重新设置cell单元格
- (void)setAttentionPersonModel:(RYGAttentionPersonModel *)attentionPersonModel {
    _attentionPersonModel = attentionPersonModel;
    [self updateCell];
}

- (void)updateCell {
    
    [_userLogoImageView setImageURLStr:self.attentionPersonModel.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
    _badgeNew.badgeText = self.attentionPersonModel.not_beginning_num;
    _lblUserName.text = self.attentionPersonModel.user_name;
    _lblFans.text = [NSString stringWithFormat:@"%d粉丝 ｜ %d动态",self.attentionPersonModel.funs_num.intValue,self.attentionPersonModel.publish_num.intValue];
    
}

// 点击跳转TA个人主页
- (void)switchOtherPersonInfo {
    if ([self.delegate respondsToSelector:@selector(clickOtherPerson:)]) {
        [self.delegate clickOtherPerson:self.attentionPersonModel.userid];
    }
}

// 点击取消关注
- (void)clickCancelAttentionButton {
    if ([self.delegate respondsToSelector:@selector(clickCancelAttentionButton:)]) {
        [self.delegate clickCancelAttentionButton:self.attentionPersonModel.userid];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
