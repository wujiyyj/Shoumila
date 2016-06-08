//
//  RYGWinLoseTableViewCell.m
//  shoumila
//
//  Created by 阴～ on 16/4/10.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import "RYGWinLoseTableViewCell.h"
#import "RYGStringUtil.h"

#define LABEL_TEXT_SIZE 12

@interface RYGWinLoseTableViewCell ()

// 联赛
@property(nonatomic,strong)UILabel *leagues_label;
// 主客队
@property(nonatomic,strong)UILabel *htAndvt_label;
// 发布时间
@property(nonatomic,strong)UILabel *publishTime_label;
// 玩法
@property(nonatomic,strong)UILabel *rules_label;
// 类型
@property(nonatomic,strong)UILabel *type_label;
// 内容
@property(nonatomic,strong)UILabel *content_label;
// 结果
@property(nonatomic,strong)NSString *result;
//
@property(nonatomic,strong)UIImageView *resultImageView;
//
@property(nonatomic,strong)UILabel *result_label;

@end

@implementation RYGWinLoseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupCell];
    }
    return self;
}

// 初期化cell
- (void)setupCell {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topView.backgroundColor = ColorRankMyRankBackground;
    [self.contentView addSubview:topView];
    
    self.leagues_label = [self createLabelFrame:CGRectMake(15, 0, 40, 25) withAlignment:NSTextAlignmentLeft withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"德乙:"];
    [topView addSubview:self.leagues_label];
    
    self.htAndvt_label = [self createLabelFrame:CGRectMake(55, 0, 80, 25) withAlignment:NSTextAlignmentLeft withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"中国vs日本"];
    [topView addSubview:self.htAndvt_label];
    
    self.publishTime_label = [self createLabelFrame:CGRectMake(15, 15, 160, 25) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"发布时间:01月15日"];
    [topView addSubview:self.publishTime_label];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = ColorLine;
    [self.contentView addSubview:lineView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 78)];
    contentView.backgroundColor = ColorRankBackground;
    [self.contentView addSubview:contentView];
    
    UIImageView* ruleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 42, 20)];
    ruleImageView.backgroundColor = ColorAttionCanBackground;
    [contentView addSubview:ruleImageView];
    
    self.rules_label = [self createLabelFrame:CGRectMake(0, 0, 42, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:[UIColor whiteColor] withText:@"大小"];
    [ruleImageView addSubview:self.rules_label];
    
    self.type_label = [self createLabelFrame:CGRectMake(67, 15, 200, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:15] withColor:ColorName withText:@"赛前 - 全场让球"];
    [contentView addSubview:self.type_label];
    
    self.content_label = [self createLabelFrame:CGRectMake(15, 50, 200, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:14] withColor:ColorSecondTitle withText:@"布里斯班狮吼 +0 / 0.5 @0.94"];
    [contentView addSubview:self.content_label];
    
    self.resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 14, 50, 50)];
    self.resultImageView.hidden = NO;
    self.resultImageView.layer.cornerRadius = 25;
    self.resultImageView.backgroundColor = ColorRateTitle;
    [contentView addSubview:self.resultImageView];
    
    self.result_label = [self createLabelFrame:CGRectMake(0, 10, 50, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:18] withColor:[UIColor whiteColor] withText:@"赢"];
    [self.resultImageView addSubview:self.result_label];
    
    UIView* line_bottom_View = [[UIView alloc]initWithFrame:CGRectMake(0, 117.5, SCREEN_WIDTH, 0.5)];
    line_bottom_View.backgroundColor = ColorLine;
    [self.contentView addSubview:line_bottom_View];
    
}

// 根据数据重新设置cell单元格
- (void)setWinLosePersonModel:(RYGWinLosePersonModel *)winLosePersonModel {
    _winLosePersonModel = winLosePersonModel;
    [self updateCell];
}

- (void)updateCell {
    CGFloat leaguesLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@:",_winLosePersonModel.leagues] font:[UIFont systemFontOfSize:12] height:25];
    self.leagues_label.text = [NSString stringWithFormat:@"%@:",_winLosePersonModel.leagues];
    self.leagues_label.frame = CGRectMake(15, 0, leaguesLen, 25);
    
    CGFloat htAndvtLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@vs%@",_winLosePersonModel.ht,_winLosePersonModel.vt] font:[UIFont systemFontOfSize:12] height:25];
    self.htAndvt_label.text = [NSString stringWithFormat:@"%@vs%@",_winLosePersonModel.ht,_winLosePersonModel.vt];
    self.htAndvt_label.frame = CGRectMake(20+leaguesLen, 0, htAndvtLen, 25);
    
    CGFloat publishTimeLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"发布时间:%@",_winLosePersonModel.publish_time] font:[UIFont systemFontOfSize:12] height:25];
    self.publishTime_label.text = [NSString stringWithFormat:@"发布时间:%@",_winLosePersonModel.publish_time];
    self.publishTime_label.frame = CGRectMake(15, 15, publishTimeLen, 25);
    
    self.rules_label.text = [NSString stringWithFormat:@"%@",_winLosePersonModel.rules];
    
    CGFloat typeLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@",_winLosePersonModel.type] font:[UIFont systemFontOfSize:15] height:20];
    self.type_label.text = [NSString stringWithFormat:@"%@",_winLosePersonModel.type];
    self.type_label.frame = CGRectMake(67, 15, typeLen, 20);
    
    CGFloat contentLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@",_winLosePersonModel.content] font:[UIFont systemFontOfSize:14] height:20];
    self.content_label.text = [NSString stringWithFormat:@"%@",_winLosePersonModel.content];
    self.content_label.frame = CGRectMake(15, 50, contentLen, 20);
    
    self.result = _winLosePersonModel.result;
    if (self.result.intValue == 0) {
        //无结果
        self.resultImageView.hidden = YES;
    }
    else if (self.result.intValue == 1) {
        //输
        self.resultImageView.hidden = NO;
        self.resultImageView.backgroundColor = ColorRankMedal;
        self.result_label.text = @"输";
    }
    else if (self.result.intValue == 2) {
        //输半
        self.resultImageView.hidden = NO;
        self.resultImageView.backgroundColor = ColorRankMedal;
        self.result_label.text = @"输半";
    }
    else if (self.result.intValue == 3) {
        //走水
        self.resultImageView.hidden = NO;
        self.resultImageView.backgroundColor = ColorGreen;
        self.result_label.text = @"走水";
    }
    else if (self.result.intValue == 4) {
        //赢半
        self.resultImageView.hidden = NO;
        self.resultImageView.backgroundColor = ColorRateTitle;
        self.result_label.text = @"赢半";
    }
    else if (self.result.intValue == 5) {
        //赢
        self.resultImageView.hidden = NO;
        self.resultImageView.backgroundColor = ColorRateTitle;
        self.result_label.text = @"赢";
    }
    
}

-(UILabel*)createLabelFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment withFont:(UIFont*)font withColor:(UIColor*)color withText:(NSString*)text
{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.numberOfLines = 0;
    label.textColor = color;
    label.text = text;
    return label;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
