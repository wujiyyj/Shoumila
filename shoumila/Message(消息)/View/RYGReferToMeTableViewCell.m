//
//  RYGReferToMeTableViewCell.m
//  提到我的消息的单元格
//
//  Created by jiaocx on 15/8/21.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGReferToMeTableViewCell.h"
#import "RYGGrandeMarkView.h"
#import "RYGDateUtility.h"
#import "UIImageView+RYGWebCache.h"

@interface RYGReferToMeTableViewCell()

// 头像
@property(nonatomic,strong)UIImageView *portraitImageView;
// 用户名
@property(nonatomic,strong)UILabel *lblUserName;
// 等级
@property(nonatomic,strong)RYGGrandeMarkView *grandMarkView;
// 时间
@property(nonatomic,strong)UILabel *lblTime;
// 回复Title
@property(nonatomic,strong)UILabel *lblReplyTitle;
// 评论内容+图片
@property(nonatomic,strong)UIView *commentView;
// 评论图片
@property(nonatomic,strong)UIImageView *commentImageView;
// 评论title
@property(nonatomic,strong)UILabel *lblCommentTitle;
// 评价的内容
@property(nonatomic,strong)UILabel *lblComment;
// 仅有评论内容
@property(nonatomic,strong)UIView *onlyCommentView;
// 仅有评价的内容
@property(nonatomic,strong)UILabel *lblOnlyComment;

@property(nonatomic,strong)UIView *lineView;

@end

@implementation RYGReferToMeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame = self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, 300);
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIControl *personCtrl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 47, 60)];
    [personCtrl addTarget:self action:@selector(clickOtherPerson) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:personCtrl];
    
    // 头像
    _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 32, 32)];
    _portraitImageView.layer.cornerRadius = 4;
    _portraitImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_portraitImageView];
    
    // 用户名
    _lblUserName = [[UILabel alloc]init];
    _lblUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblUserName.font = [UIFont systemFontOfSize:15];
    _lblUserName.textColor = ColorName;
    _lblUserName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblUserName];
    
    // 等级标志
    _grandMarkView = [[RYGGrandeMarkView alloc]init];
    [self.contentView addSubview:_grandMarkView];
    
    // 时间
    _lblTime = [[UILabel alloc]init];
    _lblTime.textColor = ColorRankMedal;
    _lblTime.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblTime];
    
    // 回复Title
    _lblReplyTitle = [[UILabel alloc]init];
    _lblReplyTitle.font = [UIFont systemFontOfSize:14];
    _lblReplyTitle.textColor = ColorName;
    [self.contentView addSubview:_lblReplyTitle];
    
    // 评论内容+图片
    _commentView = [[UIView alloc]init];
    _commentView.backgroundColor = ColorRankMyRankBackground;
    [self.contentView addSubview:_commentView];
    // 评论图片
    _commentImageView = [[UIImageView alloc]init];
    [_commentView addSubview:_commentImageView];
    
    // 评论title
    _lblCommentTitle = [[UILabel alloc]init];
    _lblCommentTitle.font = [UIFont systemFontOfSize:13];
    _lblCommentTitle.textColor = ColorName;
    [_commentView addSubview:_lblCommentTitle];
    
    // 评价的内容
    _lblComment = [[UILabel alloc]init];
    _lblComment.font = [UIFont systemFontOfSize:10];
    _lblComment.textColor = ColorSecondTitle;
    _lblComment.numberOfLines = 0;
    [_commentView addSubview:_lblComment];
    
    // 仅有评论内容
    _onlyCommentView = [[UIView alloc]init];
    _onlyCommentView.backgroundColor = ColorRankMyRankBackground;
    [self.contentView addSubview:_onlyCommentView];
    
    // 仅有评价的内容
    _lblOnlyComment = [[UILabel alloc]init];
    _lblOnlyComment.font = [UIFont systemFontOfSize:12];
    _lblOnlyComment.textColor = ColorSecondTitle;
    _lblOnlyComment.numberOfLines = 0;
    [_onlyCommentView addSubview:_lblOnlyComment];
    
    _lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:self.lineView];
}

