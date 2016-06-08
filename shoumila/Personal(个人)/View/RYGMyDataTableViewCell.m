//
//  RYGMyDataTableViewCell.m
//  shoumila
//
//  Created by yinyujie on 15/7/31.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMyDataTableViewCell.h"
#import "RYGWeekRecommendView.h"
#import "AFCircleChart.h"
#import "RYGRadarChart.h"
#import "RYGBarChart.h"
#import "RYGLineChart.h"


@interface RYGMyDataTableViewCell ()
{
    UIView* dataView;
    UIView* weekView;
    UIView* monthView;
    UIView* ninetyView;
    
    NSInteger dataStyle;
}

//data
@property (nonatomic,strong) UILabel* bfwcs_num;
@property (nonatomic,strong) UILabel* hyts_num;
@property (nonatomic,strong) UILabel* hyjf_num;
@property (nonatomic,strong) UILabel* dz_num;
@property (nonatomic,strong) UILabel* hf_num;
@property (nonatomic,strong) UILabel* fx_num;
@property (nonatomic,strong) UILabel* fts_num;
@property (nonatomic,strong) UILabel* tjbs_num;
@property (nonatomic,strong) UILabel* yqs_num;

//week
// 推荐赢／周推荐
@property(nonatomic,strong) RYGWeekRecommendView *weekRecommendView;
// 胜率
@property (nonatomic,strong) AFCircleChart *w_winRateCircleChart;
// 利润率
@property (nonatomic,strong) AFCircleChart *w_profitRateCircleChart;
@property (nonatomic,strong) UILabel* w_ypsl_num;
@property (nonatomic,strong) UILabel* w_dxqsl_num;
@property (nonatomic,strong) UILabel* w_jcsl_num;
@property (nonatomic,strong) UILabel* w_pjtjsw_num;
@property (nonatomic,strong) UILabel* w_zglh_num;
@property (nonatomic,strong) UILabel* w_wdx_num;
@property (nonatomic,strong) RYGBarChart *w_chrt;
@property (nonatomic,strong) RYGRadarChart *w_p;
@property (nonatomic,strong) UILabel* w_winRateLabel;

//month
// 推荐赢／周推荐
@property(nonatomic,strong) RYGWeekRecommendView *monthRecommendView;
// 胜率
@property (nonatomic,strong) AFCircleChart *m_winRateCircleChart;
// 利润率
@property (nonatomic,strong) AFCircleChart *m_profitRateCircleChart;
@property (nonatomic,strong) UILabel* m_ypsl_num;
@property (nonatomic,strong) UILabel* m_dxqsl_num;
@property (nonatomic,strong) UILabel* m_jcsl_num;
@property (nonatomic,strong) UILabel* m_pjtjsw_num;
@property (nonatomic,strong) UILabel* m_zglh_num;
@property (nonatomic,strong) UILabel* m_wdx_num;
@property (nonatomic,strong) RYGLineChart* m_lineChart;
@property (nonatomic,strong) RYGRadarChart *m_p;
@property (nonatomic,strong) UILabel* m_allBunkoLabel;

//ninety
// 推荐赢／周推荐
@property(nonatomic,strong) RYGWeekRecommendView *ninetyRecommendView;
// 胜率
@property (nonatomic,strong) AFCircleChart *n_winRateCircleChart;
// 利润率
@property (nonatomic,strong) AFCircleChart *n_profitRateCircleChart;
@property (nonatomic,strong) UILabel* n_ypsl_num;
@property (nonatomic,strong) UILabel* n_dxqsl_num;
@property (nonatomic,strong) UILabel* n_jcsl_num;
@property (nonatomic,strong) UILabel* n_pjtjsw_num;
@property (nonatomic,strong) UILabel* n_zglh_num;
@property (nonatomic,strong) UILabel* n_wdx_num;
@property (nonatomic,strong) RYGLineChart* n_lineChart;
@property (nonatomic,strong) RYGRadarChart *n_p;
@property (nonatomic,strong) UILabel* n_allBunkoLabel;

@property (nonatomic,assign) NSInteger LABEL_TEXT_SIZE;

@end

@implementation RYGMyDataTableViewCell
@synthesize bfwcs_num;
@synthesize hyts_num;
@synthesize hyjf_num;
@synthesize dz_num;
@synthesize hf_num;
@synthesize fx_num;
@synthesize fts_num;
@synthesize tjbs_num;
@synthesize yqs_num;
@synthesize w_ypsl_num;
@synthesize w_dxqsl_num;
@synthesize w_jcsl_num;
@synthesize w_pjtjsw_num;
@synthesize w_zglh_num;
@synthesize w_wdx_num;
@synthesize w_winRateLabel;
@synthesize m_ypsl_num;
@synthesize m_dxqsl_num;
@synthesize m_jcsl_num;
@synthesize m_pjtjsw_num;
@synthesize m_zglh_num;
@synthesize m_wdx_num;
@synthesize m_allBunkoLabel;
@synthesize n_ypsl_num;
@synthesize n_dxqsl_num;
@synthesize n_jcsl_num;
@synthesize n_pjtjsw_num;
@synthesize n_zglh_num;
@synthesize n_wdx_num;
@synthesize n_allBunkoLabel;
@synthesize LABEL_TEXT_SIZE;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    dataStyle = 1;
//    [self setupCell];
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.height = 220;
        dataStyle = 1;
        
        if (SCREEN_WIDTH>=375) {
            LABEL_TEXT_SIZE = 12;
        }
        else {
            LABEL_TEXT_SIZE = 9;
        }
        //
        [self setupCell];
    }
    return self;
}

- (void)setupCell
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.contentView.height)];
    _scrollView.delegate = self;
    _scrollView.contentSize= CGSizeMake(SCREEN_WIDTH*4, self.contentView.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    [_pageControl setCurrentPage:0];
    _pageControl.numberOfPages = 4;//指定页面个数
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = ColorTabBarButtonTitleSelected;
    [self.contentView addSubview:_pageControl];
    
    [self initSubViews];
    
    UIView* line_View = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.height-0.5, SCREEN_WIDTH, 0.5)];
    line_View.backgroundColor = ColorLine;
    [_scrollView addSubview:line_View];
}

- (void)initSubViews
{
    dataView = [[UIView alloc] init];
    [dataView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height)];
    [dataView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:dataView];
    [self createDataView];
    
    weekView = [[UIView alloc]init];
    [weekView setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height)];
    [weekView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:weekView];
    [self createWeekView];
    
    monthView = [[UIView alloc]init];
    [monthView setFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, self.scrollView.height)];
    [monthView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:monthView];
    [self createMonthView];
    
    ninetyView = [[UIView alloc]init];
    [ninetyView setFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, self.scrollView.height)];
    [ninetyView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:ninetyView];
    [self createNinetyView];
}

