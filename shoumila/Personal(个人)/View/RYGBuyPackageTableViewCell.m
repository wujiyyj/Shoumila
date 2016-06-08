//
//  RYGBuyPackageTableViewCell.m
//  shoumila
//
//  Created by 阴～ on 15/8/16.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBuyPackageTableViewCell.h"
#import "RYGGrandeMarkView.h"
#import "RYGWeekRecommendView.h"
#import "UIImageView+RYGWebCache.h"

#define BuyPackageTableViewCell_Top_Magin  15
#define BuyPackageTableViewCell_Left_Magin  15
#define BuyPackageTableViewCell_Name_Left_Magin  10
#define BuyPackageTableViewCell_Right_Magin 15

@interface RYGBuyPackageTableViewCell ()

//标签
@property(nonatomic,strong)UIImageView* tipImageView;
@property(nonatomic,strong)UILabel* tipLabel;
// 头像
@property(nonatomic,strong)UIImageView *userLogoImageView;
//价格
@property(nonatomic,strong)UILabel *packagePrice;
// 用户名
@property(nonatomic,strong)UILabel *infoUserName;
// 等级标志
@property(nonatomic,strong)RYGGrandeMarkView *grandMarkView;
// 已推荐/限定场次
@property(nonatomic,strong) UILabel *infoRecommendWinTitle;
@property(nonatomic,strong) RYGWeekRecommendView *xdccRecommendView;
// 当前净胜
@property(nonatomic,strong) UILabel *dqjsWinData;
// 当前胜率
@property(nonatomic,strong) UILabel *dqslWinData;
//已运行天数
@property(nonatomic,strong) UIView *yyxtsView;
//已运行天数
@property(nonatomic,strong) UILabel *yyxtsLabel;
//已运行天数
@property(nonatomic,strong) UIProgressView *pro1;
//限定场次
@property(nonatomic,strong) UILabel *xdccWinData;
//目标胜率
@property(nonatomic,strong) UILabel *mbslWinData;
//目标净胜
@property(nonatomic,strong) UILabel *mbjsWinData;
//服务期限
@property(nonatomic,strong) UILabel *fwqxWinData;
//订阅按钮
@property(nonatomic,strong) UIButton *dyanButton;
//申请退款
@property(nonatomic,strong) UIButton *sqtkButton;
//下单时间
@property(nonatomic,strong) UILabel *xdsjLabel;
//订单号
@property(nonatomic,strong) UILabel *ddhLabel;

@end

@implementation RYGBuyPackageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createBuyPackageCell];
    }
    return self;
}

- (void)createBuyPackageCell {
    
    //标签
    _tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 0, 45, 45)];
    [self.contentView addSubview:_tipImageView];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 8, 45, 20)];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:10];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.transform = CGAffineTransformMakeRotation(45*M_PI/180);
    [self.contentView addSubview:_tipLabel];
    
    // 头像
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BuyPackageTableViewCell_Left_Magin, BuyPackageTableViewCell_Top_Magin, 50, 50)];
    _userLogoImageView.layer.cornerRadius = 4;
    _userLogoImageView.layer.masksToBounds = YES;
    _userLogoImageView.backgroundColor = ColorRankMyRankBackground;
    // 头像
//    _userLogoImageView.image = [UIImage imageNamed:@"user_data"];
    [self.contentView addSubview:_userLogoImageView];
    
    UIView* priceView = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 50, 15)];
    priceView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [_userLogoImageView addSubview:priceView];
    
    _packagePrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 50, 15)];
    _packagePrice.textColor = [UIColor whiteColor];
    _packagePrice.textAlignment = NSTextAlignmentCenter;
    _packagePrice.font = [UIFont systemFontOfSize:11];
    [_userLogoImageView addSubview:_packagePrice];
    
    // 用户名
    _infoUserName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + BuyPackageTableViewCell_Name_Left_Magin, BuyPackageTableViewCell_Top_Magin, 60, 13)];
    _infoUserName.lineBreakMode = NSLineBreakByTruncatingTail;
    _infoUserName.font = [UIFont boldSystemFontOfSize:13];
    _infoUserName.textColor = ColorName;
