//
//  UMChatTableViewCell.m
//  Feedback
//
//  Created by amoblin on 14/7/31.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "UMChatTableViewCell.h"
#import "UMOpenMacros.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGDateUtility.h"

@interface UMChatTableViewCell ()

// 头像
@property (nonatomic, strong) UIImageView *iconImageView;

// 时间
@property (nonatomic, strong) UILabel *timeLabel;

// 内容
@property (nonatomic, strong) UILabel *contentLabel;
// 内容背景
@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation UMChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorRankMyRankBackground;
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = ColorRankMedal;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        _backImageView = [[UIImageView alloc] init];
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_backImageView];

        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.textColor = ColorName;
        self.backgroundColor = [UIColor clearColor];
        [self.backImageView addSubview:self.contentLabel];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 32, 32)];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.image = [UIImage imageNamed:@"message_customer_photo"];
        [self.contentView addSubview:self.iconImageView];
    }
    return self;
}

- (void)configCell:(NSDictionary *)info showTime:(NSString *)showTime  {
    if ([info[@"is_failed"] boolValue]) {
        self.contentLabel.textColor = UM_UIColorFromHex(0xff0000);
        self.timeLabel.textColor = UM_UIColorFromHex(0xff0000);
    } else {
        self.contentLabel.textColor = ColorName;
        self.timeLabel.textColor = ColorRankMedal;
    }
    CGFloat cellHeight = 0;
    // 显示时间
    if ([showTime isEqualToString:@"1"]) {
        self.timeLabel.hidden = NO;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info[@"created_at"] doubleValue] / 1000];
        self.timeLabel.text = [RYGDateUtility humanableInfoFromDate:date];
        CGSize timeSize =  RYG_TEXTSIZE(self.timeLabel.text, [UIFont systemFontOfSize:10]);
        self.timeLabel.frame = CGRectMake(0, 20, self.width, timeSize.height);
        cellHeight = 20 + timeSize.height + 10;
    }
    else {
        self.timeLabel.hidden = YES;
        cellHeight = 15;
    }
    self.contentLabel.text = info[@"content"];
    self.iconImageView.frame = CGRectMake(10, cellHeight, 32, 32);
    CGSize labelSize = RYG_MULTILINE_TEXTSIZE(self.contentLabel.text, [UIFont systemFontOfSize:14.0f], CGSizeMake((self.contentView.width - 39 - 42 - 4 - 20), FLT_MAX), NSLineBreakByTruncatingTail);
    CGFloat labelHight = 32;
    if ((labelSize.height + 20) > 32) {
        labelHight = labelSize.height + 20;
    }
    self.backImageView.frame = CGRectMake(46, cellHeight, labelSize.width + 20, labelHight) ;
    self.backImageView.image = [[UIImage imageNamed:@"chat_receive_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    self.contentLabel.frame = CGRectMake(10, 10, labelSize.width, labelSize.height);
    
}

@end