- (void)createDataView
{
    UIView* line_1_vertical_1_View = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 25, 0.5, 35)];
    line_1_vertical_1_View.backgroundColor = ColorLine;
    [dataView addSubview:line_1_vertical_1_View];
    
    UIView* line_1_vertical_2_View = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 25, 0.5, 35)];
    line_1_vertical_2_View.backgroundColor = ColorLine;
    [dataView addSubview:line_1_vertical_2_View];
    
    UILabel* bfwcs_label = [self createLabelFrame:CGRectMake(0, 50, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"被访问次数"];
    [dataView addSubview:bfwcs_label];
    bfwcs_num = [self createLabelFrame:CGRectMake(0, 20, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"140"];
    [dataView addSubview:bfwcs_num];
    
    UILabel* hyts_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3, 50, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"活跃天数"];
    [dataView addSubview:hyts_label];
    hyts_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3, 20, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"32"];
    [dataView addSubview:hyts_num];
    
    UILabel* hyjf_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3*2, 50, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"活跃积分"];
    [dataView addSubview:hyjf_label];
    hyjf_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3*2, 20, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"140"];
    [dataView addSubview:hyjf_num];
    
    //第二行
    UIView* line_1_View = [[UIView alloc]initWithFrame:CGRectMake(15, 80, SCREEN_WIDTH-30, 0.5)];
    line_1_View.backgroundColor = ColorLine;
    [dataView addSubview:line_1_View];
    
    UIView* line_2_vertical_1_View = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 100, 0.5, 35)];
    line_2_vertical_1_View.backgroundColor = ColorLine;
    [dataView addSubview:line_2_vertical_1_View];
    
    UIView* line_2_vertical_2_View = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 100, 0.5, 35)];
    line_2_vertical_2_View.backgroundColor = ColorLine;
    [dataView addSubview:line_2_vertical_2_View];
    
    UILabel* dz_label = [self createLabelFrame:CGRectMake(0, 120, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"点赞"];
    [dataView addSubview:dz_label];
    dz_num = [self createLabelFrame:CGRectMake(0, 90, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"2011"];
    [dataView addSubview:dz_num];
    
    UILabel* hf_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3, 120, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"回复"];
    [dataView addSubview:hf_label];
    hf_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3, 90, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"887"];
    [dataView addSubview:hf_num];
    
    UILabel* fx_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3*2, 120, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"分享"];
    [dataView addSubview:fx_label];
    fx_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3*2, 90, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"0"];
    [dataView addSubview:fx_num];
    
    //第三行
    UIView* line_2_View = [[UIView alloc]initWithFrame:CGRectMake(15, 150, SCREEN_WIDTH-30, 0.5)];
    line_2_View.backgroundColor = ColorLine;
    [dataView addSubview:line_2_View];
    
    UIView* line_3_vertical_1_View = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 170, 0.5, 35)];
    line_3_vertical_1_View.backgroundColor = ColorLine;
    [dataView addSubview:line_3_vertical_1_View];
    
    UIView* line_3_vertical_2_View = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 170, 0.5, 35)];
    line_3_vertical_2_View.backgroundColor = ColorLine;
    [dataView addSubview:line_3_vertical_2_View];
    
    UILabel* fts_label = [self createLabelFrame:CGRectMake(0, 190, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"发帖数"];
    [dataView addSubview:fts_label];
    fts_num = [self createLabelFrame:CGRectMake(0, 160, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"75"];
    [dataView addSubview:fts_num];
    
    UILabel* tjbs_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3, 190, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"推荐比赛"];
    [dataView addSubview:tjbs_label];
    tjbs_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3, 160, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"37"];
    [dataView addSubview:tjbs_num];
    
    UILabel* yqs_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3*2, 190, SCREEN_WIDTH/3, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorRankMedal withText:@"邀请数"];
    [dataView addSubview:yqs_label];
    yqs_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/3*2, 160, SCREEN_WIDTH/3, 30) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:24] withColor:ColorName withText:@"2"];
    [dataView addSubview:yqs_num];
}

//暂时先这样写，取数据时再改
- (void)createWeekView
{
    // 胜率
    _w_winRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(120, 15, 70, 70)];
    [_w_winRateCircleChart setLineWidth:6  inLineWidth:4 atValue:68 totalValue:100 chartColor:ColorRateTitle
                    descriptionString:@"胜率"];
    _w_winRateCircleChart.centerX = SCREEN_WIDTH/2;
    _w_winRateCircleChart.valuesFontSize = 15;
    _w_winRateCircleChart.descriptionFontSize = 10;
    [_w_winRateCircleChart animatePath];
    [weekView addSubview:self.w_winRateCircleChart];
    
    // 利润率
    _w_profitRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH==320?CGRectGetMaxX(_w_winRateCircleChart.frame) + 35*SCREEN_SCALE:SCREEN_WIDTH-85*SCREEN_SCALE,CGRectGetMinY(_w_winRateCircleChart.frame), 70, 70)];
    [_w_profitRateCircleChart setLineWidth:6 inLineWidth:4 atValue:79 totalValue:100 chartColor:ColorRateTitle
                       descriptionString:@"利润率"];
    _w_profitRateCircleChart.valuesFontSize = 15;
    _w_profitRateCircleChart.descriptionFontSize = 10;
    [_w_profitRateCircleChart animatePath];
    [weekView addSubview:self.w_profitRateCircleChart];
    
    UIControl *winLoseControl = [[UIControl alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-100, 90)];
    [winLoseControl addTarget:self action:@selector(tapWinLoseControl) forControlEvents:UIControlEventTouchUpInside];
    [weekView addSubview:winLoseControl];
    
    // 推荐赢／周推荐
    CGSize recommendWinTitleSize = RYG_TEXTSIZE(@"推荐赢/周推荐", [UIFont systemFontOfSize:12]);
    UILabel *lblRecommendWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, recommendWinTitleSize.width, recommendWinTitleSize.height)];
    lblRecommendWinTitle.font = [UIFont systemFontOfSize:12];
    lblRecommendWinTitle.textColor = ColorSecondTitle;
    lblRecommendWinTitle.textAlignment = NSTextAlignmentLeft;
    lblRecommendWinTitle.text = @"推荐赢/周推荐";
    [weekView addSubview:lblRecommendWinTitle];
    
    CGSize weekRecommendViewSize = RYG_TEXTSIZE(@"28", [UIFont systemFontOfSize:12]);
    //
    _weekRecommendView = [[RYGWeekRecommendView alloc]initWithFrame:CGRectMake(10, 50, lblRecommendWinTitle.width+10, weekRecommendViewSize.height) smallFontSize:10 largeFontSize:16 recommendWinGamesColor:ColorRateTitle recommendGamesFontColor:ColorName];
    [_weekRecommendView setRecommendWinGames:@"65" recommendGames:@"86"];
    [weekView addSubview:_weekRecommendView];
    
    UIView* line_1_View = [[UIView alloc]initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH-20, 0.5)];
    line_1_View.backgroundColor = ColorLine;
    [weekView addSubview:line_1_View];
    
    
    _w_p = [[RYGRadarChart alloc] initWithFrame:CGRectMake(10, 110, 125, 120)];
    
//    NSArray *a1 = @[@(71), @(37), @(47), @(60), @(65), @(77)];
//    _w_p.dataSeries = @[a1];
    _w_p.steps = 1;
//    p.showStepText = YES;
    _w_p.backgroundColor = [UIColor whiteColor];
    _w_p.r = 40;
//    _w_p.minValue = 20;
//    _w_p.maxValue = 100;
    _w_p.fillArea = YES;
