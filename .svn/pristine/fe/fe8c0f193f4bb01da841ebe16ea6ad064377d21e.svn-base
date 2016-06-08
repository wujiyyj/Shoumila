//
//  RYGPersonPackageViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPersonPackageViewController.h"
#import "RYGAllListParam.h"
#import "RYGSubScribeParam.h"
#import "RYGHttpRequest.h"
#import "RYGPackageDetailModel.h"
#import "RYGPackageBoughtModel.h"
#import "RYGOrderDetailViewController.h"

#import "RYGGrandeMarkView.h"
#import "RYGWeekRecommendView.h"
#import "UIImageView+RYGWebCache.h"

#define BuyPackageTableViewCell_Top_Magin  15
#define BuyPackageTableViewCell_Left_Magin  15
#define BuyPackageTableViewCell_Name_Left_Magin  10
#define BuyPackageTableViewCell_Right_Magin 15

@interface RYGPersonPackageViewController ()
{
    UIView* packageView;
}

@property (nonatomic,strong)    RYGPackageDetailModel* packageDetailModel;

@property(nonatomic,strong)     RYGPackageBoughtModel *packageBoughtModel;

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
@property(nonatomic,strong) RYGGrandeMarkView *grandMarkView;
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

@implementation RYGPersonPackageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    [MobClick beginLogPageView:@"TA的私人套餐"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"TA的私人套餐"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"TA的私人套餐";
    
    [self loadNewData];
}

- (void)loadNewData {
    RYGAllListParam *listParam = [RYGAllListParam param];
    listParam.userid = _userid;
    [RYGHttpRequest postWithURL:Package_Detail params:listParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        
        
        if (dic.count) {
            
            if ([[dic valueForKey:@"type"] intValue] == 2) {
                _packageDetailModel = [RYGPackageDetailModel objectWithKeyValues:dic];
                self.navigationItem.title = [NSString stringWithFormat:@"%@的私人套餐",_packageDetailModel.user_name];
                
                [self createMainView];
            }
            else if ([[dic valueForKey:@"type"] intValue] == 1) {
                
                _packageBoughtModel = [RYGPackageBoughtModel objectWithKeyValues:dic];
                self.navigationItem.title = [NSString stringWithFormat:@"%@的私人套餐",[_packageBoughtModel.user valueForKey:@"user_name"]];
                
                [self createPackageView];
            }
            
        }
        else {
            [self createEmptyView];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createEmptyView{
    UIImageView* emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 148, 85, 58)];
    emptyImageView.centerX = SCREEN_WIDTH/2;
    emptyImageView.image = [UIImage imageNamed:@"user_personEmpty"];
    [self.view addSubview:emptyImageView];
    
    UILabel* emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 246, 200, 20)];
    emptyLabel.centerX = SCREEN_WIDTH/2;
    emptyLabel.text = @"TA没有开通私人套餐";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = ColorSecondTitle;
    emptyLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:emptyLabel];
}

