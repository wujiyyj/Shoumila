//
//  RYGHotWordsCollectionViewCell.m
//  shoumila
//
//  Created by 贾磊 on 15/10/2.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGHotWordsCollectionViewCell.h"

@implementation RYGHotWordsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc]init];
        _title.layer.cornerRadius = 4;
        _title.layer.borderColor = ColorLine.CGColor;
        _title.layer.borderWidth = 1.0f;
        _title.textColor = ColorName;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_title];
    }
    return self;
}
@end
