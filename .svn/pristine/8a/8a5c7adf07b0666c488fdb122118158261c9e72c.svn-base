//
//  RYGDynamicRecommendTableViewCell.m
//  shoumila
//
//  Created by 贾磊 on 15/9/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicRecommendTableViewCell.h"

@interface RYGDynamicRecommendTableViewCell ()


@end
@implementation RYGDynamicRecommendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCommentView];
        [self setUpRecommendView];
        [self setUpBarView];
    }
    return self;
}

-(void)setUpRecommendView{
    RYGRecommendContentView *recommendContentView = [[RYGRecommendContentView alloc]init];
    _recommendContentView = recommendContentView;
    [self.contentView addSubview:recommendContentView];
}

-(void)setUpCommentView{
    RYGDynamicCommnetView *commentView = [[RYGDynamicCommnetView alloc]init];
    _commentView = commentView;
    [self addSubview:commentView];
}

-(void)setUpBarView{
    RYGBarView *barView = [[RYGBarView alloc]init];
    [self addSubview:barView];
    self.barView = barView;
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    _commentView.dynamicFrame = dynamicFrame;
    _recommendContentView.dynamicFrame = dynamicFrame;
    _barView.dynamicFrame = dynamicFrame;
}

@end