//    p.colorOpacity = 0.7;
    _w_p.attributes = @[@"胜率", @"稳定", @"让球", @"胜平负", @"大小", @"利润率"];
    _w_p.showLegend = NO;
    [_w_p setColors:@[[UIColor colorWithHexadecimal:@"#e53f2a"]]];
    [weekView addSubview:_w_p];
    
    
    
    UIView* line_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(140, 120, 0.5, 90)];
    line_vertical_View.backgroundColor = ColorLine;
    [weekView addSubview:line_vertical_View];
    
    UILabel* ypsl_label = [self createLabelFrame:CGRectMake(151, 119, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"让球胜率"];
    [weekView addSubview:ypsl_label];
    w_ypsl_num = [self createLabelFrame:CGRectMake(156, 140, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"81％"];
    [weekView addSubview:w_ypsl_num];
    
    UIControl *ypslControl = [[UIControl alloc]initWithFrame:CGRectMake(140, 100, (SCREEN_WIDTH-140)/3, 65)];
    ypslControl.tag = 1;
    [ypslControl addTarget:self action:@selector(tapYpslControl:) forControlEvents:UIControlEventTouchUpInside];
    [weekView addSubview:ypslControl];
    
    UILabel* dxqsl_label = [self createLabelFrame:CGRectMake(196, 119, 68, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"大小球胜率"];
    dxqsl_label.centerX = (SCREEN_WIDTH-140)/2+140;
    [weekView addSubview:dxqsl_label];
    w_dxqsl_num = [self createLabelFrame:CGRectMake(206, 140, 48, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"49％"];
    w_dxqsl_num.centerX = (SCREEN_WIDTH-140)/2+140;
    [weekView addSubview:w_dxqsl_num];
    
    UIControl *dxqslControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3, 100, (SCREEN_WIDTH-140)/3, 65)];
    dxqslControl.tag = 1;
    [dxqslControl addTarget:self action:@selector(tapDxqslControl:) forControlEvents:UIControlEventTouchUpInside];
    [weekView addSubview:dxqslControl];
    
    UILabel* jcsl_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-70, 119, 68, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"胜平负胜率"];
    [weekView addSubview:jcsl_label];
    w_jcsl_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 140, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"79％"];
    [weekView addSubview:w_jcsl_num];
    
    UIControl *jcslControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3*2, 100, (SCREEN_WIDTH-140)/3, 65)];
    jcslControl.tag = 1;
    [jcslControl addTarget:self action:@selector(tapJcslControl:) forControlEvents:UIControlEventTouchUpInside];
    [weekView addSubview:jcslControl];
    
    UIView* line_middle_View = [[UIView alloc]initWithFrame:CGRectMake(140, 165, SCREEN_WIDTH-150, 0.5)];
    line_middle_View.backgroundColor = ColorLine;
    [weekView addSubview:line_middle_View];
    
    UILabel* pjtjsw_label = [self createLabelFrame:CGRectMake(138, 175, 77, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"平均推荐水位"];
    [weekView addSubview:pjtjsw_label];
    w_pjtjsw_num = [self createLabelFrame:CGRectMake(148, 196, 57, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"1.02"];
    [weekView addSubview:w_pjtjsw_num];
    
    UIControl *pjtjswControl = [[UIControl alloc]initWithFrame:CGRectMake(140, 165, (SCREEN_WIDTH-140)/3, 65)];
    pjtjswControl.tag = 1;
    [pjtjswControl addTarget:self action:@selector(tapPjtjswControl:) forControlEvents:UIControlEventTouchUpInside];
    [weekView addSubview:pjtjswControl];
    
    UILabel* zglh_label = [self createLabelFrame:CGRectMake(205, 175, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"最高连红"];
    zglh_label.centerX = (SCREEN_WIDTH-140)/2+140;
    [weekView addSubview:zglh_label];
    w_zglh_num = [self createLabelFrame:CGRectMake(210, 196, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"1.02"];
    w_zglh_num.centerX = (SCREEN_WIDTH-140)/2+140;
    [weekView addSubview:w_zglh_num];
    
    UIControl *zglhControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3, 165, (SCREEN_WIDTH-140)/3, 65)];
    zglhControl.tag = 1;
    [zglhControl addTarget:self action:@selector(tapZglhControl:) forControlEvents:UIControlEventTouchUpInside];
    [weekView addSubview:zglhControl];
    
    UILabel* wdx_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 175, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"稳定性"];
    [weekView addSubview:wdx_label];
    w_wdx_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 196, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"5"];
    [weekView addSubview:w_wdx_num];
    
    UIControl *wdxControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3*2, 165, (SCREEN_WIDTH-140)/3, 65)];
    wdxControl.tag = 1;
    [wdxControl addTarget:self action:@selector(tapWdxControl:) forControlEvents:UIControlEventTouchUpInside];
    [weekView addSubview:wdxControl];
    
    UIView* line_2_View = [[UIView alloc]initWithFrame:CGRectMake(10, 229.5, SCREEN_WIDTH-20, 0.5)];
    line_2_View.backgroundColor = ColorLine;
    [weekView addSubview:line_2_View];
    
    UIImageView* recentBunkoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 242, 11, 13)];
    recentBunkoImage.image = [UIImage imageNamed:@"user_bunko"];
    [weekView addSubview:recentBunkoImage];
    
    UILabel* recentBunkoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 240, 120, 20)];
    recentBunkoLabel.text = @"近日输赢战绩";
    recentBunkoLabel.font = [UIFont systemFontOfSize:13];
    recentBunkoLabel.textColor = ColorSecondTitle;
    [weekView addSubview:recentBunkoLabel];
    
    w_winRateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 270, SCREEN_WIDTH-100, 20)];
    w_winRateLabel.textAlignment = NSTextAlignmentCenter;
    [weekView addSubview:w_winRateLabel];
    
    UIView* backWhiteView = [[UIView alloc]initWithFrame:CGRectMake(50, 300, SCREEN_WIDTH-100, 90)];
    backWhiteView.backgroundColor = [UIColor whiteColor];
    [weekView addSubview:backWhiteView];
    
    UIView* line_back_View = [[UIView alloc]initWithFrame:CGRectMake(40, 369.5, SCREEN_WIDTH-80, 0.5)];
    line_back_View.backgroundColor = ColorLine;
    [weekView addSubview:line_back_View];
    
    UILabel* farLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 350, 25, 20)];
    farLabel.text = @"最近";
    farLabel.font = [UIFont boldSystemFontOfSize:12];
    farLabel.textColor = ColorSecondTitle;
    [weekView addSubview:farLabel];
    
    UILabel* awayLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 350, 25, 20)];
    awayLabel.text = @"最远";
    awayLabel.font = [UIFont boldSystemFontOfSize:12];
    awayLabel.textColor = ColorSecondTitle;
    [weekView addSubview:awayLabel];
    
    _w_chrt = [[RYGBarChart alloc] initWithFrame:backWhiteView.bounds
                                                   color:[UIColor clearColor]
                                              references:nil
                                               andValues:nil];
    _w_chrt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _w_chrt.backgroundColor = [UIColor whiteColor];
    _w_chrt.bounds = backWhiteView.bounds;
    [backWhiteView addSubview:_w_chrt];
    
}

