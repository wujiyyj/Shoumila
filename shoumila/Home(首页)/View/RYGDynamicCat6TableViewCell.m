//
//  RYGDynamicCat6TableViewCell.m
//  shoumila
//
//  Created by 贾磊 on 16/4/6.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import "RYGDynamicCat6TableViewCell.h"
#import "Masonry.h"
#import "RYGGrandeMarkView.h"
#import "UIImageView+RYGWebCache.h"
#import "MBProgressHUD+MJ.h"
#import "RYGOperationView.h"
#import "RYGUserCenterViewController.h"

@interface RYGDynamicCat6TableViewCell ()
@property(nonatomic ,strong)UILabel *headerLabel;
@property(nonatomic ,strong)UIView *headerView;
@property(nonatomic ,strong)UIImageView *avatarImageView;
@property(nonatomic ,strong)UIImageView *header_pic;
@property(nonatomic ,strong)UILabel *name;
@property(nonatomic ,strong)UILabel *publish_time;
@property(nonatomic ,strong)UILabel *levelNum;
@property(nonatomic ,strong)UILabel *content;
@property(nonatomic,strong) UILabel *level;
@property(nonatomic, strong)UIView *footerView;
@property(nonatomic,strong) UIButton *arrow;
@property(nonatomic,strong) UIButton *arrowBg;
@property(nonatomic,strong) UIImageView *readImage;
@property(nonatomic,strong) UILabel *readLabel;
@property(nonatomic,strong) UILabel *max_continuous_tag;
@property(nonatomic,strong) UILabel *win_tag;
@property(nonatomic,strong) UIImageView   *rank_month;
@property(nonatomic,strong) UIImageView   *rank_week;

@end

@implementation RYGDynamicCat6TableViewCell

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor colorWithHexadecimal:@"#f5f5f5"];
        UILabel *lable = [UILabel new];
        lable.text = @"点击进入";
        lable.textColor = [UIColor colorWithHexadecimal:@"#999999"];
        lable.font = [UIFont systemFontOfSize:12];
        [_headerView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-25);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(25);
        }];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_arrow"]];
        [_headerView addSubview:imageView];
        imageView.frame = CGRectMake(SCREEN_WIDTH - 20, 6, 8, 14);
    }
    return _headerView;
}
- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.backgroundColor = [UIColor colorWithHexadecimal:@"#f5f5f5"];
        _headerLabel.text = @"小凯撒的竞选文章";
        _headerLabel.textColor = [UIColor colorWithHexadecimal:@"#999999"];
        _headerLabel.font = [UIFont systemFontOfSize:12];
    }
    return _headerLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.height.mas_equalTo(@25);
        }];
        [self.headerView addSubview:self.headerLabel];
        [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_left).offset(15);
            make.top.equalTo(self.headerView.mas_top).offset(0);
            make.bottom.equalTo(self.headerView.mas_bottom).offset(0);
        }];
        self.avatarImageView = [UIImageView new];
        [self addSubview:self.avatarImageView];
        self.avatarImageView.layer.cornerRadius = 4;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userAction)];
        [self.avatarImageView addGestureRecognizer:gesture];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.mas_equalTo(@32);
            make.height.mas_equalTo(@32);
        }];
        
        self.name = [UILabel new];
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = ColorName;
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.top.equalTo(self.headerView.mas_bottom).offset(15);
            make.height.mas_equalTo(@16);
        }];
        
        self.level = [UILabel new];
        self.level.textColor = ColorYeallow;
        self.level.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.level];
        [self.level mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.name.mas_right).offset(5);
            make.top.equalTo(self.headerView.mas_bottom).offset(15);
            make.height.mas_equalTo(@16);
        }];
        
        self.rank_week = [UIImageView new];
        [self addSubview:self.rank_week];
        [self.rank_week mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.level.mas_right).offset(5);
            make.top.equalTo(self.headerView.mas_bottom).offset(15);
            make.width.mas_equalTo(11);
            make.height.mas_equalTo(16);
        }];
        self.rank_month = [UIImageView new];
        [self addSubview:self.rank_month];
        [self.rank_month mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rank_week.mas_right).offset(5);
            make.top.equalTo(self.headerView.mas_bottom).offset(15);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(16);
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

        self.content = [UILabel new];
        self.content.numberOfLines = 0;
        self.content.font = [UIFont systemFontOfSize:14];
        self.content.textColor = ColorName;
        [self addSubview:self.content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        self.header_pic = [UIImageView new];
        self.header_pic.contentMode = UIViewContentModeScaleAspectFill;
        self.header_pic.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.header_pic.clipsToBounds  = YES;
        [self addSubview:self.header_pic];
        [self.header_pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.content.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(@(133*SCREEN_SCALE));
        }];
        self.readImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"readNum"]];
        [self addSubview:self.readImage];
        [self.readImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.header_pic.mas_bottom).offset(13);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        self.readLabel = [UILabel new];
        self.readLabel.text = @"阅读:";
        self.readLabel.textColor = ColorSecondTitle;
        self.readLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.readLabel];
        [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.header_pic.mas_bottom).offset(10);
            make.left.equalTo(self.readImage.mas_right).offset(5);
            make.height.mas_equalTo(@20);
        }];
        self.barView = [[RYGBarView alloc]init];
        [self addSubview:self.barView];
        [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.header_pic.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@190);
        }];
        self.footerView = [UIView new];
        self.footerView.backgroundColor = ColorCellBackground;
        [self addSubview:self.footerView];
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.barView.mas_bottom).offset(5);
            make.height.mas_equalTo(@10);
        }];
        
        _arrow = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -29, 35, 14, 8)];
        [_arrow setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [self addSubview:_arrow];
        _arrowBg = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -45, 35, 40, 20)];
        [self addSubview:_arrowBg];
        [_arrowBg addTarget:self action:@selector(arrowAction) forControlEvents:UIControlEventTouchDown];
        
        }
    return self;
}

