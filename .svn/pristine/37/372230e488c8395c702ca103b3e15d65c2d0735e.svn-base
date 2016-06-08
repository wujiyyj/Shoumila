//
//  RYGBlackListTableViewCell.m
//  shoumila
//
//  Created by 阴～ on 15/9/1.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBlackListTableViewCell.h"
#import "UIImageView+RYGWebCache.h"

@interface RYGBlackListTableViewCell ()

// 头像
@property(nonatomic,strong)UIImageView *userLogoImageView;
// 用户名
@property(nonatomic,strong)UILabel *lblUserName;
// 取消屏蔽
@property(nonatomic,strong)UIButton *cancelShieldCtrl;
@property(nonatomic,strong)UIImageView *cancelShieldImageView;
// 点击个人区域跳转TA个人主页;
@property(nonatomic,strong)UIControl *otherPersonCtl;

@end

@implementation RYGBlackListTableViewCell

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
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 32, 32)];
    _userLogoImageView.layer.cornerRadius = 4;
    _userLogoImageView.layer.masksToBounds = YES;
    _userLogoImageView.backgroundColor = ColorRankMyRankBackground;
    // 头像
//    _userLogoImageView.image = [UIImage imageNamed:@"user_data"];
    //    [_userLogoImageView setImageURLStr:@"" placeholder:nil];
    [self.contentView addSubview:_userLogoImageView];
    
    // 用户名
    _lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + 10, 20, 100, 22)];
    // 用户名
//    _lblUserName.text = @"阿克力";
    _lblUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblUserName.font = [UIFont boldSystemFontOfSize:13];
    _lblUserName.textColor = ColorName;
    _lblUserName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblUserName];
    
    _otherPersonCtl = [[UIControl alloc]initWithFrame:CGRectMake(10, 4, 100, 54)];
    [_otherPersonCtl addTarget:self action:@selector(switchOtherPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_otherPersonCtl];
    
    // 取消屏蔽
    _cancelShieldCtrl = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelShieldCtrl.frame = CGRectMake(self.contentView.width - 15 - 60, 20, 60, 23);
    [_cancelShieldCtrl setBackgroundImage:[UIImage imageNamed:@"user_cancel_shield"] forState:UIControlStateNormal];
    [_cancelShieldCtrl addTarget:self action:@selector(clickattentionButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cancelShieldCtrl];
}

// 根据数据重新设置cell单元格
- (void)setBlackPersonModel:(RYGBlackPersonModel *)blackPersonModel {
    _blackPersonModel = blackPersonModel;
    [self updateCell];
}

- (void)updateCell {
    [_userLogoImageView setImageURLStr:self.blackPersonModel.user_logo placeholder:nil];
    _lblUserName.text = self.blackPersonModel.user_name;
}

// 点击跳转TA个人主页
- (void)switchOtherPersonInfo {
    if ([self.delegate respondsToSelector:@selector(clickOtherPerson:)]) {
        [self.delegate clickOtherPerson:self.blackPersonModel.userid];
    }
}

// 取消屏蔽
- (void)clickattentionButton {
    if ([self.delegate respondsToSelector:@selector(clickcancelShieldButton:)]) {
        [self.delegate clickcancelShieldButton:self.blackPersonModel.userid];
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
