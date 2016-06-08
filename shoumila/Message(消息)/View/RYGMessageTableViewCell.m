//
//  RYGMessageTableViewCell.m
//  消息画面
//
//  Created by jiaocx on 15/8/18.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageTableViewCell.h"
#import "JSBadgeView.h"
#import "RYGDateUtility.h"
#import "UIImageView+RYGWebCache.h"

@interface RYGMessageTableViewCell ()

// 头像
@property(nonatomic,strong)UIImageView *portraitImageView;
// 新帖字数
@property(nonatomic,strong)JSBadgeView *badgeNew;
// 消息Title
@property(nonatomic,strong)UILabel *lblTitle;
// 消息内容
@property(nonatomic,strong)UILabel *lblContent;
// 消息时间
@property(nonatomic,strong)UILabel *lblTime;
// 收米小助手的Title内容
@property(nonatomic,strong)UIView *helperView;

@end

@implementation RYGMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    
    self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, MessageTableViewCellHeight);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    self.portraitImageView.layer.cornerRadius = 4.0;
    self.portraitImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.portraitImageView];
    
    // 新帖字数
    // 添加一个提醒数字按钮
    UIControl *control = [[UIControl alloc]initWithFrame:self.portraitImageView.frame];
    [self.contentView addSubview:control];
    _badgeNew = [[JSBadgeView alloc]initWithParentView:control];
    
    _lblTitle = [[UILabel alloc]init];
    _lblTitle.font = [UIFont systemFontOfSize:15];
    _lblTitle.textColor = ColorName;
    [self.contentView addSubview:_lblTitle];
    
    _lblContent = [[UILabel alloc]init];
    _lblContent.textColor = ColorRankMedal;
    _lblContent.font = [UIFont systemFontOfSize:13];
    _lblContent.numberOfLines = 1;
    _lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_lblContent];
    
    _lblTime = [[UILabel alloc]init];
    _lblTime.textColor = ColorRankMedal;
    _lblTime.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblTime];
    
    CGSize helpSize = RYG_TEXTSIZE(@"收米小助手", [UIFont systemFontOfSize:15]);
    _helperView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.portraitImageView.frame), 5, helpSize.width, helpSize.height)];
    _helperView.hidden = YES;
    [self.contentView addSubview:_helperView];
    
    UILabel *lblHelp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, helpSize.width, helpSize.height)];
    lblHelp.font = [UIFont systemFontOfSize:15];
    lblHelp.textColor = ColorRateTitle;
    lblHelp.text = @"收米小助手";
    [self.helperView addSubview:lblHelp];
    
    UIImageView *vImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lblHelp.frame) + 2, (helpSize.height - 11) / 2, 12, 11)];
    vImageView.image = [UIImage imageNamed:@"message_helper_v"];
    [self.helperView addSubview:vImageView];
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(vImageView.frame) + 2, (helpSize.height - 12) / 2, 0.5, 12)];
    lineImageView.image = [UIImage imageNamed:@"message_helper_spline"];
    [self.helperView addSubview:lineImageView];
    
    CGSize suppSize = RYG_TEXTSIZE(@"收米啦官方客服", [UIFont systemFontOfSize:13]);
    UILabel *lblHelpSupp = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineImageView.frame) + 2, (helpSize.height - suppSize.height) / 1, suppSize.width, suppSize.height)];
    lblHelpSupp.textColor = ColorSecondTitle;
    lblHelpSupp.font = [UIFont systemFontOfSize:13];
    lblHelpSupp.text = @"收米啦官方客服";
    [self.helperView addSubview:lblHelpSupp];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, MessageTableViewCellHeight - SeparatorLineHeight, self.contentView.width, SeparatorLineHeight)];
    lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:lineView];
   
}

- (void)setMessageModel:(RYGMessageBaseModel *)messageModel {
    _messageModel = messageModel;
    _helperView.hidden = YES;
    _lblTitle.hidden = NO;
    NSString *type = messageModel.mtype;
    // 回复我的
    if ([type isEqualToString:@"1"]) {
        self.portraitImageView.image = [UIImage imageNamed:@"message_portrait_reply_me"];
        _lblTitle.text = @"回复我的";
    }
    
    // 提到我的
    else if([type isEqualToString:@"2"]) {
        self.portraitImageView.image = [UIImage imageNamed:@"message_portrait_refer_me"];
        _lblTitle.text = @"提到我的";
    }
    // 赞过我的
    else if([type isEqualToString:@"3"]) {
        self.portraitImageView.image = [UIImage imageNamed:@"message_portrait_praise_me"];
        _lblTitle.text = @"赞过我的";
    }
    // 消息中心
    else if([type isEqualToString:@"4"]) {
        self.portraitImageView.image = [UIImage imageNamed:@"message_portrait_news_center"];
        _lblTitle.text = @"消息中心";
    }
    // 收米
    else if([type isEqualToString:@"5"]) {
        self.portraitImageView.image = [UIImage imageNamed:@"message_portrait_receive"];
        _helperView.hidden = NO;
        _lblTitle.hidden = YES;
    }
    // 消息
    else  {
        _lblTitle.text = self.messageModel.text;
        [self.portraitImageView setImageURLStr:self.messageModel.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
        _lblTitle.text = self.messageModel.user_name;
    }

    _lblTime.text = messageModel.ctime;
    CGSize timeSize = RYG_TEXTSIZE(_lblTime.text, [UIFont systemFontOfSize:10]);
    _lblTime.frame = CGRectMake(self.contentView.width - 15 - timeSize.width, 9, timeSize.width, 12);
    
    _lblTitle.frame = CGRectMake(CGRectGetMaxX(self.portraitImageView.frame) + 10, 12, CGRectGetMinX(_lblTime.frame) - CGRectGetMaxX(self.portraitImageView.frame) - 10, 18);
    
    _lblContent.text = messageModel.text;
    if ([type isEqualToString:@"5"]) {
        CGSize helpSize = RYG_TEXTSIZE(@"收米小助手", [UIFont systemFontOfSize:15]);
        _helperView.frame =CGRectMake(CGRectGetMaxX(self.portraitImageView.frame) + 10, 12, CGRectGetMinX(_lblTime.frame) - CGRectGetMaxX(self.portraitImageView.frame) - 10, helpSize.height);
        _lblContent.frame = CGRectMake(CGRectGetMinX(_lblTitle.frame), CGRectGetMaxY(_helperView.frame) + 8, self.contentView.width - CGRectGetMaxX(self.portraitImageView.frame) - 10 - 15, 18);
    }
    else {
       _lblContent.frame = CGRectMake(CGRectGetMinX(_lblTitle.frame), CGRectGetMaxY(_lblTitle.frame) + 8, self.contentView.width - CGRectGetMaxX(self.portraitImageView.frame) - 10 - 15, 16);
    }
    _badgeNew.badgeText = messageModel.num;

}

@end