- (void)createMonthView
{
    // 胜率
    _m_winRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(120, 15, 70, 70)];
    [_m_winRateCircleChart setLineWidth:6  inLineWidth:4 atValue:68 totalValue:100 chartColor:ColorRateTitle
                    descriptionString:@"胜率"];
    _m_winRateCircleChart.centerX = SCREEN_WIDTH/2;
    _m_winRateCircleChart.valuesFontSize = 15;
    _m_winRateCircleChart.descriptionFontSize = 10;
    [_m_winRateCircleChart animatePath];
    [monthView addSubview:self.m_winRateCircleChart];
    
    // 利润率
    _m_profitRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH==320?CGRectGetMaxX(_m_winRateCircleChart.frame) + 35*SCREEN_SCALE:SCREEN_WIDTH-85*SCREEN_SCALE,CGRectGetMinY(_m_winRateCircleChart.frame), 70, 70)];
    [_m_profitRateCircleChart setLineWidth:6 inLineWidth:4 atValue:79 totalValue:100 chartColor:ColorRateTitle
                       descriptionString:@"利润率"];
    _m_profitRateCircleChart.valuesFontSize = 15;
    _m_profitRateCircleChart.descriptionFontSize = 10;
    [_m_profitRateCircleChart animatePath];
    [monthView addSubview:self.m_profitRateCircleChart];
    
    UIControl *winLoseControl = [[UIControl alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-100, 90)];
    [winLoseControl addTarget:self action:@selector(tapWinLoseControl) forControlEvents:UIControlEventTouchUpInside];
    [monthView addSubview:winLoseControl];
    
    // 推荐赢／月推荐
    CGSize recommendWinTitleSize = RYG_TEXTSIZE(@"推荐赢/月推荐", [UIFont systemFontOfSize:12]);
    UILabel *lblRecommendWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, recommendWinTitleSize.width, recommendWinTitleSize.height)];
    lblRecommendWinTitle.font = [UIFont systemFontOfSize:12];
    lblRecommendWinTitle.textColor = ColorSecondTitle;
    lblRecommendWinTitle.textAlignment = NSTextAlignmentLeft;
    lblRecommendWinTitle.text = @"推荐赢/月推荐";
    [monthView addSubview:lblRecommendWinTitle];
    
    CGSize weekRecommendViewSize = RYG_TEXTSIZE(@"28", [UIFont systemFontOfSize:12]);
    //
    _monthRecommendView = [[RYGWeekRecommendView alloc]initWithFrame:CGRectMake(10, 50, lblRecommendWinTitle.width+10, weekRecommendViewSize.height) smallFontSize:10 largeFontSize:16 recommendWinGamesColor:ColorRateTitle recommendGamesFontColor:ColorName];
    [_monthRecommendView setRecommendWinGames:@"65" recommendGames:@"86"];
    [monthView addSubview:_monthRecommendView];
    
    UIView* line_1_View = [[UIView alloc]initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH-20, 0.5)];
    line_1_View.backgroundColor = ColorLine;
    [monthView addSubview:line_1_View];
    
    _m_p = [[RYGRadarChart alloc] initWithFrame:CGRectMake(10, 110, 125, 120)];
    
    NSArray *a1 = @[@(71), @(37), @(47), @(60), @(65), @(77)];
    _m_p.dataSeries = @[a1];
    _m_p.steps = 1;
    //    p.showStepText = YES;
    _m_p.backgroundColor = [UIColor whiteColor];
    _m_p.r = 40;
    //    p.minValue = 10;
    //    p.maxValue = 90;
    _m_p.fillArea = YES;
    //    p.colorOpacity = 0.7;
    _m_p.attributes = @[@"胜率", @"稳定", @"让球", @"胜平负", @"大小", @"利润率"];
    _m_p.showLegend = NO;
    [_m_p setColors:@[[UIColor colorWithHexadecimal:@"#e53f2a"]]];
    [monthView addSubview:_m_p];
    
    UIView* line_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(140, 120, 0.5, 90)];
    line_vertical_View.backgroundColor = ColorLine;
    [monthView addSubview:line_vertical_View];
    
    UILabel* ypsl_label = [self createLabelFrame:CGRectMake(151, 119, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"让球胜率"];
    [monthView addSubview:ypsl_label];
    m_ypsl_num = [self createLabelFrame:CGRectMake(156, 140, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"81％"];
    [monthView addSubview:m_ypsl_num];
    
    UIControl *ypslControl = [[UIControl alloc]initWithFrame:CGRectMake(140, 100, (SCREEN_WIDTH-140)/3, 65)];
    ypslControl.tag = 2;
    [ypslControl addTarget:self action:@selector(tapYpslControl:) forControlEvents:UIControlEventTouchUpInside];
    [monthView addSubview:ypslControl];
    
    UILabel* dxqsl_label = [self createLabelFrame:CGRectMake(196, 119, 68, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"大小球胜率"];
    dxqsl_label.centerX = (SCREEN_WIDTH-140)/2+140;
    [monthView addSubview:dxqsl_label];
    m_dxqsl_num = [self createLabelFrame:CGRectMake(206, 140, 48, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"49％"];
    m_dxqsl_num.centerX = (SCREEN_WIDTH-140)/2+140;
    [monthView addSubview:m_dxqsl_num];
    
    UIControl *dxqslControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3, 100, (SCREEN_WIDTH-140)/3, 65)];
    dxqslControl.tag = 2;
    [dxqslControl addTarget:self action:@selector(tapDxqslControl:) forControlEvents:UIControlEventTouchUpInside];
    [monthView addSubview:dxqslControl];
    
    UILabel* jcsl_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-70, 119, 68, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"胜平负胜率"];
    [monthView addSubview:jcsl_label];
    m_jcsl_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 140, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"79％"];
    [monthView addSubview:m_jcsl_num];
    
    UIControl *jcslControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3*2, 100, (SCREEN_WIDTH-140)/3, 65)];
    jcslControl.tag = 2;
    [jcslControl addTarget:self action:@selector(tapJcslControl:) forControlEvents:UIControlEventTouchUpInside];
    [monthView addSubview:jcslControl];
    
    UIView* line_middle_View = [[UIView alloc]initWithFrame:CGRectMake(140, 165, SCREEN_WIDTH-150, 0.5)];
    line_middle_View.backgroundColor = ColorLine;
    [monthView addSubview:line_middle_View];
    
    UILabel* pjtjsw_label = [self createLabelFrame:CGRectMake(138, 175, 77, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"平均推荐水位"];
    [monthView addSubview:pjtjsw_label];
    m_pjtjsw_num = [self createLabelFrame:CGRectMake(148, 196, 57, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"1.02"];
    [monthView addSubview:m_pjtjsw_num];
    
    UIControl *pjtjswControl = [[UIControl alloc]initWithFrame:CGRectMake(140, 165, (SCREEN_WIDTH-140)/3, 65)];
    pjtjswControl.tag = 2;
    [pjtjswControl addTarget:self action:@selector(tapPjtjswControl:) forControlEvents:UIControlEventTouchUpInside];
    [monthView addSubview:pjtjswControl];
    
    UILabel* zglh_label = [self createLabelFrame:CGRectMake(205, 175, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"最高连红"];
    zglh_label.centerX = (SCREEN_WIDTH-140)/2+140;
    [monthView addSubview:zglh_label];
    m_zglh_num = [self createLabelFrame:CGRectMake(210, 196, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"1.02"];
    m_zglh_num.centerX = (SCREEN_WIDTH-140)/2+140;
    [monthView addSubview:m_zglh_num];
    
    UIControl *zglhControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3, 165, (SCREEN_WIDTH-140)/3, 65)];
    zglhControl.tag = 2;
    [zglhControl addTarget:self action:@selector(tapZglhControl:) forControlEvents:UIControlEventTouchUpInside];
    [monthView addSubview:zglhControl];
    
    UILabel* wdx_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 175, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"稳定性"];
    [monthView addSubview:wdx_label];
    m_wdx_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 196, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"5"];
    [monthView addSubview:m_wdx_num];
    
    UIControl *wdxControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3*2, 165, (SCREEN_WIDTH-140)/3, 65)];
    wdxControl.tag = 2;
    [wdxControl addTarget:self action:@selector(tapWdxControl:) forControlEvents:UIControlEventTouchUpInside];
    [monthView addSubview:wdxControl];
    
    UIView* line_2_View = [[UIView alloc]initWithFrame:CGRectMake(10, 229.5, SCREEN_WIDTH-20, 0.5)];
    line_2_View.backgroundColor = ColorLine;
    [monthView addSubview:line_2_View];
    
    UIImageView* recentBunkoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 242, 11, 13)];
    recentBunkoImage.image = [UIImage imageNamed:@"user_kLine"];
    [monthView addSubview:recentBunkoImage];
    
    UILabel* recentBunkoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 240, 120, 20)];
    recentBunkoLabel.text = @"利润K线图";
    recentBunkoLabel.font = [UIFont systemFontOfSize:13];
    recentBunkoLabel.textColor = ColorSecondTitle;
    [monthView addSubview:recentBunkoLabel];
    
    m_allBunkoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 240, 120, 20)];
    m_allBunkoLabel.text = @"总利润:";
    m_allBunkoLabel.textAlignment = NSTextAlignmentRight;
    m_allBunkoLabel.font = [UIFont systemFontOfSize:12];
    m_allBunkoLabel.textColor = ColorSecondTitle;
    [monthView addSubview:m_allBunkoLabel];
    
//    NSMutableArray* chartData = [NSMutableArray arrayWithObjects:@"5",@"15",@"5",@"25",@"15",@"5",@"10", nil];
    
    // Creating the line chart
    _m_lineChart = [[RYGLineChart alloc] initWithFrame:CGRectMake(40, 270, SCREEN_WIDTH - 60, 120)];
    _m_lineChart.dataType = 0;
    _m_lineChart.gridStep = 30;
    _m_lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%lu",(unsigned long)item];
    };
    _m_lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
//    [_m_lineChart setChartData:chartData];
    [monthView addSubview:_m_lineChart];
    
}

