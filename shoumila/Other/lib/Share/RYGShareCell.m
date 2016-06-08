//
//  RYGShareCell.m
//  shoumila
//
//  Created by 阴～ on 15/9/15.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGShareCell.h"

@implementation RYGShareCell

-(void)setShareMode:(RYGShareModel *)shareMode{
    _shareMode = shareMode;
    _shareIcon = [[UIButton alloc]initWithFrame:CGRectMake(17, 0, 36, 36)];
    [_shareIcon setImage:[UIImage imageNamed:shareMode.iconName] forState:UIControlStateNormal];
//    [_shareIcon setImage:[UIImage imageNamed:shareMode.iconName_Sel] forState:UIControlStateHighlighted];
    [_shareIcon addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareIcon];
    _shareName = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, 70, 20)];
    _shareName.text = shareMode.shareName;
    _shareName.textColor = ColorSecondTitle;
    _shareName.textAlignment = NSTextAlignmentCenter;
    _shareName.font = [UIFont systemFontOfSize:12];
    [self addSubview:_shareName];
}

-(void)shareBtn{
    _ShareBlock(_shareMode);
}

@end