//    _infoUserName.text = @"阿苏林";
    _infoUserName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_infoUserName];
    
    // 等级标志
    _grandMarkView = [[RYGGrandeMarkView alloc]init];
    _grandMarkView.frame = CGRectMake(CGRectGetMaxX(_infoUserName.frame), CGRectGetMinY(_infoUserName.frame), 60, 15);
//    _grandMarkView.integralRank = @"20";
    [self.contentView addSubview:_grandMarkView];
    
    // 已推荐/限定场次
    CGSize recommendWinTitleSize = RYG_TEXTSIZE(@"已推荐/限定场次", [UIFont systemFontOfSize:10]);
    _infoRecommendWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + BuyPackageTableViewCell_Name_Left_Magin, 35, recommendWinTitleSize.width, recommendWinTitleSize.height)];
    _infoRecommendWinTitle.font = [UIFont systemFontOfSize:10];
    _infoRecommendWinTitle.textColor = ColorSecondTitle;
    _infoRecommendWinTitle.textAlignment = NSTextAlignmentLeft;
    _infoRecommendWinTitle.text = @"已推荐/限定场次";
    [self.contentView addSubview:_infoRecommendWinTitle];
    
    CGSize weekRecommendViewSize = RYG_TEXTSIZE(@"28", [UIFont systemFontOfSize:14]);
    //
    _xdccRecommendView = [[RYGWeekRecommendView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + BuyPackageTableViewCell_Name_Left_Magin + 3, 50, _infoRecommendWinTitle.width, weekRecommendViewSize.height) smallFontSize:10 largeFontSize:14 recommendWinGamesColor:ColorRateTitle recommendGamesFontColor:ColorName];
//    [_xdccRecommendView setRecommendWinGames:@"65" recommendGames:@"86"];
    [self.contentView addSubview:_xdccRecommendView];
    
    UIView* line_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_infoRecommendWinTitle.frame)+10, 40, 0.5, 25)];
    line_vertical_View.backgroundColor = ColorLine;
    [self.contentView addSubview:line_vertical_View];
    
    //当前净胜
    CGSize dqzsTitleSize = RYG_TEXTSIZE(@"当前净胜", [UIFont systemFontOfSize:10]);
    UILabel *dqjsWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 35, dqzsTitleSize.width, dqzsTitleSize.height)];
    dqjsWinTitle.font = [UIFont systemFontOfSize:10];
    dqjsWinTitle.textColor = ColorSecondTitle;
    dqjsWinTitle.textAlignment = NSTextAlignmentCenter;
    dqjsWinTitle.text = @"当前净胜";
    [self.contentView addSubview:dqjsWinTitle];
    
    _dqjsWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 53, dqjsWinTitle.width, dqzsTitleSize.height)];
    _dqjsWinData.font = [UIFont systemFontOfSize:14];
    _dqjsWinData.textColor = ColorRateTitle;
    _dqjsWinData.textAlignment = NSTextAlignmentCenter;
//    _dqjsWinData.text = @"25场";
    [self.contentView addSubview:_dqjsWinData];
    
    UIView* line2_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dqjsWinTitle.frame)+10, 40, 0.5, 25)];
    line2_vertical_View.backgroundColor = ColorLine;
    [self.contentView addSubview:line2_vertical_View];
    
    //当前胜率
    CGSize dqslTitleSize = RYG_TEXTSIZE(@"当前胜率", [UIFont systemFontOfSize:10]);
    UILabel *dqslWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 35, dqzsTitleSize.width, dqzsTitleSize.height)];
    dqslWinTitle.font = [UIFont systemFontOfSize:10];
    dqslWinTitle.textColor = ColorSecondTitle;
    dqslWinTitle.textAlignment = NSTextAlignmentCenter;
    dqslWinTitle.text = @"当前胜率";
    [self.contentView addSubview:dqslWinTitle];
    
    _dqslWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 53, dqslWinTitle.width, dqslTitleSize.height)];
    _dqslWinData.font = [UIFont systemFontOfSize:14];
    _dqslWinData.textColor = ColorRateTitle;
    _dqslWinData.textAlignment = NSTextAlignmentCenter;