- (void)createNinetyView
{
    // 胜率
    _n_winRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(120, 15, 70, 70)];
    [_n_winRateCircleChart setLineWidth:6  inLineWidth:4 atValue:68 totalValue:100 chartColor:ColorRateTitle
                    descriptionString:@"胜率"];
    _n_winRateCircleChart.centerX = SCREEN_WIDTH/2;
    _n_winRateCircleChart.valuesFontSize = 15;
    _n_winRateCircleChart.descriptionFontSize = 10;
    [_n_winRateCircleChart animatePath];
    [ninetyView addSubview:self.n_winRateCircleChart];
    
    // 利润率
    _n_profitRateCircleChart = [[AFCircleChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH==320?CGRectGetMaxX(_n_winRateCircleChart.frame) + 35*SCREEN_SCALE:SCREEN_WIDTH-85*SCREEN_SCALE,CGRectGetMinY(_n_winRateCircleChart.frame), 70, 70)];
    [_n_profitRateCircleChart setLineWidth:6 inLineWidth:4 atValue:79 totalValue:100 chartColor:ColorRateTitle
                       descriptionString:@"利润率"];
    _n_profitRateCircleChart.valuesFontSize = 15;
    _n_profitRateCircleChart.descriptionFontSize = 10;
    [_n_profitRateCircleChart animatePath];
    [ninetyView addSubview:self.n_profitRateCircleChart];
    
    UIControl *winLoseControl = [[UIControl alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-100, 90)];
    [winLoseControl addTarget:self action:@selector(tapWinLoseControl) forControlEvents:UIControlEventTouchUpInside];
    [ninetyView addSubview:winLoseControl];
    
    // 推荐赢／季推荐
    CGSize recommendWinTitleSize = RYG_TEXTSIZE(@"推荐赢/季推荐", [UIFont systemFontOfSize:12]);
    UILabel *lblRecommendWinTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, recommendWinTitleSize.width, recommendWinTitleSize.height)];
    lblRecommendWinTitle.font = [UIFont systemFontOfSize:12];
    lblRecommendWinTitle.textColor = ColorSecondTitle;
    lblRecommendWinTitle.textAlignment = NSTextAlignmentLeft;
    lblRecommendWinTitle.text = @"推荐赢/季推荐";
    [ninetyView addSubview:lblRecommendWinTitle];
    
    CGSize weekRecommendViewSize = RYG_TEXTSIZE(@"28", [UIFont systemFontOfSize:12]);
    //
    _ninetyRecommendView = [[RYGWeekRecommendView alloc]initWithFrame:CGRectMake(10, 50, lblRecommendWinTitle.width+10, weekRecommendViewSize.height) smallFontSize:10 largeFontSize:16 recommendWinGamesColor:ColorRateTitle recommendGamesFontColor:ColorName];
    [_ninetyRecommendView setRecommendWinGames:@"65" recommendGames:@"86"];
    [ninetyView addSubview:_ninetyRecommendView];
    
    UIView* line_1_View = [[UIView alloc]initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH-20, 0.5)];
    line_1_View.backgroundColor = ColorLine;
    [ninetyView addSubview:line_1_View];
    
    _n_p = [[RYGRadarChart alloc] initWithFrame:CGRectMake(10, 110, 125, 120)];
    
    NSArray *a1 = @[@(71), @(37), @(47), @(60), @(65), @(77)];
    _n_p.dataSeries = @[a1];
    _n_p.steps = 1;
    //    p.showStepText = YES;
    _n_p.backgroundColor = [UIColor whiteColor];
    _n_p.r = 40;
    //    p.minValue = 10;
    //    p.maxValue = 90;
    _n_p.fillArea = YES;
    //    p.colorOpacity = 0.7;
    _n_p.attributes = @[@"胜率", @"稳定", @"让球", @"胜平负", @"大小", @"利润率"];
    _n_p.showLegend = NO;
    [_n_p setColors:@[[UIColor colorWithHexadecimal:@"#e53f2a"]]];
    [ninetyView addSubview:_n_p];
    
    UIView* line_vertical_View = [[UIView alloc]initWithFrame:CGRectMake(140, 120, 0.5, 90)];
    line_vertical_View.backgroundColor = ColorLine;
    [ninetyView addSubview:line_vertical_View];
    
    UILabel* ypsl_label = [self createLabelFrame:CGRectMake(151, 119, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"让球胜率"];
    [ninetyView addSubview:ypsl_label];
    n_ypsl_num = [self createLabelFrame:CGRectMake(156, 140, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"81％"];
    [ninetyView addSubview:n_ypsl_num];
    
    UIControl *ypslControl = [[UIControl alloc]initWithFrame:CGRectMake(140, 100, (SCREEN_WIDTH-140)/3, 65)];
    ypslControl.tag = 3;
    [ypslControl addTarget:self action:@selector(tapYpslControl:) forControlEvents:UIControlEventTouchUpInside];
    [ninetyView addSubview:ypslControl];
    
    UILabel* dxqsl_label = [self createLabelFrame:CGRectMake(196, 119, 68, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"大小球胜率"];
    dxqsl_label.centerX = (SCREEN_WIDTH-140)/2+140;
    [ninetyView addSubview:dxqsl_label];
    n_dxqsl_num = [self createLabelFrame:CGRectMake(206, 140, 48, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"49％"];
    n_dxqsl_num.centerX = (SCREEN_WIDTH-140)/2+140;
    [ninetyView addSubview:n_dxqsl_num];
    
    UIControl *dxqslControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3, 100, (SCREEN_WIDTH-140)/3, 65)];
    dxqslControl.tag = 3;
    [dxqslControl addTarget:self action:@selector(tapDxqslControl:) forControlEvents:UIControlEventTouchUpInside];
    [ninetyView addSubview:dxqslControl];
    
    UILabel* jcsl_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-70, 119, 68, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"胜平负胜率"];
    [ninetyView addSubview:jcsl_label];
    n_jcsl_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 140, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"79％"];
    [ninetyView addSubview:n_jcsl_num];
    
    UIControl *jcslControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3*2, 100, (SCREEN_WIDTH-140)/3, 65)];
    jcslControl.tag = 3;
    [jcslControl addTarget:self action:@selector(tapJcslControl:) forControlEvents:UIControlEventTouchUpInside];
    [ninetyView addSubview:jcslControl];
    
    UIView* line_middle_View = [[UIView alloc]initWithFrame:CGRectMake(140, 165, SCREEN_WIDTH-150, 0.5)];
    line_middle_View.backgroundColor = ColorLine;
    [ninetyView addSubview:line_middle_View];
    
    UILabel* pjtjsw_label = [self createLabelFrame:CGRectMake(138, 175, 77, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"平均推荐水位"];
    [ninetyView addSubview:pjtjsw_label];
    n_pjtjsw_num = [self createLabelFrame:CGRectMake(148, 196, 57, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"1.02"];
    [ninetyView addSubview:n_pjtjsw_num];
    
    UIControl *pjtjswControl = [[UIControl alloc]initWithFrame:CGRectMake(140, 165, (SCREEN_WIDTH-140)/3, 65)];
    pjtjswControl.tag = 3;
    [pjtjswControl addTarget:self action:@selector(tapPjtjswControl:) forControlEvents:UIControlEventTouchUpInside];
    [ninetyView addSubview:pjtjswControl];
    
    UILabel* zglh_label = [self createLabelFrame:CGRectMake(205, 175, 50, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"最高连红"];
    zglh_label.centerX = (SCREEN_WIDTH-140)/2+140;
    [ninetyView addSubview:zglh_label];
    n_zglh_num = [self createLabelFrame:CGRectMake(210, 196, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorRateTitle withText:@"1.02"];
    n_zglh_num.centerX = (SCREEN_WIDTH-140)/2+140;
    [ninetyView addSubview:n_zglh_num];
    
    UIControl *zglhControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3, 165, (SCREEN_WIDTH-140)/3, 65)];
    zglhControl.tag = 3;
    [zglhControl addTarget:self action:@selector(tapZglhControl:) forControlEvents:UIControlEventTouchUpInside];
    [ninetyView addSubview:zglhControl];
    
    UILabel* wdx_label = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 175, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:LABEL_TEXT_SIZE] withColor:ColorSecondTitle withText:@"稳定性"];
    [ninetyView addSubview:wdx_label];
    n_wdx_num = [self createLabelFrame:CGRectMake(SCREEN_WIDTH-56, 196, 40, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont systemFontOfSize:12] withColor:ColorName withText:@"5"];
    [ninetyView addSubview:n_wdx_num];
    
    UIControl *wdxControl = [[UIControl alloc]initWithFrame:CGRectMake(140+(SCREEN_WIDTH-140)/3*2, 165, (SCREEN_WIDTH-140)/3, 65)];
    wdxControl.tag = 3;
    [wdxControl addTarget:self action:@selector(tapWdxControl:) forControlEvents:UIControlEventTouchUpInside];
    [ninetyView addSubview:wdxControl];
    
    UIView* line_2_View = [[UIView alloc]initWithFrame:CGRectMake(10, 229.5, SCREEN_WIDTH-20, 0.5)];
    line_2_View.backgroundColor = ColorLine;
    [ninetyView addSubview:line_2_View];
    
    UIImageView* recentBunkoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 242, 11, 13)];
    recentBunkoImage.image = [UIImage imageNamed:@"user_kLine"];
    [ninetyView addSubview:recentBunkoImage];
    
    UILabel* recentBunkoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 240, 120, 20)];
    recentBunkoLabel.text = @"利润K线图";
    recentBunkoLabel.font = [UIFont systemFontOfSize:13];
    recentBunkoLabel.textColor = ColorSecondTitle;
    [ninetyView addSubview:recentBunkoLabel];
    
    n_allBunkoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 240, 120, 20)];
    n_allBunkoLabel.text = @"总利润:";
    n_allBunkoLabel.textAlignment = NSTextAlignmentRight;
    n_allBunkoLabel.font = [UIFont systemFontOfSize:12];
    n_allBunkoLabel.textColor = ColorSecondTitle;
    [ninetyView addSubview:n_allBunkoLabel];
    
