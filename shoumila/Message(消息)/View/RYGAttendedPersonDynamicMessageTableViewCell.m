//
//  RYGAttendedPersonDynamicMessageTableViewCell.m
//  被关注的人的动态消息单元格
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAttendedPersonDynamicMessageTableViewCell.h"
#import "RYGGrandeMarkView.h"
#import "RYGDateUtility.h"
#import "UIImageView+RYGWebCache.h"
#import "MLEmojiLabel.h"
#import "RYGUserCenterViewController.h"


static NSString *RYGAttendedPersonDynamicMessageCollectionViewCellIdentifier = @"attendedPersonDynamicMessageCollectionViewCellIdentifier";

@implementation RYGAttendedPersonDynamicMessageCollectionViewCell
{
    UIImageView *_portraitImageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    // 头像
    _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 54, 54)];
    [self.contentView addSubview:_portraitImageView];
}

- (void)setPhoto:(NSString *)photo{
    [_portraitImageView setImageURLStr:photo placeholder:nil];
}

@end

@interface RYGAttendedPersonDynamicMessageTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

// 头像
@property(nonatomic,strong)UIImageView *portraitImageView;
// 用户名
@property(nonatomic,strong)UILabel *lblUserName;
// 等级
@property(nonatomic,strong)RYGGrandeMarkView *grandMarkView;
// 时间
@property(nonatomic,strong)UILabel *lblTime;
// 评论内容+图片
@property(nonatomic,strong)UIView *commentView;
// 评论图片
@property(nonatomic,strong)UICollectionView *commentCollectionView;
@property(nonatomic,strong)UIButton *btnGameBefore;
// 评价的内容
@property(nonatomic,strong)UILabel *lblComment;
// 点赞数
@property(nonatomic,strong)UIImageView *praiseImageView;
@property(nonatomic,strong)UILabel *lblPraise;
// 分享数
@property(nonatomic,strong)UIImageView *shareImageView;
@property(nonatomic,strong)UILabel *lblShare;
// 消息数
@property(nonatomic,strong)UIImageView *newsImageView;
@property(nonatomic,strong)UILabel *lblNews;

@property(nonatomic,strong)UIView *lineView;
// 连红标志
@property(nonatomic,strong)UIImageView *continuousWinImageView;
// 印章标志
@property(nonatomic,strong)UIImageView *stampImageView;

// 弹窗的控件数组
@property(nonatomic,strong)NSMutableArray *alertViewArr;

@property(nonatomic,strong) UIButton *popup;
@property(nonatomic,strong) UILabel *popupLabel;
@property(nonatomic,strong) UIView *bgView;

@end

@implementation RYGAttendedPersonDynamicMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame = self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, self.contentView.height);
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIControl *personCtrl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 47, 62)];
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
    
    _continuousWinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.width - 66 - 57, 10, 57, 37)];
    [self.contentView addSubview:_continuousWinImageView];
    
    _stampImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.width - 100, self.contentView.height - 100, 100, 100)];
    [self.contentView addSubview:_stampImageView];
    
    // 评论内容+图片
    _commentView = [[UIView alloc]init];
    [self.contentView addSubview:_commentView];
    
    // 评论title
    _lblComment = [[UILabel alloc]init];
    _lblComment.font = [UIFont systemFontOfSize:13];
    _lblComment.numberOfLines = 0;
    _lblComment.textColor = ColorName;
    [self.commentView addSubview:_lblComment];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.0;
    [_bgView addGestureRecognizer:tapGesture];
    
    _popup = [[UIButton alloc]initWithFrame:CGRectMake(100, 22, 136, 45)];
    [_popup setBackgroundImage:[UIImage imageNamed:@"tanceng"] forState:UIControlStateNormal];
    
    _popupLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 136, 45)];
    _popupLabel.backgroundColor = [UIColor clearColor];
    _popupLabel.textColor = ColorName;
    _popupLabel.numberOfLines = 0;
    _popupLabel.font = [UIFont systemFontOfSize:10];
    [_popup addSubview:_popupLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapView) name:kRemoveView object:nil];
    
    // 评论图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _commentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 15, 32, 32) collectionViewLayout:layout];
    [_commentCollectionView registerClass:[RYGAttendedPersonDynamicMessageCollectionViewCell class] forCellWithReuseIdentifier:RYGAttendedPersonDynamicMessageCollectionViewCellIdentifier];
    _commentCollectionView.backgroundColor = [UIColor clearColor];
    _commentCollectionView.delegate = self;
    _commentCollectionView.dataSource = self;
    [self.commentView addSubview:_commentCollectionView];
    
    _btnGameBefore = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 15)];
    _btnGameBefore.layer.cornerRadius = 2;
    _btnGameBefore.layer.masksToBounds = YES;
    [_btnGameBefore setTitleColor:ColorRankBackground forState:UIControlStateNormal];
    [_btnGameBefore.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    _btnGameBefore.backgroundColor = ColorRateTitle;
    [_btnGameBefore setTitle:@"赛前" forState:UIControlStateNormal];
    _btnGameBefore.userInteractionEnabled = NO;
    [self.commentView addSubview:_btnGameBefore];
    
    // 点赞数
    _praiseImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_praiseImageView];
    _lblPraise = [[UILabel alloc]init];
    _lblPraise.textColor = ColorSecondTitle;
    _lblPraise.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_lblPraise];
    // 分享数
    _shareImageView = [[UIImageView alloc]init];
    _shareImageView.image = [UIImage imageNamed:@"message_dynamic_share"];
    [self.contentView addSubview:_shareImageView];
    _lblShare = [[UILabel alloc]init];
    _lblShare.textColor = ColorSecondTitle;
    _lblShare.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_lblShare];
    // 消息数
    _newsImageView = [[UIImageView alloc]init];
    _newsImageView.image = [UIImage imageNamed:@"message_dynamic_comment"];
    [self.contentView addSubview:_newsImageView];
    _lblNews = [[UILabel alloc]init];
    _lblNews.textColor = ColorSecondTitle;
    _lblNews.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_lblNews];
    
    _lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:self.lineView];
}