//    _dqslWinData.text = @"75%";
    [self.contentView addSubview:_dqslWinData];
    
    //已运行天数
    _yyxtsView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_userLogoImageView.frame) +15, SCREEN_WIDTH-30, 15)];
    _yyxtsView.backgroundColor = [UIColor colorWithHexadecimal:@"#e0e0e0"];
    [self.contentView addSubview:_yyxtsView];
    
    //已运行天数
    _yyxtsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 15)];
    _yyxtsLabel.textAlignment = NSTextAlignmentLeft;
    _yyxtsLabel.textColor = ColorName;
    _yyxtsLabel.font = [UIFont systemFontOfSize:10];
    _yyxtsLabel.backgroundColor = [UIColor clearColor];
    [_yyxtsView addSubview:_yyxtsLabel];
    
    //进度条
    _pro1=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    _pro1.userInteractionEnabled = NO;
    _pro1.frame=CGRectMake(80, 6, SCREEN_WIDTH-130, 20);
    //设置进度条颜色
    _pro1.trackTintColor = ColorAttionunTitle;
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
//    _pro1.progress = 0.7;
    //设置进度条上进度的颜色
    _pro1.progressTintColor = ColorRateTitle;
    [_yyxtsView addSubview:_pro1];
    
    //限定场次
    CGSize xdccTitleSize = RYG_TEXTSIZE(@"限定场次", [UIFont systemFontOfSize:10]);
    UILabel *xdccWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_yyxtsView.frame) + 15, xdccTitleSize.width, xdccTitleSize.height)];
    xdccWinTitle.font = [UIFont systemFontOfSize:10];
    xdccWinTitle.textColor = ColorSecondTitle;
    xdccWinTitle.textAlignment = NSTextAlignmentCenter;
    xdccWinTitle.text = @"限定场次";
    [self.contentView addSubview:xdccWinTitle];
    
    _xdccWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(xdccWinTitle.frame), CGRectGetMaxY(xdccWinTitle.frame) + 5, xdccWinTitle.width, xdccWinTitle.height)];
    _xdccWinData.font = [UIFont systemFontOfSize:12];
    _xdccWinData.textColor = ColorName;
    _xdccWinData.textAlignment = NSTextAlignmentCenter;
//    _xdccWinData.text = @"86场";
    [self.contentView addSubview:_xdccWinData];
    
    UIView* line_middle_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(xdccWinTitle.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 17, 0.5, 30)];
    line_middle_View.backgroundColor = ColorLine;
    [self.contentView addSubview:line_middle_View];
    
    //目标胜率
    CGSize mbslTitleSize = RYG_TEXTSIZE(@"目标胜率", [UIFont systemFontOfSize:10]);
    UILabel *mbslWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line_middle_View.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 15, mbslTitleSize.width, mbslTitleSize.height)];
    mbslWinTitle.font = [UIFont systemFontOfSize:10];
    mbslWinTitle.textColor = ColorSecondTitle;
    mbslWinTitle.textAlignment = NSTextAlignmentCenter;
    mbslWinTitle.text = @"目标胜率";
    [self.contentView addSubview:mbslWinTitle];
    
    _mbslWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(mbslWinTitle.frame), CGRectGetMaxY(mbslWinTitle.frame) + 5, mbslWinTitle.width, mbslWinTitle.height)];
    _mbslWinData.font = [UIFont systemFontOfSize:12];
    _mbslWinData.textColor = ColorName;
    _mbslWinData.textAlignment = NSTextAlignmentCenter;