- (void)createMainView {
    UIView* whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 310)];
    whiteView.backgroundColor = ColorRankBackground;
    [self.view addSubview:whiteView];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, whiteView.height-0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = ColorLine;
    [whiteView addSubview:lineView];
    
    UILabel* bigNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, 120, 50)];
    bigNumLabel.text = _packageDetailModel.target_win_rate;
    bigNumLabel.centerX = SCREEN_WIDTH/2-30;
    bigNumLabel.textAlignment = NSTextAlignmentRight;
    bigNumLabel.font = [UIFont systemFontOfSize:68];
    bigNumLabel.textColor = ColorRateTitle;
    [whiteView addSubview:bigNumLabel];
    
    UILabel* percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 80, 30, 22)];
    percentLabel.text = @"％";
    percentLabel.font = [UIFont systemFontOfSize:20];
    percentLabel.textColor = ColorRateTitle;
    [whiteView addSubview:percentLabel];
    
    UILabel* wantRateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 105, 100, 20)];
    wantRateLabel.text = @"目标胜率";
    wantRateLabel.centerX = SCREEN_WIDTH/2;
    wantRateLabel.font = [UIFont systemFontOfSize:17];
    wantRateLabel.textColor = ColorWantRate;
    [whiteView addSubview:wantRateLabel];
    
    //限定场次
    UILabel* xdcc_label = [self createLabelFrame:CGRectMake(35, 155, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"限定场次"];
    [whiteView addSubview:xdcc_label];
    UILabel* xdcc_num = [self createLabelFrame:CGRectMake(35, 175, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:15] withColor:ColorName withText:[NSString stringWithFormat:@"%@场",_packageDetailModel.matches]];
    [whiteView addSubview:xdcc_num];
    
    //需要净胜
    UILabel* xyjs_label = [self createLabelFrame:CGRectMake(35, 155, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"需要净胜"];
    xyjs_label.centerX = SCREEN_WIDTH/2;
    [whiteView addSubview:xyjs_label];
    UILabel* xyjs_num = [self createLabelFrame:CGRectMake(35, 175, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:15] withColor:ColorName withText:[NSString stringWithFormat:@"%@场",_packageDetailModel.target_win]];
    xyjs_num.centerX = SCREEN_WIDTH/2;
    [whiteView addSubview:xyjs_num];
    
    //服务期限
    UILabel* fwqx_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-85, 155, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"服务期限"];
    [whiteView addSubview:fwqx_label];
    UILabel* fwqx_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-85, 175, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:15] withColor:ColorName withText:[NSString stringWithFormat:@"%@天",_packageDetailModel.service_term]];
    [whiteView addSubview:fwqx_num];
    
    UIView* middlelineView = [[UIView alloc]initWithFrame:CGRectMake(58, 200, SCREEN_WIDTH-116, 1)];
    middlelineView.backgroundColor = ColorLine;
    [whiteView addSubview:middlelineView];
    
    UIView* circle_front_view = [[UIView alloc]initWithFrame:CGRectMake(35, 200, 10, 10)];
    circle_front_view.backgroundColor = ColorLine;
    circle_front_view.layer.cornerRadius = 5;
    circle_front_view.center = CGPointMake(58, 200);
    [whiteView addSubview:circle_front_view];
    
    UIView* circle_middle_view = [[UIView alloc]initWithFrame:CGRectMake(35, 200, 10, 10)];
    circle_middle_view.backgroundColor = ColorLine;
    circle_middle_view.layer.cornerRadius = 5;
    circle_middle_view.center = CGPointMake(SCREEN_WIDTH/2, 200);
    [whiteView addSubview:circle_middle_view];
    
    UIView* circle_back_view = [[UIView alloc]initWithFrame:CGRectMake(35, 200, 10, 10)];
    circle_back_view.backgroundColor = ColorLine;
    circle_back_view.layer.cornerRadius = 5;
    circle_back_view.center = CGPointMake(SCREEN_WIDTH-58, 200);
    [whiteView addSubview:circle_back_view];
    
    UIButton* subScribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    subScribeButton.frame = CGRectMake(0, 0, 160, 160);
    subScribeButton.center = CGPointMake(SCREEN_WIDTH/2, 310);
    subScribeButton.layer.cornerRadius = 80;
    [subScribeButton setTitle:[NSString stringWithFormat:@"订阅\n%@元",_packageDetailModel.fee] forState:UIControlStateNormal];
    [subScribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subScribeButton setBackgroundColor:ColorRateTitle];
    [subScribeButton addTarget:self action:@selector(gotoSubScribe) forControlEvents:UIControlEventTouchUpInside];
    subScribeButton.titleLabel.font = [UIFont systemFontOfSize:24];
    subScribeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    subScribeButton.titleLabel.numberOfLines = 0;
    [self.view addSubview:subScribeButton];
    
    //tips
    UILabel* tipslabel = [self createLabelFrame:CGRectMake(25, 410, SCREEN_WIDTH-50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:13] withColor:ColorRankMedal withText:@"温馨提示：每周为7天，每月为30天"];
    [self.view addSubview:tipslabel];
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