- (void)setAttendedPersonDynamicMessageModel:(RYGAttendedPersonDynamicMessageModel *)attendedPersonDynamicMessageModel{
    _attendedPersonDynamicMessageModel = attendedPersonDynamicMessageModel;
    
    _portraitImageView.frame = CGRectMake(15, 15, 32, 32);
    
    NSString *logo;
    NSString *name;
    NSString *grade;
    // 普通动态 赛事动态 type = 13;
    if ([self.attendedPersonDynamicMessageModel.type isEqualToString:@"13"]) {
        logo = _attendedPersonDynamicMessageModel.data.publish_user.avatar;
        name = _attendedPersonDynamicMessageModel.data.publish_user.name;
        grade = _attendedPersonDynamicMessageModel.data.publish_user.grade;
    }
    // 套餐 type = 14
    else {
        logo = _attendedPersonDynamicMessageModel.data.user_logo;
        name = _attendedPersonDynamicMessageModel.data.user_name;
        grade = _attendedPersonDynamicMessageModel.data.grade;
    }
    [_portraitImageView setImageURLStr:logo placeholder:[UIImage imageNamed:@"user_head"]];
    
    CGFloat maginY = 0;
    // 用户名
    _lblUserName.text = name;
    CGSize userNameSize = RYG_TEXTSIZE(name, [UIFont systemFontOfSize:15]);
    CGFloat userNameWidth = MIN(userNameSize.width, self.contentView.width - CGRectGetMaxX(_portraitImageView.frame) - 10 - 15 - 43);
    _lblUserName.frame = CGRectMake(CGRectGetMaxX(_portraitImageView.frame) + 10, CGRectGetMinY(_portraitImageView.frame),userNameWidth, 15);
    // 等级
    _grandMarkView.frame = CGRectMake(CGRectGetMaxX(_lblUserName.frame), CGRectGetMinY(_lblUserName.frame), self.contentView.width - CGRectGetMaxX(_lblUserName.frame) - 43 - 15 - 5, 15);
    _grandMarkView.integralRank = grade;
    
    // 时间
    _lblTime.text = self.attendedPersonDynamicMessageModel.in_time;
    CGSize timeSize = RYG_TEXTSIZE(_lblTime.text, [UIFont systemFontOfSize:10]);
    _lblTime.frame = CGRectMake(CGRectGetMinX(_lblUserName.frame), CGRectGetMaxY(_lblUserName.frame) + 6, self.contentView.width - CGRectGetMaxX(_lblUserName.frame) - 43 - 15 - 5, timeSize.height);
    _continuousWinImageView.hidden = YES;
    _stampImageView.hidden = YES;
     // 普通动态,赛事动态 评论内容+图片
    if ([self.attendedPersonDynamicMessageModel.type isEqualToString:@"13"]) {
        if ([self.attendedPersonDynamicMessageModel.data.publish_user.max_continuous_win integerValue] > 2) {
            _continuousWinImageView.image = [self continuousWinImage:[self.attendedPersonDynamicMessageModel.data.publish_user.max_continuous_win integerValue]];
            _continuousWinImageView.hidden = NO;
        }
        if ([self.attendedPersonDynamicMessageModel.data.stamp integerValue] > 0) {
            _stampImageView.image = [self stampImage:[self.attendedPersonDynamicMessageModel.data.stamp integerValue]];
            _stampImageView.hidden = NO;
        }
    }
    CGFloat commentMagin = 0;
    // 0:普通帖子 1:赛前 2:滚球
    if ([self.attendedPersonDynamicMessageModel.data.type isEqualToString:@"1"]) {
        _btnGameBefore.hidden = NO;
        commentMagin = 32 + 8;
    }
    else {
        _btnGameBefore.hidden = YES;
    }
    
    NSMutableString *content = [[NSMutableString alloc]init];
    // 普通动态,赛事动态 评论内容+图片
    if ([self.attendedPersonDynamicMessageModel.type isEqualToString:@"14"]) {
        for (int i = 0; i < self.attendedPersonDynamicMessageModel.data.text_content.count; i++) {
            RYGDynamicConetentModel *conentModel = [self.attendedPersonDynamicMessageModel.data.text_content objectAtIndex:i];
            [content appendString:conentModel.text];
        }
    }
    else {
        content = (NSMutableString *)self.attendedPersonDynamicMessageModel.data.content;
    }

    _lblComment.text = content;
    
    CGFloat picHeight = 0;
    CGFloat maxWidth = self.contentView.width - 30 - commentMagin - 15;
    CGSize commentSize = RYG_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:14], CGSizeMake(maxWidth, FLT_MAX), NSLineBreakByWordWrapping);
    // 普通动态,赛事动态 评论内容+图片
    if ([self.attendedPersonDynamicMessageModel.type isEqualToString:@"13"] && self.attendedPersonDynamicMessageModel.data.pics && self.attendedPersonDynamicMessageModel.data.pics.count > 0) {
        self.commentCollectionView.hidden = NO;
        picHeight = 54 + 10;
    }
    else {
        self.commentCollectionView.hidden = YES;
    }
    self.lblComment.frame = CGRectMake(commentMagin, 0, commentSize.width, commentSize.height);
    [self.lblComment sizeToFit];
    self.commentCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.lblComment.frame) + 10, self.commentView.width, 54);

    self.commentView.frame = CGRectMake(CGRectGetMinX(_portraitImageView.frame), CGRectGetMaxY(_portraitImageView.frame) + 15, self.contentView.width - 30, commentSize.height + picHeight);

    maginY = CGRectGetMaxY(self.commentView.frame) + 15;
    
    CGSize newsSize = RYG_TEXTSIZE(self.attendedPersonDynamicMessageModel.data.comment_num, [UIFont systemFontOfSize:12]);
    _lblNews.text = self.attendedPersonDynamicMessageModel.data.comment_num;
    self.lblNews.frame = CGRectMake(self.contentView.width - 15 - newsSize.width, maginY, newsSize.width, 15);
    _newsImageView.frame = CGRectMake(CGRectGetMinX(_lblNews.frame) - 5 - 15, maginY, 15, 15);
    
    NSString *share = @"0";
    if (self.attendedPersonDynamicMessageModel.data.share_num && [self.attendedPersonDynamicMessageModel.data.share_num intValue] > 0) {
        share = self.attendedPersonDynamicMessageModel.data.share_num;
    }
    CGSize shareSize = RYG_TEXTSIZE(share, [UIFont systemFontOfSize:12]);
    _lblShare.text = share;
    _lblShare.frame = CGRectMake(CGRectGetMinX(_newsImageView.frame) - 30 - shareSize.width, maginY, shareSize.width, 15);
    _shareImageView.frame = CGRectMake(CGRectGetMinX(_lblShare.frame) - 5 - 15, maginY, 15, 15);
    
    NSString *praise = @"赞";
    if (self.attendedPersonDynamicMessageModel.data.praise_num && [self.attendedPersonDynamicMessageModel.data.praise_num intValue] > 0) {
        praise = self.attendedPersonDynamicMessageModel.data.praise_num;
        _praiseImageView.image = [UIImage imageNamed:@"message_dynamic_praise_light"];
    }
    else {
        _praiseImageView.image = [UIImage imageNamed:@"message_dynamic_praise"];
    }
    CGSize praiseSize = RYG_TEXTSIZE(praise, [UIFont systemFontOfSize:12]);
    _lblPraise.text = praise;
    _lblPraise.frame = CGRectMake(CGRectGetMinX(_shareImageView.frame) - 30 - praiseSize.width, maginY, praiseSize.width, 15);
    _praiseImageView.frame = CGRectMake(CGRectGetMinX(_lblPraise.frame) - 5 - 15, maginY, 15, 15);
    
    _stampImageView.frame = CGRectMake(self.contentView.width - 100, maginY + 25 - 100, 100, 100);
    
     self.lineView.frame = CGRectMake(0, maginY + 25, self.contentView.width, SeparatorLineHeight);
}