//    _mbslWinData.text = @"90%";
    [self.contentView addSubview:_mbslWinData];
    
    UIView* line2_middle_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mbslWinTitle.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 17, 0.5, 30)];
    line2_middle_View.backgroundColor = ColorLine;
    [self.contentView addSubview:line2_middle_View];
    
    //目标净胜
    CGSize mbjsTitleSize = RYG_TEXTSIZE(@"目标净胜", [UIFont systemFontOfSize:10]);
    UILabel *mbjsWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2_middle_View.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 15, mbjsTitleSize.width, mbjsTitleSize.height)];
    mbjsWinTitle.font = [UIFont systemFontOfSize:10];
    mbjsWinTitle.textColor = ColorSecondTitle;
    mbjsWinTitle.textAlignment = NSTextAlignmentCenter;
    mbjsWinTitle.text = @"目标净胜";
    [self.contentView addSubview:mbjsWinTitle];
    
    _mbjsWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(mbjsWinTitle.frame), CGRectGetMaxY(mbjsWinTitle.frame) + 5, mbjsWinTitle.width, mbjsWinTitle.height)];
    _mbjsWinData.font = [UIFont systemFontOfSize:12];
    _mbjsWinData.textColor = ColorName;
    _mbjsWinData.textAlignment = NSTextAlignmentCenter;
//    _mbjsWinData.text = @"39场";
    [self.contentView addSubview:_mbjsWinData];
    
    UIView* line3_middle_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mbjsWinTitle.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 17, 0.5, 30)];
    line3_middle_View.backgroundColor = ColorLine;
    [self.contentView addSubview:line3_middle_View];
    
    //服务期限
    CGSize fwqxTitleSize = RYG_TEXTSIZE(@"服务期限", [UIFont systemFontOfSize:10]);
    UILabel *fwqxWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line3_middle_View.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 15, fwqxTitleSize.width, fwqxTitleSize.height)];
    fwqxWinTitle.font = [UIFont systemFontOfSize:10];
    fwqxWinTitle.textColor = ColorSecondTitle;
    fwqxWinTitle.textAlignment = NSTextAlignmentCenter;
    fwqxWinTitle.text = @"服务期限";
    [self.contentView addSubview:fwqxWinTitle];
    
    _fwqxWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(fwqxWinTitle.frame), CGRectGetMaxY(fwqxWinTitle.frame) + 5, fwqxWinTitle.width, fwqxWinTitle.height)];
    _fwqxWinData.font = [UIFont systemFontOfSize:12];
    _fwqxWinData.textColor = ColorName;
    _fwqxWinData.textAlignment = NSTextAlignmentCenter;
//    _fwqxWinData.text = @"30天";
    [self.contentView addSubview:_fwqxWinData];
    
    //订阅按钮
    _dyanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dyanButton.frame = CGRectMake(SCREEN_WIDTH-75, CGRectGetMaxY(_yyxtsView.frame) + 20, 60, 23);
    _dyanButton.layer.cornerRadius = 2;
    _dyanButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_dyanButton];
    
    //申请退款
    _sqtkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sqtkButton.frame = CGRectMake(SCREEN_WIDTH-75, CGRectGetMaxY(_yyxtsView.frame) + 34, 60, 23);
    _sqtkButton.layer.cornerRadius = 2;
    _sqtkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _sqtkButton.hidden = YES;
    [self.contentView addSubview:_sqtkButton];
    
    UIView* line_tip_View = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_yyxtsView.frame) + 63, SCREEN_WIDTH-30, 0.5)];
    line_tip_View.backgroundColor = ColorLine;
    [self.contentView addSubview:line_tip_View];
    
    //下单时间
    _xdsjLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line_tip_View.frame)+5, 145, 20)];
    _xdsjLabel.font = [UIFont systemFontOfSize:10];
    _xdsjLabel.textColor = ColorSecondTitle;
    _xdsjLabel.textAlignment = NSTextAlignmentLeft;
//    _xdsjLabel.text = @"下单时间：05-04 12:15";
    [self.contentView addSubview:_xdsjLabel];
    
    //订单号
    _ddhLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160, CGRectGetMaxY(line_tip_View.frame)+5, 145, 20)];
    _ddhLabel.font = [UIFont systemFontOfSize:10];
    _ddhLabel.textColor = ColorSecondTitle;
    _ddhLabel.textAlignment = NSTextAlignmentRight;
//    _ddhLabel.text = @"订单号：x0837419473622";
    [self.contentView addSubview:_ddhLabel];
}

- (void)pressDYButton
{
    if ([self.delegate respondsToSelector:@selector(clickDYButton:)]) {
        [self.delegate clickDYButton:_packageBoughtModel.order_no];
    }
}

