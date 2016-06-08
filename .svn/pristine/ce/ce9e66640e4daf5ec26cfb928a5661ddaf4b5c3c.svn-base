//
//  RYGPayTypeTableViewCell.m
//  shoumila
//
//  Created by 阴～ on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPayTypeTableViewCell.h"

@implementation RYGPayTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self createPayTypeCell];
}

- (void)createPayTypeCell {
    _paywayImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 36, 36)];
    [self.contentView addSubview:_paywayImage];
    
    _paywayLabel = [[UILabel alloc]initWithFrame:CGRectMake(66, 10, 100, 20)];
    _paywayLabel.textColor = ColorName;
    _paywayLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_paywayLabel];
    
    _paywayTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(66, 30, 200, 15)];
    _paywayTipsLabel.textColor = ColorRankMedal;
    _paywayTipsLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_paywayTipsLabel];
    
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(SCREEN_WIDTH-37, 17, 22, 22);
    [self.contentView addSubview:_selectButton];
}

@end
