//
//  RYGMessagePraiseMeTableViewCell.m
//  赞过我的消息单元格
//
//  Created by jiaocx on 15/8/21.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessagePraiseMeTableViewCell.h"
#import "RYGGrandeMarkView.h"
#import "RYGDateUtility.h"
#import "UIImageView+RYGWebCache.h"

static NSString *RYGMessagePraiseMeCollectionViewCellIdentifier = @"MessagePraiseMeCollectionViewCellIdentifier";

@implementation RYGMessagePraiseMeCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    // 头像
    _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    _portraitImageView.layer.cornerRadius = 4;
    _portraitImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_portraitImageView];
}

- (void)setUser_logo:(NSString *)user_logo {
    [_portraitImageView setImageURLStr:user_logo placeholder:[UIImage imageNamed:@"user_head"]];
}

@end

@interface RYGMessagePraiseMeTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
// 头像
@property(nonatomic,strong)UICollectionView *portraitCollectionView;
// 赞的Title
@property(nonatomic,strong)UILabel *lblPraise;
// 时间
@property(nonatomic,strong)UILabel *lblTime;
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

@implementation RYGMessagePraiseMeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame = self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, FLT_MAX);
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIControl *personCtrl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 47, 60)];
    [personCtrl addTarget:self action:@selector(clickOtherPerson) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:personCtrl];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _portraitCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 15, self.contentView.width, 32) collectionViewLayout:layout];
     [_portraitCollectionView registerClass:[RYGMessagePraiseMeCollectionViewCell class] forCellWithReuseIdentifier:RYGMessagePraiseMeCollectionViewCellIdentifier];
    _portraitCollectionView.backgroundColor = [UIColor clearColor];
    _portraitCollectionView.delegate = self;
    _portraitCollectionView.dataSource = self;
    [self.contentView addSubview:_portraitCollectionView];
    
    // 赞的Title
    _lblPraise = [[UILabel alloc]init];
    _lblPraise.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblPraise.font = [UIFont systemFontOfSize:12];
    _lblPraise.textColor = ColorName;
    _lblPraise.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_lblPraise];
    
    // 时间
    _lblTime = [[UILabel alloc]init];
    _lblTime.textColor = ColorRankMedal;
    _lblTime.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_lblTime];
    
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

