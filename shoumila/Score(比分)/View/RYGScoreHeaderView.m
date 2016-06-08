//
//  RYGScoreHeaderView.m
//  shoumila
//
//  Created by 贾磊 on 15/8/25.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGScoreHeaderView.h"
#import "RYGButton.h"
@implementation RYGScoreHeaderView{
    
    NSString *fTitle;
    NSString *fNum;
    BOOL    isSelect;
}


-(instancetype)initWithNum:(NSString *)num title:(NSString *)title{
    if (self = [super init]) {
        fTitle = title;
        fNum = num;
        self.backgroundColor = ColorRankMenuBackground;
        [self setUp];
    }
    return self;
}


- (void) setUp{

    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.frame = CGRectMake(8, 0, 35, 35);
    numLabel.text = fNum;
    numLabel.font = [UIFont systemFontOfSize:27];
    numLabel.textColor = [UIColor whiteColor];
    [numLabel sizeToFit];
    [self addSubview:numLabel];
    
    UILabel *numNameLabel = [[UILabel alloc]init];
    numNameLabel.frame = CGRectMake(CGRectGetMaxX(numLabel.frame)+4, 0, 33, 33);
    numNameLabel.text = @"场比赛今天";
    numNameLabel.numberOfLines = 2;
    numNameLabel.font = [UIFont systemFontOfSize:10];
    numNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:numNameLabel];
    
    _titleBtn = [[RYGButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
    
    [_titleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleBtn.frame), SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor blackColor];
    line.alpha = 0.3;
    [self addSubview:line];
    
    float y = CGRectGetMaxY(line.frame);
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"对阵";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor whiteColor];
    CGSize size = [label1.text sizeWithFont:[UIFont systemFontOfSize:12]];
    label1.frame = CGRectMake(62*SCREEN_SCALE, y, size.width*SCREEN_SCALE, 25);
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"胜负平";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor whiteColor];
    size = [label2.text sizeWithFont:[UIFont systemFontOfSize:12]];
    label2.frame = CGRectMake(CGRectGetMaxX(label1.frame)+40*SCREEN_SCALE, y, size.width*SCREEN_SCALE, 25);
    [self addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"全场让球";
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = [UIColor whiteColor];
    size = [label3.text sizeWithFont:[UIFont systemFontOfSize:12]];
    label3.frame = CGRectMake(CGRectGetMaxX(label2.frame)+35*SCREEN_SCALE, y, size.width*SCREEN_SCALE, 25);
    [self addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"全场大小";
    label4.font = [UIFont systemFontOfSize:12];
    label4.textColor = [UIColor whiteColor];
    size = [label4.text sizeWithFont:[UIFont systemFontOfSize:12]];
    label4.frame = CGRectMake(CGRectGetMaxX(label3.frame)+25*SCREEN_SCALE, y, size.width*SCREEN_SCALE, 25);
    [self addSubview:label4];
}

-(void)btnClick:(UIButton *)btn{
    isSelect = !isSelect;
    if (_btnClickBlock) {
        _btnClickBlock(isSelect);
    }
}
@end