- (void)arrowAction{
    RYGOperationView *operation = [[RYGOperationView alloc]init];
    [[UIApplication sharedApplication].keyWindow addSubview:operation];
    operation.dynamicFrame = self.dynamicFrame;
    [operation arrowAction:self];
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    RYGDynamicModel *dynamicModel = dynamicFrame.dynamicModel;
    [self.avatarImageView setImageURLStr:dynamicModel.publish_user.avatar placeholder:[UIImage imageNamed:@"user_head"]];
    self.headerLabel.text = [NSString stringWithFormat:@"%@的精选文章",dynamicModel.publish_user.name];
    self.name.text = dynamicModel.publish_user.name;
    self.level.text = [NSString stringWithFormat:@"Lv.%@", dynamicModel.publish_user.grade];
    self.publish_time.text = dynamicModel.publish_time;
    self.win_tag.text = dynamicModel.win_tag;
    self.max_continuous_tag.text = dynamicModel.max_continuous_tag;
    self.content.text = dynamicModel.article.title;
    self.readLabel.text = [NSString stringWithFormat:@"阅读%@",dynamicModel.article.read_num?:0];
    [self.header_pic setImageURLStr:dynamicModel.article.header_pic placeholder:[UIImage imageNamed:@"default_picture"]];
    self.rank_month.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_month%@",dynamicModel.publish_user.rank_month]];
    self.rank_week.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_week%@",dynamicModel.publish_user.rank_week]];
    _barView.dynamicFrame = dynamicFrame;
    [self layoutIfNeeded];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
    [super touchesBegan:touches withEvent:event];
}

- (void)configCellWithModel:(RYGDynamicModel *)model{
    self.content.text = model.article.content;
}

+ (CGFloat)heightWithModel:(RYGDynamicFrame *)dynamicFrame{
    RYGDynamicCat6TableViewCell *cell = [[RYGDynamicCat6TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell configCellWithModel:dynamicFrame.dynamicModel];
    [cell layoutIfNeeded];
    CGRect frame =  cell.footerView.frame;
    CGFloat cellHeight = frame.origin.y;
    return cellHeight;

}
- (void)userAction{
    RYGUserCenterViewController *userCenterVC = [[RYGUserCenterViewController alloc]init];
    NSString *name = self.dynamicFrame.dynamicModel.publish_user.userid;
    userCenterVC.userId = name;
    [[RYGUtility getCurrentVC] pushViewController:userCenterVC animated:YES];
}

@end