- (void)setMessagePraiseModel:(RYGMessagePraiseModel *)messagePraiseModel {
    _messagePraiseModel = messagePraiseModel;
    
    CGFloat logoWidth = [self.messagePraiseModel.praise_users count] * 32 + ([self.messagePraiseModel.praise_users count] - 1) * 10;
    _portraitCollectionView.frame = CGRectMake(15, 15, logoWidth, 32);
    [_portraitCollectionView reloadData];
    
    // 时间
    _lblTime.text = self.messagePraiseModel.ctime;
    CGSize timeSize = RYG_TEXTSIZE(_lblTime.text, [UIFont systemFontOfSize:10]);
    _lblTime.frame = CGRectMake(self.contentView.width - 15 - timeSize.width, 23,timeSize.width, timeSize.height);
    
    // 用户名
    _lblPraise.text = messagePraiseModel.text;
    CGSize praiseSize = RYG_TEXTSIZE(messagePraiseModel.text, [UIFont systemFontOfSize:12]);
    CGFloat praiseWidth = MIN(praiseSize.width, CGRectGetMinX(_lblTime.frame) - CGRectGetMaxX(_portraitCollectionView.frame) - 5);
    _lblPraise.frame = CGRectMake(CGRectGetMaxX(_portraitCollectionView.frame) + 5, CGRectGetMinY(_portraitCollectionView.frame),praiseWidth, 32);
    
    // 评论内容+图片
    if (self.messagePraiseModel.original.pic || (self.messagePraiseModel.original.content && [self.messagePraiseModel.original.content isEqualToString:@""])) {
        
        [_commentImageView setImageURLStr:self.messagePraiseModel.original.pic placeholder:nil];
        
        CGFloat height = RYGMessageTableViewCellCommentPhotoHeight;
        CGFloat magin = 7;
        CGFloat maxWidth = self.contentView.width - 30 - RYGMessageTableViewCellCommentPhotoHeight - RYGMessageTableViewCellCommentMagin - 10;
        CGSize commentSize = RYG_MULTILINE_TEXTSIZE(self.messagePraiseModel.original.content, [UIFont systemFontOfSize:10], CGSizeMake(maxWidth, FLT_MAX), NSLineBreakByWordWrapping);
        CGSize commentTitleSize = RYG_TEXTSIZE(self.messagePraiseModel.original.publish_user_name, [UIFont systemFontOfSize:13]);
        if (commentTitleSize.height + commentSize.height + magin + 4 > RYGMessageTableViewCellCommentPhotoHeight) {
            height = commentTitleSize.height + commentSize.height + magin + 4;
        }
        
        [_lblComment sizeToFit];
        _commentImageView.frame = CGRectMake(0, (height - RYGMessageTableViewCellCommentPhotoHeight) / 2, RYGMessageTableViewCellCommentPhotoHeight, RYGMessageTableViewCellCommentPhotoHeight);
        CGFloat marginLeft = 0;
        if (self.messagePraiseModel.original.pic && ![self.messagePraiseModel.original.pic isEqualToString:@"0"]) {
            marginLeft = CGRectGetMaxX(_commentImageView.frame) + 5;
        }
        _lblCommentTitle.frame = CGRectMake(marginLeft, (height - commentSize.height - commentTitleSize.height - magin) / 2, commentTitleSize.width, commentTitleSize.height);

        _lblComment.frame = CGRectMake(CGRectGetMinX(_lblCommentTitle.frame), CGRectGetMaxY(_lblCommentTitle.frame) + magin, maxWidth, commentSize.height);
        
        _commentView.frame = CGRectMake(CGRectGetMinX(_portraitCollectionView.frame),CGRectGetMaxY(_portraitCollectionView.frame) + 15,self.contentView.width - 30,height);
        
        _lblCommentTitle.text = self.messagePraiseModel.original.publish_user_name;
        _lblComment.text = self.messagePraiseModel.original.content;
        
        self.commentView.hidden = NO;
        self.onlyCommentView.hidden = YES;
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.commentView.frame) + 15, self.contentView.width, SeparatorLineHeight);
    }
    else {
        self.commentView.hidden = YES;
        self.onlyCommentView.hidden = NO;
        
        CGFloat maxWidth = self.contentView.width - 30 - 20;
        CGSize commentSize = RYG_MULTILINE_TEXTSIZE(self.messagePraiseModel.original.content, [UIFont systemFontOfSize:12], CGSizeMake(maxWidth, FLT_MAX), NSLineBreakByWordWrapping);
        _onlyCommentView.frame = CGRectMake(CGRectGetMinX(_portraitCollectionView.frame), CGRectGetMaxY(_portraitCollectionView.frame) + 15, self.contentView.width - 30, commentSize.height + RYGMessageTableViewCellCommentMagin * 2);
        _lblOnlyComment.frame = CGRectMake(RYGMessageTableViewCellCommentMagin, RYGMessageTableViewCellCommentMagin, maxWidth, commentSize.height);
        _lblOnlyComment.text = self.messagePraiseModel.original.content;
        [_lblOnlyComment sizeToFit];
        self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.onlyCommentView.frame) + 15, self.contentView.width, SeparatorLineHeight);
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [self.messagePraiseModel.praise_users count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RYGPraiseUserModel *praiseUserModel = [self.messagePraiseModel.praise_users objectAtIndex:indexPath.row];
    RYGMessagePraiseMeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RYGMessagePraiseMeCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.user_logo = praiseUserModel.user_logo;
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(32, 32);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)clickOtherPerson {
    if (self.switchOtherPersonBlock) {
        self.switchOtherPersonBlock(self.messagePraiseModel.userid);
    }
}

- (void)clickReplyInfo {
    if (self.switchDetailOrCommentBlock) {
        self.switchDetailOrCommentBlock(self.messagePraiseModel.original);
    }
}

@end
