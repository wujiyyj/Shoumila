//
//  RYGDynamicTableViewCell.m
//  shoumila
//
//  Created by 贾磊 on 15/9/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicTableViewCell.h"

@implementation RYGDynamicTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpContentView];
        [self setUpCommentView];
        [self setUpBarView];
        
    }
    return self;
}

-(void)setUpContentView{
    self.dynamicContentView = [[RYGDynamicContentView alloc]init];
    [self addSubview:self.dynamicContentView];
//    self.dynamicContentView = contentView;

}

-(void)setUpCommentView{
    RYGDynamicCommnetView *commentView = [[RYGDynamicCommnetView alloc]init];
    [self addSubview:commentView];
    self.commentView = commentView;
}

-(void)setUpBarView{
    RYGBarView *barView = [[RYGBarView alloc]init];
    [self addSubview:barView];
    self.barView = barView;
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    NSArray *subviews = [[NSArray alloc] initWithArray:self.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    _dynamicContentView.dynamicFrame = dynamicFrame;
    
    _commentView.dynamicFrame = dynamicFrame;
    _barView.dynamicFrame = dynamicFrame;
}
@end
