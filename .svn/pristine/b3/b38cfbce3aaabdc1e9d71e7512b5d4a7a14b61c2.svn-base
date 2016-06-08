//
//  RYGActiveRankTableViewCell.m
//  活跃榜的cell单元格
//
//  Created by jiaocx on 15/8/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGActiveRankTableViewCell.h"
#import "RYGActivePersonModel.h"
#import "RYGGrandeMarkView.h"

#define ActiveRankTableViewCell_Left_Magin  39
#define ActiveRankTableViewCell_Magin  24
#define ActiveRankTableViewCell_Top_Magin 7
#define ActiveRankTableViewCell_Icon_Width 10
#define ActiveRankTableViewCell_Num_Width 80


@interface RYGActiveRankTableViewCell ()

// 发帖数
@property(nonatomic,strong)UIImageView *publishNumImageView;
@property(nonatomic,strong)UILabel *lblPublishNum;
// 回复数
@property(nonatomic,strong)UIImageView *commentNumImageView;
@property(nonatomic,strong)UILabel *lblCommentNum;
// 转发数
@property(nonatomic,strong)UIImageView *shareNumImageView;
@property(nonatomic,strong)UILabel *lblShareNum;
// 点赞数
@property(nonatomic,strong)UIImageView *praiseNumImageView;
@property(nonatomic,strong)UILabel *lblPraiseNum;
// 活跃天数
@property(nonatomic,strong)UIImageView *activeNumImageView;
@property(nonatomic,strong)UILabel *lblActiveNum;
// 邀请数
@property(nonatomic,strong)UIImageView *inviteNumImageView;
@property(nonatomic,strong)UILabel *lblInviteNum;

@end


@implementation RYGActiveRankTableViewCell

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
    self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, ActiveRankCellHeight);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 发帖数
   _publishNumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ActiveRankTableViewCell_Left_Magin, 0, ActiveRankTableViewCell_Icon_Width, ActiveRankTableViewCell_Icon_Width)];
    _publishNumImageView.image = [UIImage imageNamed:@"publish_num"];
    [self.contentView addSubview:_publishNumImageView];
    
    _lblPublishNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_publishNumImageView.frame), CGRectGetMinY(_publishNumImageView.frame), ActiveRankTableViewCell_Num_Width, ActiveRankTableViewCell_Icon_Width)];
    _lblPublishNum.textColor = ColorSecondTitle;
    _lblPublishNum.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblPublishNum];
    // 回复数
    _commentNumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblPublishNum.frame), CGRectGetMinY(_lblPublishNum.frame), ActiveRankTableViewCell_Icon_Width, ActiveRankTableViewCell_Icon_Width)];
    _commentNumImageView.image = [UIImage imageNamed:@"comment_num"];
    [self.contentView addSubview:_commentNumImageView];
    
    _lblCommentNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_commentNumImageView.frame), CGRectGetMinY(_commentNumImageView.frame), ActiveRankTableViewCell_Num_Width, ActiveRankTableViewCell_Icon_Width)];
    _lblCommentNum.textColor = ColorSecondTitle;
    _lblCommentNum.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblCommentNum];

    // 转发数
    _shareNumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblCommentNum.frame), CGRectGetMinY(_lblCommentNum.frame), ActiveRankTableViewCell_Icon_Width, ActiveRankTableViewCell_Icon_Width)];
    _shareNumImageView.image = [UIImage imageNamed:@"share_num"];
    [self.contentView addSubview:_shareNumImageView];
    
    _lblShareNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shareNumImageView.frame), CGRectGetMinY(_shareNumImageView.frame), ActiveRankTableViewCell_Num_Width, ActiveRankTableViewCell_Icon_Width)];
    _lblShareNum.textColor = ColorSecondTitle;
    _lblShareNum.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblShareNum];

    // 点赞数
    _praiseNumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ActiveRankTableViewCell_Left_Magin, CGRectGetMaxY(_lblPublishNum.frame) + ActiveRankTableViewCell_Top_Magin, ActiveRankTableViewCell_Icon_Width, ActiveRankTableViewCell_Icon_Width)];
    _praiseNumImageView.image = [UIImage imageNamed:@"praise_num"];
    [self.contentView addSubview:_praiseNumImageView];
    
    _lblPraiseNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_praiseNumImageView.frame), CGRectGetMinY(_praiseNumImageView.frame), ActiveRankTableViewCell_Num_Width, ActiveRankTableViewCell_Icon_Width)];
    _lblPraiseNum.textColor = ColorSecondTitle;
    _lblPraiseNum.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblPraiseNum];

    // 活跃天数
    _activeNumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblPraiseNum.frame), CGRectGetMinY(_praiseNumImageView.frame), ActiveRankTableViewCell_Icon_Width, ActiveRankTableViewCell_Icon_Width)];
    _activeNumImageView.image = [UIImage imageNamed:@"active_num"];
    [self.contentView addSubview:_activeNumImageView];
    
    _lblActiveNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_activeNumImageView.frame), CGRectGetMinY(_activeNumImageView.frame), ActiveRankTableViewCell_Num_Width, ActiveRankTableViewCell_Icon_Width)];
    _lblActiveNum.textColor = ColorSecondTitle;
    _lblActiveNum.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblActiveNum];
    
    // 邀请数
    _inviteNumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblActiveNum.frame), CGRectGetMinY(_praiseNumImageView.frame), ActiveRankTableViewCell_Icon_Width, ActiveRankTableViewCell_Icon_Width)];
    _inviteNumImageView.image = [UIImage imageNamed:@"invite_num"];
    [self.contentView addSubview:_inviteNumImageView];
    
    _lblInviteNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_inviteNumImageView.frame), CGRectGetMinY(_inviteNumImageView.frame), ActiveRankTableViewCell_Num_Width, ActiveRankTableViewCell_Icon_Width)];
    _lblInviteNum.textColor = ColorSecondTitle;
    _lblInviteNum.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblInviteNum];
}

// 根据数据重新设置cell单元格
- (void)setPersonRankingModel:(RYGActivePersonModel *)personRankingModel {
    _personRankingModel = personRankingModel;
    [self updateCell];
}

- (void)updateCell {
    // 发帖数
    self.lblPublishNum.text = [NSString stringWithFormat:@" 发帖数 %@",self.personRankingModel.publish_num];
    // 回复数
    self.lblCommentNum.text = [NSString stringWithFormat:@" 回复数 %@",self.personRankingModel.comment_num];
    // 转发数
    self.lblShareNum.text = [NSString stringWithFormat:@" 转发数 %@",self.personRankingModel.share_num];
    // 点赞数
    self.lblPraiseNum.text = [NSString stringWithFormat:@" 点赞数 %@",self.personRankingModel.praise_num];
    // 活跃天数
    self.lblActiveNum.text = [NSString stringWithFormat:@" 活跃天数 %@",self.personRankingModel.active_num];
    // 邀请数
    self.lblInviteNum.text = [NSString stringWithFormat:@" 邀请数 %@",self.personRankingModel.invite_num];
}

@end
