
//  RYGArticleDetailView.m
//  shoumila
//
//  Created by 贾磊 on 16/4/9.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import "RYGArticleDetailView.h"
#import "RYGBarView.h"
#import "Masonry.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGUserCenterViewController.h"
#import "RYGStringUtil.h"

@interface RYGArticleDetailView ()<UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic ,strong)UIImageView *avatarImageView;
@property(nonatomic ,strong)UIImageView *header_pic;
@property(nonatomic ,strong)UILabel *name;
@property(nonatomic ,strong)UILabel *publish_time;
@property(nonatomic ,strong)UILabel *level;
@property(nonatomic ,strong)RYGBarView *barView;
@property(nonatomic ,strong)UIWebView *webView;
@property(nonatomic ,strong)UIView *bgView;
@property(nonatomic,strong) UILabel *max_continuous_tag;
@property(nonatomic,strong) UILabel *win_tag;
@property(nonatomic,strong) UIImageView   *rank_month;
@property(nonatomic,strong) UIImageView   *rank_week;
@property(nonatomic,strong) UILabel *readNumber;

@end

@implementation RYGArticleDetailView

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)]) {
        self.backgroundColor = [UIColor whiteColor];
        self.header_pic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 166*SCREEN_SCALE)];
//        self.header_pic.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.header_pic];

        self.avatarImageView = [UIImageView new];
        [self addSubview:self.avatarImageView];
        self.avatarImageView.layer.cornerRadius = 4;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.header_pic.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.mas_equalTo(@32);
            make.height.mas_equalTo(@32);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userCenterAction)];
        [self.avatarImageView addGestureRecognizer:tap];
        self.avatarImageView.userInteractionEnabled = YES;
        
        self.name = [UILabel new];
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = ColorName;
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.header_pic.mas_bottom).offset(15);
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.height.mas_equalTo(@16);
        }];

        self.level = [UILabel new];
        self.level.textColor = ColorYeallow;
        self.level.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.level];
        [self.level mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.mas_right).offset(5);
            make.top.equalTo(self.header_pic.mas_bottom).offset(15);
            make.height.mas_equalTo(@16);
        }];
        self.publish_time = [UILabel new];
        self.publish_time.font = [UIFont systemFontOfSize:10];
        self.publish_time.textColor = ColorRankMedal;
        [self addSubview:self.publish_time];
        [self.publish_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.name.mas_bottom).offset(7);
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.height.mas_equalTo(@11);
        }];
        
        self.win_tag = [UILabel new];
        self.win_tag.backgroundColor = ColorRateTitle;
        self.win_tag.layer.cornerRadius = 2;
        self.win_tag.layer.masksToBounds = YES;
        self.win_tag.textColor = [UIColor whiteColor];
        self.win_tag.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.win_tag];
        [self.win_tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.publish_time.mas_right).offset(5);
            make.top.equalTo(self.name.mas_bottom).offset(5);
            make.height.mas_equalTo(14);
        }];
        
        self.max_continuous_tag = [UILabel new];
        self.max_continuous_tag.backgroundColor = ColorRateTitle;
        self.max_continuous_tag.layer.cornerRadius = 2;
        self.max_continuous_tag.layer.masksToBounds = YES;
        self.max_continuous_tag.textColor = [UIColor whiteColor];
        self.max_continuous_tag.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.max_continuous_tag];
        [self.max_continuous_tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.win_tag.mas_right).offset(5);
            make.top.equalTo(self.name.mas_bottom).offset(5);
            make.height.mas_equalTo(14);
        }];
        
        self.rank_week = [UIImageView new];
        [self addSubview:self.rank_week];
        [self.rank_week mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.level.mas_right).offset(5);
            make.top.equalTo(self.header_pic.mas_bottom).offset(15);
            make.width.mas_equalTo(11);
            make.height.mas_equalTo(16);
        }];
        
        self.rank_month = [UIImageView new];
        [self addSubview:self.rank_month];
        [self.rank_month mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rank_week.mas_right).offset(5);
            make.top.equalTo(self.header_pic.mas_bottom).offset(15);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(16);
        }];
        
        self.readNumber = [UILabel new];
        self.readNumber.font = [UIFont systemFontOfSize:10];
        self.readNumber.textColor = ColorSecondTitle;
        [self addSubview:self.readNumber];
    
        self.webView = [UIWebView new];
        self.webView.scrollView.delegate = self;
        self.webView.scrollView.scrollEnabled = NO;
        [self addSubview:self.webView];
        self.webView.delegate = self;
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(15);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
        self.barView = [[RYGBarView alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:self.barView];
        [self addSubview:self.bgView];
    }
    return self;
}

-(void)setDynamicModel:(RYGDynamicFrame *)dynamicFrame{
    _dynamicModel = dynamicFrame;
    RYGDynamicModel *dynamicModel = dynamicFrame.dynamicModel;
    [self.header_pic setImageURLStr:dynamicModel.article.header_pic placeholder:[UIImage imageNamed:@"user_head"]];
    self.name.text = dynamicModel.publish_user.name;
    self.level.text = [NSString stringWithFormat:@"Lv.%@", dynamicModel.publish_user.grade];
    [self layoutIfNeeded];
    self.rank_month.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_month%@",dynamicModel.publish_user.rank_month]];
    self.rank_week.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_week%@",dynamicModel.publish_user.rank_week]];
    self.win_tag.text = dynamicModel.win_tag;
    self.max_continuous_tag.text = dynamicModel.max_continuous_tag;
    CGFloat readNumberLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"阅读:%@",dynamicModel.article.read_num] font:[UIFont systemFontOfSize:10] height:12];
    self.readNumber.text = [NSString stringWithFormat:@"阅读:%@",dynamicModel.article.read_num?:0];
    self.readNumber.frame = CGRectMake(SCREEN_WIDTH-15-readNumberLen, CGRectGetMinY(self.level.frame), readNumberLen, 12);
    
    self.publish_time.text = dynamicModel.publish_time;
    [self.avatarImageView setImageURLStr:dynamicModel.publish_user.avatar placeholder:nil];
    [self.webView loadHTMLString:dynamicModel.article.article_content baseURL:nil];
    self.barView.dynamicFrame = dynamicFrame;
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.barView.top + 30);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    self.webView.backgroundColor = [UIColor redColor];
    self.bgView.top = height+228;
    self.barView.top = self.bgView.top;
    [self addSubview:_barView];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.barView.top + 30);
    height +=260;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"headerViewHeightChange" object:@(height)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat frameHeight   = scrollView.frame.size.height;
    
    if(point.y < 0)
    {
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
    }
    else if(contentHeight > frameHeight)
    {
        if(contentHeight - point.y < frameHeight)
        {
            [scrollView setContentOffset:CGPointMake(point.x, contentHeight - frameHeight) animated:NO];
        }
    }
    else if(contentHeight <= frameHeight)
    {
        [scrollView setContentOffset:CGPointMake(point.x, 0) animated:NO];
    }
    
}

- (void)userCenterAction{
    if ([RYGUtility validateUserLogin]){
        RYGUserCenterViewController *userCenterVC = [[RYGUserCenterViewController alloc]init];
        userCenterVC.userId = _dynamicModel.dynamicModel.publish_user.userid;
        [[RYGUtility getCurrentVC] pushViewController:userCenterVC animated:YES];
    }
}

@end