- (void)setMessageReferToMeModel:(RYGMessageReferToMeModel *)messageReferToMeModel {
    _messageReferToMeModel = messageReferToMeModel;
    
    [_portraitImageView setImageURLStr:_messageReferToMeModel.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
    
    // 用户名
    _lblUserName.text = _messageReferToMeModel.user_name;
    CGSize userNameSize = RYG_TEXTSIZE(_messageReferToMeModel.user_name, [UIFont systemFontOfSize:15]);
    CGFloat userNameWidth = MIN(userNameSize.width, self.contentView.width - CGRectGetMaxX(_portraitImageView.frame) - 10 - 15 - 43);
    _lblUserName.frame = CGRectMake(CGRectGetMaxX(_portraitImageView.frame) + 10, CGRectGetMinY(_portraitImageView.frame),userNameWidth, 15);
    // 等级
    _grandMarkView.frame = CGRectMake(CGRectGetMaxX(_lblUserName.frame), CGRectGetMinY(_lblUserName.frame), self.contentView.width - CGRectGetMaxX(_lblUserName.frame) - 43 - 15 - 5, 15);
    _grandMarkView.integralRank = self.messageReferToMeModel.grade;
    
    // 时间
    _lblTime.text = self.messageReferToMeModel.ctime;
    CGSize timeSize = RYG_TEXTSIZE(_lblTime.text, [UIFont systemFontOfSize:10]);
    _lblTime.frame = CGRectMake(CGRectGetMinX(_lblUserName.frame), CGRectGetMaxY(_lblUserName.frame) + 6, self.contentView.width - CGRectGetMaxX(_lblUserName.frame) - 43 - 15 - 5, timeSize.height);
    
    // 回复Title
    NSMutableAttributedString *stringAS = [[NSMutableAttributedString alloc] initWithString:self.messageReferToMeModel.content];
    NSRange range = [self.messageReferToMeModel.content rangeOfString:@"@"];
    if (range.length > 0) {
        NSString *str = [self.messageReferToMeModel.content substringFromIndex:range.location];
        NSRange range1 = [str rangeOfString:@" "];
        if (range1.length==0) {
            range1 = [str rangeOfString:@" "];
        }
        NSUInteger len = range.location + 1;
        if (range1.length!=0 && len < 5) {
            NSRange rangUser = NSMakeRange(range.location, len);
            [stringAS addAttribute:NSForegroundColorAttributeName value:ColorAttionCanBackground range:rangUser];
        }
        _lblReplyTitle.attributedText = stringAS;
    }
    else {
        _lblReplyTitle.text = self.messageReferToMeModel.content;
    }
    CGSize replyTitleSize = RYG_TEXTSIZE(_lblReplyTitle.text, [UIFont systemFontOfSize:14]);
    _lblReplyTitle.frame = CGRectMake(CGRectGetMinX(_portraitImageView.frame), CGRectGetMaxY(_portraitImageView.frame) + 15, self.contentView.width - 30, replyTitleSize.height);
    
    // 评论内容+图片
    if (self.messageReferToMeModel.original.pic || (self.messageReferToMeModel.original.content && [self.messageReferToMeModel.original.content isEqualToString:@""])) {
        
        [_commentImageView setImageURLStr:self.messageReferToMeModel.original.pic placeholder:nil];
        
        CGFloat height = RYGMessageTableViewCellCommentPhotoHeight;
        CGFloat magin = 7;
        CGFloat maxWidth = self.contentView.width - 30 - RYGMessageTableViewCellCommentPhotoHeight - RYGMessageTableViewCellCommentMagin - 10;
        CGSize commentSize = RYG_MULTILINE_TEXTSIZE(self.messageReferToMeModel.original.content, [UIFont systemFontOfSize:10], CGSizeMake(maxWidth, FLT_MAX), NSLineBreakByWordWrapping);
        CGSize commentTitleSize = RYG_TEXTSIZE(self.messageReferToMeModel.original.publish_user_name, [UIFont systemFontOfSize:13]);
        if (commentTitleSize.height + commentSize.height + magin + 4 > RYGMessageTableViewCellCommentPhotoHeight) {
            height = commentTitleSize.height + commentSize.height + magin + 4;
        }
        
        [_lblComment sizeToFit];
        _commentImageView.frame = CGRectMake(0, (height - RYGMessageTableViewCellCommentPhotoHeight) / 2, RYGMessageTableViewCellCommentPhotoHeight, RYGMessageTableViewCellCommentPhotoHeight);
        CGFloat marginLeft = 0;
        if (self.messageReferToMeModel.original.pic && ![self.messageReferToMeModel.original.pic isEqualToString:@"0"]) {
            marginLeft = CGRectGetMaxX(_commentImageView.frame) + 5;
        }
        _lblCommentTitle.frame = CGRectMake(marginLeft, (height - commentSize.height - commentTitleSize.height - magin) / 2, commentTitleSize.width, commentTitleSize.height);
        _lblComment.frame = CGRectMake(CGRectGetMinX(_lblCommentTitle.frame), CGRectGetMaxY(_lblCommentTitle.frame) + magin, maxWidth, commentSize.height);
        
        _commentView.frame = CGRectMake(CGRectGetMinX(_portraitImageView.frame),CGRectGetMaxY(_lblReplyTitle.frame) + RYGMessageTableViewCellCommentMagin,self.contentView.width - 30,height);
        
        _lblCommentTitle.text = self.messageReferToMeModel.original.publish_user_name;
        _lblComment.text = self.messageReferToMeModel.original.content;
        
        self.commentView.hidden = NO;
        self.onlyCommentView.hidden = YES;
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.commentView.frame) + 15, self.contentView.width, SeparatorLineHeight);
    }
    else {
        self.commentView.hidden = YES;
        self.onlyCommentView.hidden = NO;
        
        CGFloat maxWidth = self.contentView.width - 30 - 20;
        CGSize commentSize = RYG_MULTILINE_TEXTSIZE(self.messageReferToMeModel.original.content, [UIFont systemFontOfSize:12], CGSizeMake(maxWidth, FLT_MAX), NSLineBreakByWordWrapping);
        _onlyCommentView.frame = CGRectMake(CGRectGetMinX(_portraitImageView.frame), CGRectGetMaxY(_lblReplyTitle.frame) + RYGMessageTableViewCellCommentMagin, self.contentView.width - 30, commentSize.height + RYGMessageTableViewCellCommentMagin * 2);
        _lblOnlyComment.frame = CGRectMake(RYGMessageTableViewCellCommentMagin, RYGMessageTableViewCellCommentMagin, maxWidth, commentSize.height);
        _lblOnlyComment.text = self.messageReferToMeModel.original.content;
        [_lblOnlyComment sizeToFit];
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.onlyCommentView.frame) + 15, self.contentView.width, SeparatorLineHeight);
    }
}

- (void)clickOtherPerson {
    if (self.switchOtherPersonBlock) {
        self.switchOtherPersonBlock(self.messageReferToMeModel.userid);
    }
}

- (void)clickReplyInfo {
    if (self.switchDetailOrCommentBlock) {
        self.switchDetailOrCommentBlock(self.messageReferToMeModel.original);
    }
}

@end