- (void)pressTKButton
{
    if ([self.delegate respondsToSelector:@selector(clickDYButton:)]) {
        [self.delegate clickTKButton:_packageBoughtModel.order_no];
    }
}

- (void)setPackageBoughtModel:(RYGPackageBoughtModel *)packageBoughtModel {
    _packageBoughtModel = packageBoughtModel;
    
    [self updateCell];
}

- (void)updateCell {
    if([_packageBoughtModel.status intValue] == 1) {
        //运行中
        _tipImageView.image = [UIImage imageNamed:@"tips_running"];
        _tipLabel.text = @"进行中";
        [_dyanButton setBackgroundColor:ColorLine];
        [_dyanButton setTitle:@"已订阅" forState:UIControlStateNormal];
    }
    else if([_packageBoughtModel.status intValue] == 2) {
        //成功
        _tipImageView.image = [UIImage imageNamed:@"tips_success"];
        _tipLabel.text = @"已成功";
        [_dyanButton setBackgroundColor:ColorRateTitle];
        [_dyanButton setTitle:@"继续订阅" forState:UIControlStateNormal];
        [_dyanButton addTarget:self action:@selector(pressDYButton) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([_packageBoughtModel.status intValue] == 3) {
        //未成功
        _tipImageView.image = [UIImage imageNamed:@"tips_unsuccess"];
        _tipLabel.text = @"未成功";
        
        _dyanButton.frame = CGRectMake(SCREEN_WIDTH-75, CGRectGetMaxY(_yyxtsView.frame) + 6, 60, 23);
        [_dyanButton setBackgroundColor:ColorRateTitle];
        [_dyanButton setTitle:@"继续订阅" forState:UIControlStateNormal];
        [_dyanButton addTarget:self action:@selector(pressDYButton) forControlEvents:UIControlEventTouchUpInside];
        
        _sqtkButton.hidden = NO;
        [_sqtkButton setBackgroundColor:ColorRankMedal];
        [_sqtkButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [_sqtkButton addTarget:self action:@selector(pressTKButton) forControlEvents:UIControlEventTouchUpInside];
    }
    [_userLogoImageView setImageURLStr:[_packageBoughtModel.user objectForKey:@"user_logo"] placeholder:nil];
    _infoUserName.text = [_packageBoughtModel.user objectForKey:@"user_name"];
    _grandMarkView.integralRank = [_packageBoughtModel.user objectForKey:@"grade"];
    [_xdccRecommendView setRecommendWinGames:_packageBoughtModel.recommended_num recommendGames:[_packageBoughtModel.package objectForKey:@"matches"]];
    _dqjsWinData.text = [NSString stringWithFormat:@"%@场",_packageBoughtModel.win_num];
    _dqslWinData.text = [NSString stringWithFormat:@"%@％",_packageBoughtModel.winrate];
    _xdccWinData.text = [NSString stringWithFormat:@"%@场",[_packageBoughtModel.package objectForKey:@"matches"]];
    _mbslWinData.text = [NSString stringWithFormat:@"%@％",[_packageBoughtModel.package objectForKey:@"target_winrate"]];
    _mbjsWinData.text = [NSString stringWithFormat:@"%@场",[_packageBoughtModel.package objectForKey:@"target_win"]];
    _fwqxWinData.text = [NSString stringWithFormat:@"%@天",[_packageBoughtModel.package objectForKey:@"service_term"]];
    _xdsjLabel.text = [NSString stringWithFormat:@"下单时间：%@",_packageBoughtModel.ctime];
    _ddhLabel.text = [NSString stringWithFormat:@"订单号：%@",_packageBoughtModel.order_no];
    _packagePrice.text = [NSString stringWithFormat:@"%d元",[_packageBoughtModel.fee intValue]];
    _yyxtsLabel.text = [NSString stringWithFormat:@"已经运行%@天",_packageBoughtModel.run_days];
    _pro1.progress = _packageBoughtModel.run_days.floatValue/[[_packageBoughtModel.package objectForKey:@"service_term"] floatValue];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
