//
//  RYGDynamicCommnetView.m
//  shoumila
//
//  Created by 贾磊 on 15/9/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicCommnetView.h"
#import "UIImageView+WebCache.h"
#import "RYGCommentModel.h"


@interface RYGDynamicCommnetView ()
@property(nonatomic,strong) UIImageView *avatar1;
@property(nonatomic,strong) UIImageView *avatar2;
@property(nonatomic,strong) UIImageView *avatar3;

@property(nonatomic,strong) UILabel *label1;
@property(nonatomic,strong) UILabel *label2;
@property(nonatomic,strong) UILabel *label3;

@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIView *line1;
@property(nonatomic,strong) UIView *line2;
@property(nonatomic,strong) UIButton *moreMsgBtn;
@end
@implementation RYGDynamicCommnetView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorRankMyRankBackground;
        _avatar1 = [[UIImageView alloc]init];
        _avatar1.layer.masksToBounds = YES;
        _avatar1.layer.cornerRadius = 2;
        [self addSubview:_avatar1];
        
        _avatar2 = [[UIImageView alloc]init];
        _avatar2.layer.masksToBounds = YES;
        _avatar2.layer.cornerRadius = 2;
        [self addSubview:_avatar2];
        
        _avatar3 = [[UIImageView alloc]init];
        _avatar3.layer.masksToBounds = YES;
        _avatar3.layer.cornerRadius = 2;
        [self addSubview:_avatar3];
        
        _label1 = [[UILabel alloc]init];
        _label1.font = [UIFont systemFontOfSize:12];
        _label1.textColor = ColorSecondTitle;
        _label1.numberOfLines = 0;
        [self addSubview:_label1];
        
        _label2 = [[UILabel alloc]init];
        _label2.font = [UIFont systemFontOfSize:12];
        _label2.textColor = ColorSecondTitle;
        _label2.numberOfLines = 0;
        [self addSubview:_label2];
        
        _label3 = [[UILabel alloc]init];
        _label3.font = [UIFont systemFontOfSize:12];
        _label3.textColor = ColorSecondTitle;
        _label3.numberOfLines = 0;
        [self addSubview:_label3];
        
        _line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _line1.backgroundColor = ColorLine;
        [self addSubview:_line1];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 1)];
        _line.backgroundColor = ColorLine;
        [self addSubview:_line];
        
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _line2.backgroundColor = ColorCellBackground;
        [self addSubview:_line2];
        
        _moreMsgBtn = [[UIButton alloc]init];
        [_moreMsgBtn setTitleColor:ColorRankMenuBackground forState:UIControlStateNormal];
        _moreMsgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_moreMsgBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
        _moreMsgBtn.userInteractionEnabled = NO;
        [self addSubview:_moreMsgBtn];
        
    }
    return self;
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    NSArray *comments = dynamicFrame.dynamicModel.comment_list;
    
    _line1.frame = dynamicFrame.line1F;
    [_avatar1 removeFromSuperview];
    [_label1 removeFromSuperview];
    [_avatar2 removeFromSuperview];
    [_label2 removeFromSuperview];
    [_avatar3 removeFromSuperview];
    [_label3 removeFromSuperview];
    if (comments) {
        [comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGCommentModel *comment = obj;
            NSString *reply = comment.reply_name?[NSString stringWithFormat:@"回复%@",comment.reply_name]:@"";
            NSString *commentStr = [NSString stringWithFormat:@"%@%@:%@",comment.name,reply,comment.comment];
            NSMutableAttributedString *attrComment = [[NSMutableAttributedString alloc]initWithString:commentStr];
            NSRange name = NSMakeRange(0, comment.name.length);
            [attrComment addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:name];
            NSRange replyRange = NSMakeRange(comment.name.length+2, comment.reply_name.length);
            [attrComment addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:replyRange];
            switch (idx) {
                case 0:
                    _avatar1.frame = dynamicFrame.avatar1F;
                    [_avatar1 sd_setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"user_head"]];
                    _label1.attributedText = attrComment;
                    _label1.frame = dynamicFrame.label1F;
                    [self addSubview:_avatar1];
                    [self addSubview:_label1];
                    break;
                case 1:
                    _avatar2.frame = dynamicFrame.avatar2F;
                    [_avatar2 sd_setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"user_head"]];
                    _label2.attributedText = attrComment;
                    _label2.frame = dynamicFrame.label2F;
                    [self addSubview:_avatar2];
                    [self addSubview:_label2];
                    break;
                case 2:
                    _avatar3.frame = dynamicFrame.avatar3F;
                    [_avatar3 sd_setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"user_head"]];
                    _label3.attributedText = attrComment;
                    _label3.frame = dynamicFrame.label3F;
                    [self addSubview:_avatar3];
                    [self addSubview:_label3];
                    break;
                default:
                    break;
            }
            
        }];
    }
    NSString *moreBtnText = [NSString stringWithFormat:@"查看更多%@条回复",dynamicFrame.dynamicModel.comment_num];
    [_moreMsgBtn setTitle:moreBtnText forState:UIControlStateNormal];
    _line.frame = dynamicFrame.lineF;
    _moreMsgBtn.frame = dynamicFrame.moreMsgBtnF;
    self.frame = dynamicFrame.commentViewF;
    _line2.top = dynamicFrame.commentViewF.size.height;
}

@end