- (UIImage *)continuousWinImage:(NSInteger)continuousWin {
    UIImage *winImage;
    if (continuousWin == 3) {
        winImage = [UIImage imageNamed:@"continuous_win3"];
    }
    else if (continuousWin == 4) {
        winImage = [UIImage imageNamed:@"continuous_win4"];
    }
    else if (continuousWin == 5) {
      winImage = [UIImage imageNamed:@"continuous_win5"];
    }
    else if (continuousWin == 6) {
       winImage = [UIImage imageNamed:@"continuous_win6"];
    }
    else if (continuousWin == 7) {
       winImage = [UIImage imageNamed:@"continuous_win7"];
    }
    else if (continuousWin == 8) {
       winImage = [UIImage imageNamed:@"continuous_win8"];
    }
    else if (continuousWin == 9) {
        winImage = [UIImage imageNamed:@"continuous_win9"];
    }
    else if (continuousWin == 10) {
        winImage = [UIImage imageNamed:@"continuous_win10"];
    }
    else if (continuousWin == 11) {
        winImage = [UIImage imageNamed:@"continuous_win11"];
    }
    else if (continuousWin == 12) {
        winImage = [UIImage imageNamed:@"continuous_win12"];
    }
    else if (continuousWin == 13) {
        winImage = [UIImage imageNamed:@"continuous_win13"];
    }
    
    return winImage;
}

- (UIImage *)stampImage:(NSInteger)stamp {
    
    NSString *stampName = [NSString stringWithFormat:@"stamp%ld",(long)stamp];
    UIImage *stampImage = [UIImage imageNamed:stampName];
    return stampImage;
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.attendedPersonDynamicMessageModel.data.pics count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *photo = [self.attendedPersonDynamicMessageModel.data.pics objectAtIndex:indexPath.row];
    RYGAttendedPersonDynamicMessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RYGAttendedPersonDynamicMessageCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.photo = photo;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(54, 54);
}

- (void)clickOtherPerson {
    NSString *userId;
    // 普通动态 赛事动态 type = 13;
    if ([self.attendedPersonDynamicMessageModel.type isEqualToString:@"13"]) {
        userId = _attendedPersonDynamicMessageModel.data.publish_user.userid;
    }
    // 套餐 type = 14
    else {
        userId = _attendedPersonDynamicMessageModel.data.userid;
    }

    if (self.switchOtherPersonBlock) {
        self.switchOtherPersonBlock(userId);
    }
}

- (void)clickReplyInfo {
    if (self.switchDetailOrCommentBlock) {
        self.switchDetailOrCommentBlock(self.attendedPersonDynamicMessageModel);
    }
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
        {
            RYGUserCenterViewController *userCenterVC = [[RYGUserCenterViewController alloc]init];
            [[RYGUtility getCurrentVC] pushViewController:userCenterVC animated:YES];
        }
            break;
        case MLEmojiLabelLinkTypePoundSign:
//            [_popupLabel setText:_dynamicFrame.dynamicModel.popup];
            [self addSubview:_popup];
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
    [super touchesBegan:touches withEvent:event];
}

- (void)tapView{
    if (_popup) {
        [_popup removeFromSuperview];
    }
}

- (void)cancelAction{
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        if (_bgView) {
            [_bgView removeFromSuperview];
        }
    }];
}


@end
