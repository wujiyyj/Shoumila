//
//  RYGMessageCenterTableViewCell.m
//  消息中心单元格
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageCenterTableViewCell.h"

#import "UMFeedback.h"
#import "UMOpenMacros.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGDateUtility.h"

@interface RYGMessageCenterTableViewCell ()

// 时间
@property (nonatomic, strong) UILabel *timeLabel;

// 内容
@property (nonatomic, strong) UILabel *contentLabel;
// 内容背景
@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation RYGMessageCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.frame = self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, SCREEN_WIDTH, FLT_MAX);
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = ColorRankMedal;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        _backImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backImageView];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.textColor = ColorName;
        self.backgroundColor = [UIColor clearColor];
        [self.backImageView addSubview:self.contentLabel];
    }
    return self;
}

- (void)updateCell:(RYGMessageCenterModel *)messageCenterModel showTime:(NSString *)showTime {
    _messageCenterModel = messageCenterModel;

    CGFloat cellHeight = 15;
    // 显示时间
    if ([showTime isEqualToString:@"1"]) {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = self.messageCenterModel.in_time;
        CGSize timeSize =  RYG_TEXTSIZE(self.timeLabel.text, [UIFont systemFontOfSize:10]);
        self.timeLabel.frame = CGRectMake(0, 15, self.contentView.width, timeSize.height);
        cellHeight += timeSize.height + 10;
    }
    else {
        self.timeLabel.hidden = YES;
    }
    
    NSMutableString *content = [[NSMutableString alloc]init];
    
    for (int i = 0; i < self.messageCenterModel.data.content.count; i++) {
        RYGConetentModel *conentModel = [self.messageCenterModel.data.content objectAtIndex:i];
        [content appendString:conentModel.text];
    }
    NSMutableAttributedString *stringAS = [[NSMutableAttributedString alloc] initWithString:content];

    NSInteger index=0;
    for (int i = 0; i < self.messageCenterModel.data.content.count; i++) {
        RYGConetentModel *conentModel = [self.messageCenterModel.data.content objectAtIndex:i];
        // 正常颜色
        if ([conentModel.color isEqualToString:@"0"]) {
            [stringAS addAttribute:NSForegroundColorAttributeName value:ColorName
                             range:NSMakeRange(index, conentModel.text.length)];
        }
        else {
            [stringAS addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground
                             range:NSMakeRange(index, conentModel.text.length)];
        }
        index += conentModel.text.length;
    }

    self.contentLabel.attributedText = stringAS;

    CGSize labelSize = RYG_MULTILINE_TEXTSIZE(self.contentLabel.text, [UIFont systemFontOfSize:14.0f], CGSizeMake((self.contentView.width - 50), FLT_MAX), NSLineBreakByTruncatingTail);
    CGFloat labelHight = labelSize.height + 20;
    self.backImageView.frame = CGRectMake(15, cellHeight, self.contentView.width - 30, labelHight) ;
    self.backImageView.image = [[UIImage imageNamed:@"message_center_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:25];
    
    self.contentLabel.frame = CGRectMake(10, 10, self.backImageView.width - 20, labelSize.height);
    [self.contentLabel sizeToFit];
}

@end