- (void)gotoSubScribe {
    RYGSubScribeParam *subscribeParam = [RYGSubScribeParam param];
    subscribeParam.package_id = _packageDetailModel.id;
    subscribeParam.userid = _packageDetailModel.userid;
    [RYGHttpRequest postWithURL:Package_Subscribe params:subscribeParam.keyValues success:^(id json) {
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            //订阅成功
            
            RYGOrderDetailViewController* orderDetailVC = [[RYGOrderDetailViewController alloc]init];
            orderDetailVC.order_no = [[json valueForKey:@"data"] valueForKey:@"order_no"];
            [self.navigationController pushViewController:orderDetailVC animated:YES];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createPackageView {
    packageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 188)];
    packageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:packageView];
    
    UIView* toplineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    toplineView.backgroundColor = ColorLine;
    [packageView addSubview:toplineView];
    
    UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 187.5, SCREEN_WIDTH, 0.5)];
    bottomlineView.backgroundColor = ColorLine;
    [packageView addSubview:bottomlineView];
    
    [self createBuyPackageCell];
}

- (void)createBuyPackageCell {
    
    //标签
    _tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 0, 45, 45)];
    [packageView addSubview:_tipImageView];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 8, 45, 20)];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:10];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.transform = CGAffineTransformMakeRotation(45*M_PI/180);
    [packageView addSubview:_tipLabel];
    
    // 头像
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BuyPackageTableViewCell_Left_Magin, BuyPackageTableViewCell_Top_Magin, 50, 50)];
    _userLogoImageView.layer.cornerRadius = 4;
    _userLogoImageView.layer.masksToBounds = YES;
    _userLogoImageView.backgroundColor = ColorRankMyRankBackground;
    // 头像
    //    _userLogoImageView.image = [UIImage imageNamed:@"user_data"];
    [packageView addSubview:_userLogoImageView];
    
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
    [packageView addSubview:_infoUserName];
    
    // 等级标志
    _grandMarkView = [[RYGGrandeMarkView alloc]init];
    _grandMarkView.frame = CGRectMake(CGRectGetMaxX(_infoUserName.frame), CGRectGetMinY(_infoUserName.frame), 60, 15);
    //    _grandMarkView.integralRank = @"20";
    [packageView addSubview:_grandMarkView];
    
    // 已推荐/限定场次
    CGSize recommendWinTitleSize = RYG_TEXTSIZE(@"已推荐/限定场次", [UIFont systemFontOfSize:10]);
    _infoRecommendWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + BuyPackageTableViewCell_Name_Left_Magin, 35, recommendWinTitleSize.width, recommendWinTitleSize.height)];
    _infoRecommendWinTitle.font = [UIFont systemFontOfSize:10];
    _infoRecommendWinTitle.textColor = ColorSecondTitle;
    _infoRecommendWinTitle.textAlignment = NSTextAlignmentLeft;
    _infoRecommendWinTitle.text = @"已推荐/限定场次";
    [packageView addSubview:_infoRecommendWinTitle];
    
    CGSize weekRecommendViewSize = RYG_TEXTSIZE(@"28", [UIFont systemFontOfSize:14]);
    //
    _xdccRecommendView = [[RYGWeekRecommendView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame) + BuyPackageTableViewCell_Name_Left_Magin + 3, 50, _infoRecommendWinTitle.width, weekRecommendViewSize.height) smallFontSize:10 largeFontSize:14 recommendWinGamesColor:ColorRateTitle recommendGamesFontColor:ColorName];
    //    [_xdccRecommendView setRecommendWinGames:@"65" recommendGames:@"86"];
    [packageView addSubview:_xdccRecommendView];
    
    UIView* line_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_infoRecommendWinTitle.frame)+10, 40, 0.5, 25)];
    line_vertical_View.backgroundColor = ColorLine;
    [packageView addSubview:line_vertical_View];
    
    //当前净胜
    CGSize dqzsTitleSize = RYG_TEXTSIZE(@"当前净胜", [UIFont systemFontOfSize:10]);
    UILabel *dqjsWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 35, dqzsTitleSize.width, dqzsTitleSize.height)];
    dqjsWinTitle.font = [UIFont systemFontOfSize:10];
    dqjsWinTitle.textColor = ColorSecondTitle;
    dqjsWinTitle.textAlignment = NSTextAlignmentCenter;
    dqjsWinTitle.text = @"当前净胜";
    [packageView addSubview:dqjsWinTitle];
    
    _dqjsWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 53, dqjsWinTitle.width, dqzsTitleSize.height)];
    _dqjsWinData.font = [UIFont systemFontOfSize:14];
    _dqjsWinData.textColor = ColorRateTitle;
    _dqjsWinData.textAlignment = NSTextAlignmentCenter;
    //    _dqjsWinData.text = @"25场";
    [packageView addSubview:_dqjsWinData];
    
    UIView* line2_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dqjsWinTitle.frame)+10, 40, 0.5, 25)];
    line2_vertical_View.backgroundColor = ColorLine;
    [packageView addSubview:line2_vertical_View];
    
    //当前胜率
    CGSize dqslTitleSize = RYG_TEXTSIZE(@"当前胜率", [UIFont systemFontOfSize:10]);
    UILabel *dqslWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 35, dqzsTitleSize.width, dqzsTitleSize.height)];
    dqslWinTitle.font = [UIFont systemFontOfSize:10];
    dqslWinTitle.textColor = ColorSecondTitle;
    dqslWinTitle.textAlignment = NSTextAlignmentCenter;
    dqslWinTitle.text = @"当前胜率";
    [packageView addSubview:dqslWinTitle];
    
    _dqslWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2_vertical_View.frame) + BuyPackageTableViewCell_Name_Left_Magin, 53, dqslWinTitle.width, dqslTitleSize.height)];
    _dqslWinData.font = [UIFont systemFontOfSize:14];
    _dqslWinData.textColor = ColorRateTitle;
    _dqslWinData.textAlignment = NSTextAlignmentCenter;
    //    _dqslWinData.text = @"75%";
    [packageView addSubview:_dqslWinData];
    
    //已运行天数
    _yyxtsView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_userLogoImageView.frame) +15, SCREEN_WIDTH-30, 15)];
    _yyxtsView.backgroundColor = [UIColor colorWithHexadecimal:@"#e0e0e0"];
    [packageView addSubview:_yyxtsView];
    
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
    [packageView addSubview:xdccWinTitle];
    
    _xdccWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(xdccWinTitle.frame), CGRectGetMaxY(xdccWinTitle.frame) + 5, xdccWinTitle.width, xdccWinTitle.height)];
    _xdccWinData.font = [UIFont systemFontOfSize:12];
    _xdccWinData.textColor = ColorName;
    _xdccWinData.textAlignment = NSTextAlignmentCenter;
    //    _xdccWinData.text = @"86场";
    [packageView addSubview:_xdccWinData];
    
    UIView* line_middle_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(xdccWinTitle.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 17, 0.5, 30)];
    line_middle_View.backgroundColor = ColorLine;
    [packageView addSubview:line_middle_View];
    
    //目标胜率
    CGSize mbslTitleSize = RYG_TEXTSIZE(@"目标胜率", [UIFont systemFontOfSize:10]);
    UILabel *mbslWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line_middle_View.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 15, mbslTitleSize.width, mbslTitleSize.height)];
    mbslWinTitle.font = [UIFont systemFontOfSize:10];
    mbslWinTitle.textColor = ColorSecondTitle;
    mbslWinTitle.textAlignment = NSTextAlignmentCenter;
    mbslWinTitle.text = @"目标胜率";
    [packageView addSubview:mbslWinTitle];
    
    _mbslWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(mbslWinTitle.frame), CGRectGetMaxY(mbslWinTitle.frame) + 5, mbslWinTitle.width, mbslWinTitle.height)];
    _mbslWinData.font = [UIFont systemFontOfSize:12];
    _mbslWinData.textColor = ColorName;
    _mbslWinData.textAlignment = NSTextAlignmentCenter;
    //    _mbslWinData.text = @"90%";
    [packageView addSubview:_mbslWinData];
    
    UIView* line2_middle_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mbslWinTitle.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 17, 0.5, 30)];
    line2_middle_View.backgroundColor = ColorLine;
    [packageView addSubview:line2_middle_View];
    
    //目标净胜
    CGSize mbjsTitleSize = RYG_TEXTSIZE(@"目标净胜", [UIFont systemFontOfSize:10]);
    UILabel *mbjsWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2_middle_View.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 15, mbjsTitleSize.width, mbjsTitleSize.height)];
    mbjsWinTitle.font = [UIFont systemFontOfSize:10];
    mbjsWinTitle.textColor = ColorSecondTitle;
    mbjsWinTitle.textAlignment = NSTextAlignmentCenter;
    mbjsWinTitle.text = @"目标净胜";
    [packageView addSubview:mbjsWinTitle];
    
    _mbjsWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(mbjsWinTitle.frame), CGRectGetMaxY(mbjsWinTitle.frame) + 5, mbjsWinTitle.width, mbjsWinTitle.height)];
    _mbjsWinData.font = [UIFont systemFontOfSize:12];
    _mbjsWinData.textColor = ColorName;
    _mbjsWinData.textAlignment = NSTextAlignmentCenter;
    //    _mbjsWinData.text = @"39场";
    [packageView addSubview:_mbjsWinData];
    
    UIView* line3_middle_View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mbjsWinTitle.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 17, 0.5, 30)];
    line3_middle_View.backgroundColor = ColorLine;
    [packageView addSubview:line3_middle_View];
    
    //服务期限
    CGSize fwqxTitleSize = RYG_TEXTSIZE(@"服务期限", [UIFont systemFontOfSize:10]);
    UILabel *fwqxWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line3_middle_View.frame)+8, CGRectGetMaxY(_yyxtsView.frame) + 15, fwqxTitleSize.width, fwqxTitleSize.height)];
    fwqxWinTitle.font = [UIFont systemFontOfSize:10];
    fwqxWinTitle.textColor = ColorSecondTitle;
    fwqxWinTitle.textAlignment = NSTextAlignmentCenter;
    fwqxWinTitle.text = @"服务期限";
    [packageView addSubview:fwqxWinTitle];
    
    _fwqxWinData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(fwqxWinTitle.frame), CGRectGetMaxY(fwqxWinTitle.frame) + 5, fwqxWinTitle.width, fwqxWinTitle.height)];
    _fwqxWinData.font = [UIFont systemFontOfSize:12];
    _fwqxWinData.textColor = ColorName;
    _fwqxWinData.textAlignment = NSTextAlignmentCenter;
    //    _fwqxWinData.text = @"30天";
    [packageView addSubview:_fwqxWinData];
    
    //订阅按钮
    _dyanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dyanButton.frame = CGRectMake(SCREEN_WIDTH-75, CGRectGetMaxY(_yyxtsView.frame) + 20, 60, 23);
    _dyanButton.layer.cornerRadius = 2;
    _dyanButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [packageView addSubview:_dyanButton];
    
    //申请退款
    _sqtkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sqtkButton.frame = CGRectMake(SCREEN_WIDTH-75, CGRectGetMaxY(_yyxtsView.frame) + 34, 60, 23);
    _sqtkButton.layer.cornerRadius = 2;
    _sqtkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _sqtkButton.hidden = YES;
    [packageView addSubview:_sqtkButton];
    
    UIView* line_tip_View = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_yyxtsView.frame) + 63, SCREEN_WIDTH-30, 0.5)];
    line_tip_View.backgroundColor = ColorLine;
    [packageView addSubview:line_tip_View];
    
    //下单时间
    _xdsjLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(line_tip_View.frame)+5, 145, 20)];
    _xdsjLabel.font = [UIFont systemFontOfSize:10];
    _xdsjLabel.textColor = ColorSecondTitle;
    _xdsjLabel.textAlignment = NSTextAlignmentLeft;
    //    _xdsjLabel.text = @"下单时间：05-04 12:15";
    [packageView addSubview:_xdsjLabel];
    
    //订单号
    _ddhLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160, CGRectGetMaxY(line_tip_View.frame)+5, 145, 20)];
    _ddhLabel.font = [UIFont systemFontOfSize:10];
    _ddhLabel.textColor = ColorSecondTitle;
    _ddhLabel.textAlignment = NSTextAlignmentRight;
    //    _ddhLabel.text = @"订单号：x0837419473622";
    [packageView addSubview:_ddhLabel];
    
    
    //运行中
    _tipImageView.image = [UIImage imageNamed:@"tips_running"];
    _tipLabel.text = @"进行中";
    [_dyanButton setBackgroundColor:ColorLine];
    [_dyanButton setTitle:@"已订阅" forState:UIControlStateNormal];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