//    NSMutableArray* chartData = [NSMutableArray arrayWithObjects:@"5",@"15",@"5",@"25",@"15",@"5",@"10", nil];
    
    // Creating the line chart
    _n_lineChart = [[RYGLineChart alloc] initWithFrame:CGRectMake(40, 270, SCREEN_WIDTH - 60, 120)];
    _n_lineChart.dataType = 1;
    _n_lineChart.gridStep = 90;
    _n_lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%lu",(unsigned long)item];
    };
    _n_lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
//    [_n_lineChart setChartData:chartData];
    [ninetyView addSubview:_n_lineChart];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x+self.width/2.0) / self.width;
    _pageControl.currentPage = page;
    if (page == 0) {
        if (_dataBlock) {
            _dataBlock();
        }
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        _scrollView.contentSize= CGSizeMake(SCREEN_WIDTH*4, 220);
    }
    else {
        if (_timeBlock) {
            _timeBlock();
        }
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 433);
        _scrollView.contentSize= CGSizeMake(SCREEN_WIDTH*4, 433);
    }
}

// 点击输赢列表
- (void)tapWinLoseControl {
    if (_tapWinLoseBlock) {
        _tapWinLoseBlock();
    }
}

//点击让球胜率
- (void)tapYpslControl:(UIControl *)control {
    if (_tapYpslBlock) {
        _tapYpslBlock(control.tag);
    }
}

//点击大小球胜率
- (void)tapDxqslControl:(UIControl *)control {
    if (_tapDxqslBlock) {
        _tapDxqslBlock(control.tag);
    }
}

//点击胜平负胜率
- (void)tapJcslControl:(UIControl *)control {
    if (_tapJcslBlock) {
        _tapJcslBlock(control.tag);
    }
}

//平均推荐水位
- (void)tapPjtjswControl:(UIControl *)control {
    if (_tapPjtjswBlock) {
        _tapPjtjswBlock(control.tag);
    }
}

//点击最高连红
- (void)tapZglhControl:(UIControl *)control {
    if (_tapZglhBlock) {
        _tapZglhBlock(control.tag);
    }
}

//点击稳定性
- (void)tapWdxControl:(UIControl *)control {
    if (_tapWdxBlock) {
        _tapWdxBlock(control.tag);
    }
}

//setData
- (void)setUserDataModel:(RYGPersonalUserModel *)userDataModel {
    _userDataModel = userDataModel;
    dataStyle = 1;
    [self updateCell];
}

- (void)setWeekDataModel:(RYGPersonalDatasModel *)weekDataModel {
    _weekDataModel = weekDataModel;
    dataStyle = 2;
    [self updateCell];
}

- (void)setMonthDataModel:(RYGPersonalDatasModel *)monthDataModel {
    _monthDataModel = monthDataModel;
    dataStyle = 3;
    [self updateCell];
}

- (void)setNinetyDataModel:(RYGPersonalDatasModel *)ninetyDataModel {
    _ninetyDataModel = ninetyDataModel;
    dataStyle = 4;
    [self updateCell];
}

- (void)updateCell {
    
    if (dataStyle == 1) {
        bfwcs_num.text = [NSString stringWithFormat:@"%@",_userDataModel.visit_num];
        hyts_num.text = [NSString stringWithFormat:@"%@",_userDataModel.active_num];
        hyjf_num.text = [NSString stringWithFormat:@"%@",_userDataModel.score];
        dz_num.text = [NSString stringWithFormat:@"%@",_userDataModel.praise_num];
        hf_num.text = [NSString stringWithFormat:@"%@",_userDataModel.comment_num];
        fx_num.text = [NSString stringWithFormat:@"%@",_userDataModel.share_num];
        fts_num.text = [NSString stringWithFormat:@"%@",_userDataModel.publish_num];
        tjbs_num.text = [NSString stringWithFormat:@"%@",_userDataModel.match_num];
        yqs_num.text = [NSString stringWithFormat:@"%@",_userDataModel.invite_num];
    }
    else if (dataStyle == 2) {
        // 胜率
        [_w_winRateCircleChart reAnimateChartAtValue:[_weekDataModel.win_rate integerValue] totalValue:100];
//        if (_weekDataModel.win_rate.intValue >= 60) {
//            [_w_winRateCircleChart setlabelNumColor:ColorRateTitle];
//        }
//        else {
//            [_w_winRateCircleChart setlabelNumColor:ColorName];
//        }
        // 利润率
        [_w_profitRateCircleChart reAnimateChartAtValue:[_weekDataModel.profit_margin integerValue] totalValue:100];
//        if (_weekDataModel.profit_margin.intValue > 0) {
//            [_w_profitRateCircleChart setlabelNumColor:ColorRateTitle];
//        }
//        else {
//            [_w_profitRateCircleChart setlabelNumColor:ColorName];
//        }
        
        
        [_weekRecommendView setRecommendWinGames:_weekDataModel.win_count recommendGames:_weekDataModel.recommend_count];
        //让球胜率
        w_ypsl_num.text = [NSString stringWithFormat:@"%@％",_weekDataModel.win_rate_yp];
        //大小球胜率
        w_dxqsl_num.text = [NSString stringWithFormat:@"%@％",_weekDataModel.win_rate_dx];
        //胜平负胜率
        w_jcsl_num.text = [NSString stringWithFormat:@"%@％",_weekDataModel.win_rate_jc];
        //平均推荐水位
        w_pjtjsw_num.text = [NSString stringWithFormat:@"%.2f",_weekDataModel.water_level];
        //最高连红
        w_zglh_num.text = [NSString stringWithFormat:@"%@",_weekDataModel.max_continuous_win];
        //稳定性
        if (_weekDataModel.stability.intValue >= 0 && _weekDataModel.stability.intValue < 25) {
            w_wdx_num.text = @"差";
            w_wdx_num.textColor = ColorName;
        }
        else if (_weekDataModel.stability.intValue >= 25 && _weekDataModel.stability.intValue < 50){
            w_wdx_num.text = @"中";
            w_wdx_num.textColor = ColorName;
        }
        else if (_weekDataModel.stability.intValue >= 50 && _weekDataModel.stability.intValue < 75){
            w_wdx_num.text = @"良";
            w_wdx_num.textColor = ColorRateTitle;
        }
        else if (_weekDataModel.stability.intValue >= 75  && _weekDataModel.stability.intValue <= 100){
            w_wdx_num.text = @"优";
            w_wdx_num.textColor = ColorRateTitle;
        }
        
        if (_weekDataModel.max_continuous_win.intValue >= 3) {
            w_zglh_num.textColor = ColorRateTitle;
        }
        else {
            w_zglh_num.textColor = ColorName;
        }
        if (_weekDataModel.water_level >= 1.0) {
            w_pjtjsw_num.textColor = ColorRateTitle;
        }
        else {
            w_pjtjsw_num.textColor = ColorName;
        }
        if (_weekDataModel.win_rate_yp.intValue >= 70) {
            w_ypsl_num.textColor = ColorRateTitle;
        }
        else {
            w_ypsl_num.textColor = ColorName;
        }
        if (_weekDataModel.win_rate_dx.intValue >= 70) {
            w_dxqsl_num.textColor = ColorRateTitle;
        }
        else {
            w_dxqsl_num.textColor = ColorName;
        }
        if (_weekDataModel.win_rate_jc.intValue >= 70) {
            w_jcsl_num.textColor = ColorRateTitle;
        }
        else {
            w_jcsl_num.textColor = ColorName;
        }
        
        
        int successNum = 0;
        int failNum = 0;
        int drawNum = 0;
        for (int i = 0; i<_weekDataModel.recent_ten.count; i++) {
            if ([_weekDataModel.recent_ten[i] intValue] == 1) {
                drawNum++;
            }
            else if ([_weekDataModel.recent_ten[i] intValue] == 2) {
                successNum++;
            }
            else if ([_weekDataModel.recent_ten[i] intValue] == 3) {
                failNum++;
            }
        }
        NSLog(@"success = %d fail = %d draw = %d",successNum,failNum,drawNum);
        //输赢战绩label
        NSString *string = [NSString stringWithFormat:@"近10场推荐情况，%d赢%d平%d负",successNum,drawNum,failNum];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttribute:NSForegroundColorAttributeName value:ColorName range:NSMakeRange(0,9)];
        [str addAttribute:NSForegroundColorAttributeName value:ColorWin range:NSMakeRange(9,2)];
        [str addAttribute:NSForegroundColorAttributeName value:ColorGreen range:NSMakeRange(11,2)];
        [str addAttribute:NSForegroundColorAttributeName value:ColorTabBarButtonTitle range:NSMakeRange(13,2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 9)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(9, 2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(11, 2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(13, 2)];
        w_winRateLabel.attributedText = str;
        
        //今日输赢战绩柱状图
        //   59胜   34平   20负
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
        for (int i=0; i<10; i++) {
            array[i] = [NSNumber numberWithInt:0];
        }
        for (int i = 0; i<_weekDataModel.recent_ten.count; i++) {
            if ([_weekDataModel.recent_ten[i] intValue] == 1) {
                //平
                array[i] = [NSNumber numberWithInt:34];
            }
            else if ([_weekDataModel.recent_ten[i] intValue] == 2) {
                //胜
                array[i] = [NSNumber numberWithInt:59];
            }
            else if ([_weekDataModel.recent_ten[i] intValue] == 3) {
                //负
                array[i] = [NSNumber numberWithInt:20];
            }
        }
//        NSArray *vals = [NSArray arrayWithObjects:
//                         [NSNumber numberWithInt:59],
//                         [NSNumber numberWithInt:59],
//                         [NSNumber numberWithInt:59],
//                         [NSNumber numberWithInt:34],
//                         [NSNumber numberWithInt:34],
//                         [NSNumber numberWithInt:59],
//                         [NSNumber numberWithInt:59],
//                         [NSNumber numberWithInt:20],
//                         [NSNumber numberWithInt:34],
//                         [NSNumber numberWithInt:59],
//                         nil];
        _w_chrt.vals = array;
        
        //雷达图
        NSString* w_win_rate = _weekDataModel.win_rate.intValue>=95?@"95":_weekDataModel.win_rate;
        NSString* w_stability = _weekDataModel.stability.intValue>=95?@"95":_weekDataModel.stability;
        NSString* w_win_rate_yp = _weekDataModel.win_rate_yp.intValue>=95?@"95":_weekDataModel.win_rate_yp;
        NSString* w_win_rate_jc = _weekDataModel.win_rate_jc.intValue>=95?@"95":_weekDataModel.win_rate_jc;
        NSString* w_win_rate_dx = _weekDataModel.win_rate_dx.intValue>=95?@"95":_weekDataModel.win_rate_dx;
        NSString* w_profit_margin = _weekDataModel.profit_margin.intValue>=95?@"95":_weekDataModel.profit_margin;
        NSArray *a1 = @[@(w_win_rate.intValue<=20?20:w_win_rate.intValue), @(w_stability.intValue<=20?20:w_stability.intValue), @(w_win_rate_yp.intValue<=20?20:w_win_rate_yp.intValue), @(w_win_rate_jc.intValue<=20?20:w_win_rate_jc.intValue), @(w_win_rate_dx.intValue<=20?20:w_win_rate_dx.intValue), @(w_profit_margin.intValue<=20?20:w_profit_margin.intValue)];
        _w_p.dataSeries = @[a1];
    }
    else if (dataStyle == 3) {
        // 胜率
        [_m_winRateCircleChart reAnimateChartAtValue:[_monthDataModel.win_rate integerValue] totalValue:100];
//        if (_monthDataModel.win_rate.intValue >= 60) {
//            [_m_winRateCircleChart setlabelNumColor:ColorRateTitle];
//        }
//        else {
//            [_m_winRateCircleChart setlabelNumColor:ColorName];
//        }
        // 利润率
        [_m_profitRateCircleChart reAnimateChartAtValue:[_monthDataModel.profit_margin integerValue] totalValue:100];
//        if (_monthDataModel.profit_margin.intValue > 0) {
//            [_m_profitRateCircleChart setlabelNumColor:ColorRateTitle];
//        }
//        else {
//            [_m_profitRateCircleChart setlabelNumColor:ColorName];
//        }
        
        [_monthRecommendView setRecommendWinGames:_monthDataModel.win_count recommendGames:_monthDataModel.recommend_count];
        //让球胜率
        m_ypsl_num.text = [NSString stringWithFormat:@"%@％",_monthDataModel.win_rate_yp];
        //大小球胜率
        m_dxqsl_num.text = [NSString stringWithFormat:@"%@％",_monthDataModel.win_rate_dx];
        //胜平负胜率
        m_jcsl_num.text = [NSString stringWithFormat:@"%@％",_monthDataModel.win_rate_jc];
        //平均推荐水位
        m_pjtjsw_num.text = [NSString stringWithFormat:@"%.2f",_monthDataModel.water_level];
        //最高连红
        m_zglh_num.text = [NSString stringWithFormat:@"%@",_monthDataModel.max_continuous_win];
        //稳定性
        if (_monthDataModel.stability.intValue >= 0 && _monthDataModel.stability.intValue < 25) {
            m_wdx_num.text = @"差";
        }
        else if (_monthDataModel.stability.intValue >= 25 && _monthDataModel.stability.intValue < 50){
            m_wdx_num.text = @"中";
        }
        else if (_monthDataModel.stability.intValue >= 50 && _monthDataModel.stability.intValue < 75){
            m_wdx_num.text = @"良";
        }
        else if (_monthDataModel.stability.intValue >= 75  && _monthDataModel.stability.intValue <= 100){
            m_wdx_num.text = @"优";
        }
        
        
        if (_monthDataModel.max_continuous_win.intValue >= 3) {
            m_zglh_num.textColor = ColorRateTitle;
        }
        else {
            m_zglh_num.textColor = ColorName;
        }
        if (_monthDataModel.water_level >= 1.0) {
            m_pjtjsw_num.textColor = ColorRateTitle;
        }
        else {
            m_pjtjsw_num.textColor = ColorName;
        }
        if (_monthDataModel.win_rate_yp.intValue >= 70) {
            m_ypsl_num.textColor = ColorRateTitle;
        }
        else {
            m_ypsl_num.textColor = ColorName;
        }
        if (_monthDataModel.win_rate_dx.intValue >= 70) {
            m_dxqsl_num.textColor = ColorRateTitle;
        }
        else {
            m_dxqsl_num.textColor = ColorName;
        }
        if (_monthDataModel.win_rate_jc.intValue >= 70) {
            m_jcsl_num.textColor = ColorRateTitle;
        }
        else {
            m_jcsl_num.textColor = ColorName;
        }
        
        m_allBunkoLabel.text = [NSString stringWithFormat:@"总利润:%@",_monthDataModel.margin_sum];
        
        NSString* m_win_rate = _monthDataModel.win_rate.intValue>=95?@"95":_monthDataModel.win_rate;
        NSString* m_stability = _monthDataModel.stability.intValue>=95?@"95":_monthDataModel.stability;
        NSString* m_win_rate_yp = _monthDataModel.win_rate_yp.intValue>=95?@"95":_monthDataModel.win_rate_yp;
        NSString* m_win_rate_jc = _monthDataModel.win_rate_jc.intValue>=95?@"95":_monthDataModel.win_rate_jc;
        NSString* m_win_rate_dx = _monthDataModel.win_rate_dx.intValue>=95?@"95":_monthDataModel.win_rate_dx;
        NSString* m_profit_margin = _monthDataModel.profit_margin.intValue>=95?@"95":_monthDataModel.profit_margin;
        NSArray *a1 = @[@(m_win_rate.intValue<=20?20:m_win_rate.intValue), @(m_stability.intValue<=20?20:m_stability.intValue), @(m_win_rate_yp.intValue<=20?20:m_win_rate_yp.intValue), @(m_win_rate_jc.intValue<=20?20:m_win_rate_jc.intValue), @(m_win_rate_dx.intValue<=20?20:m_win_rate_dx.intValue), @(m_profit_margin.intValue<=20?20:m_profit_margin.intValue)];
        _m_p.dataSeries = @[a1];
        
        NSMutableArray* chartData = [NSMutableArray array];
        NSMutableArray* timeData = [NSMutableArray array];
        for (int i=0; i<_monthDataModel.recent.count; i++) {
            [chartData addObject:[_monthDataModel.recent[i] objectForKey:@"profit"]];
            [timeData addObject:[_monthDataModel.recent[i] objectForKey:@"date"]];
        }
        _m_lineChart.dataArray = timeData;
        NSString* maxCount = @"0";
        if (_monthDataModel.profit_max.intValue >= -_monthDataModel.profit_min.intValue) {
            maxCount = _monthDataModel.profit_max;
        }
        else {
            maxCount = [NSString stringWithFormat:@"%d",-_monthDataModel.profit_min.intValue];
        }
        _m_lineChart.maxLine = maxCount;
//        NSMutableArray* chartData = [NSMutableArray arrayWithObjects:@"5",@"15",@"5",@"25",@"15",@"5",@"10", nil];
        [_m_lineChart setChartData:chartData];
    }
    else if (dataStyle == 4) {
        // 胜率
        [_n_winRateCircleChart reAnimateChartAtValue:[_ninetyDataModel.win_rate integerValue] totalValue:100];
//        if (_ninetyDataModel.win_rate.intValue >= 60) {
//            [_n_winRateCircleChart setlabelNumColor:ColorRateTitle];
//        }
//        else {
//            [_n_winRateCircleChart setlabelNumColor:ColorName];
//        }
        // 利润率
        [_n_profitRateCircleChart reAnimateChartAtValue:[_ninetyDataModel.profit_margin integerValue] totalValue:100];
//        if (_ninetyDataModel.profit_margin.intValue > 0) {
//            [_n_profitRateCircleChart setlabelNumColor:ColorRateTitle];
//        }
//        else {
//            [_n_profitRateCircleChart setlabelNumColor:ColorName];
//        }
        
        [_ninetyRecommendView setRecommendWinGames:_ninetyDataModel.win_count recommendGames:_ninetyDataModel.recommend_count];
        //让球胜率
        n_ypsl_num.text = [NSString stringWithFormat:@"%@％",_ninetyDataModel.win_rate_yp];
        //大小球胜率
        n_dxqsl_num.text = [NSString stringWithFormat:@"%@％",_ninetyDataModel.win_rate_dx];
        //胜平负胜率
        n_jcsl_num.text = [NSString stringWithFormat:@"%@％",_ninetyDataModel.win_rate_jc];
        //平均推荐水位
        n_pjtjsw_num.text = [NSString stringWithFormat:@"%.2f",_ninetyDataModel.water_level];
        //最高连红
        n_zglh_num.text = [NSString stringWithFormat:@"%@",_ninetyDataModel.max_continuous_win];
        //稳定性
        if (_ninetyDataModel.stability.intValue >= 0 && _ninetyDataModel.stability.intValue < 25) {
            n_wdx_num.text = @"差";
        }
        else if (_ninetyDataModel.stability.intValue >= 25 && _ninetyDataModel.stability.intValue < 50){
            n_wdx_num.text = @"中";
        }
        else if (_ninetyDataModel.stability.intValue >= 50 && _ninetyDataModel.stability.intValue < 75){
            n_wdx_num.text = @"良";
        }
        else if (_ninetyDataModel.stability.intValue >= 75  && _ninetyDataModel.stability.intValue <= 100){
            n_wdx_num.text = @"优";
        }
        if (_ninetyDataModel.max_continuous_win.intValue >= 3) {
            n_zglh_num.textColor = ColorRateTitle;
        }
        else {
            n_zglh_num.textColor = ColorName;
        }
        if (_ninetyDataModel.water_level >= 1.0) {
            n_pjtjsw_num.textColor = ColorRateTitle;
        }
        else {
            n_pjtjsw_num.textColor = ColorName;
        }
        if (_ninetyDataModel.win_rate_yp.intValue >= 70) {
            n_ypsl_num.textColor = ColorRateTitle;
        }
        else {
            n_ypsl_num.textColor = ColorName;
        }
        if (_ninetyDataModel.win_rate_dx.intValue >= 70) {
            n_dxqsl_num.textColor = ColorRateTitle;
        }
        else {
            n_dxqsl_num.textColor = ColorName;
        }
        if (_ninetyDataModel.win_rate_jc.intValue >= 70) {
            n_jcsl_num.textColor = ColorRateTitle;
        }
        else {
            n_jcsl_num.textColor = ColorName;
        }
        
        
        NSString* n_win_rate = _ninetyDataModel.win_rate.intValue>=95?@"95":_ninetyDataModel.win_rate;
        NSString* n_stability = _ninetyDataModel.stability.intValue>=95?@"95":_ninetyDataModel.stability;
        NSString* n_win_rate_yp = _ninetyDataModel.win_rate_yp.intValue>=95?@"95":_ninetyDataModel.win_rate_yp;
        NSString* n_win_rate_jc = _ninetyDataModel.win_rate_jc.intValue>=95?@"95":_ninetyDataModel.win_rate_jc;
        NSString* n_win_rate_dx = _ninetyDataModel.win_rate_dx.intValue>=95?@"95":_ninetyDataModel.win_rate_dx;
        NSString* n_profit_margin = _ninetyDataModel.profit_margin.intValue>=95?@"95":_ninetyDataModel.profit_margin;
        NSArray *a1 = @[@(n_win_rate.intValue<=20?20:n_win_rate.intValue), @(n_stability.intValue<=20?20:n_stability.intValue), @(n_win_rate_yp.intValue<=20?20:n_win_rate_yp.intValue), @(n_win_rate_jc.intValue<=20?20:n_win_rate_jc.intValue), @(n_win_rate_dx.intValue<=20?20:n_win_rate_dx.intValue), @(n_profit_margin.intValue<=20?20:n_profit_margin.intValue)];
        _n_p.dataSeries = @[a1];
        
        NSMutableArray* chartData = [NSMutableArray array];
        NSMutableArray* timeData = [NSMutableArray array];
        for (int i=0; i<_ninetyDataModel.recent.count; i++) {
            [chartData addObject:[_ninetyDataModel.recent[i] objectForKey:@"profit"]];
            [timeData addObject:[_ninetyDataModel.recent[i] objectForKey:@"date"]];
        }
        _n_lineChart.dataArray = timeData;
        NSString* maxCount = @"0";
        if (_ninetyDataModel.profit_max.intValue >= -_ninetyDataModel.profit_min.intValue) {
            maxCount = _ninetyDataModel.profit_max;
        }
        else {
            maxCount = [NSString stringWithFormat:@"%d",-_ninetyDataModel.profit_min.intValue];
        }
        _n_lineChart.maxLine = maxCount;
        [_n_lineChart setChartData:chartData];
    }
}


@end
