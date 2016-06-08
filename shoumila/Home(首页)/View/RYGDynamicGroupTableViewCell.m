//
//  RYGDynamicGroupTableViewCell.m
//  shoumila
//
//  Created by 贾磊 on 16/4/9.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import "RYGDynamicGroupTableViewCell.h"
#import "Masonry.h"
#import "RYGOperationView.h"
#import "UIImageView+RYGWebCache.h"
#import "MLEmojiLabel.h"
#import "RYGStringUtil.h"


@interface RYGDynamicGroupTableViewCell ()<MLEmojiLabelDelegate>
@property(nonatomic ,strong)UILabel *headerLabel;
@property(nonatomic ,strong)UIView *headerView;
@property(nonatomic ,strong)UIImageView *avatarImageView;
@property(nonatomic ,strong)UILabel *name;
@property(nonatomic ,strong)UILabel *publish_time;
@property(nonatomic ,strong)UILabel *levelNum;
@property(nonatomic,strong) UILabel *level;
@property(nonatomic, strong)UIView *footerView;
@property(nonatomic,strong) UIButton *arrow;
@property(nonatomic,strong) UIButton *arrowBg;
@property(nonatomic,strong)  MLEmojiLabel *emojiLabel;
@property(nonatomic,strong) UIImageView *backgroudImageView;
@property(nonatomic,strong) UILabel *lable;
@property(nonatomic,strong) UILabel *max_continuous_tag;
@property(nonatomic,strong) UILabel *win_tag;
@property(nonatomic,strong) UILabel *sevenDay;
@property(nonatomic,strong) UILabel *praiseNumLabel;
@property(nonatomic,strong) UILabel *commentNumLabel;
@property(nonatomic,assign) BOOL isShowPopup;
@property(nonatomic,strong) UIButton *popup;
@property(nonatomic,strong) UILabel *popupLabel1;
@property(nonatomic,strong) UILabel *popupLabel2;
@property(nonatomic,strong) UILabel *popupLabel3;
@property(nonatomic,strong) UIImageView   *rank_month;
@property(nonatomic,strong) UIImageView   *rank_week;
@property(nonatomic,strong) UIImageView   *stampView;

@end

@implementation RYGDynamicGroupTableViewCell

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor colorWithHexadecimal:@"#f5f5f5"];
        _lable = [UILabel new];
        _lable.text = @"今日已推：";
        _lable.textColor = [UIColor colorWithHexadecimal:@"#999999"];
        _lable.font = [UIFont systemFontOfSize:12];
        [_headerView addSubview:_lable];
        [_lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-25);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(25);
        }];
    }
    return _headerView;
}
- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.backgroundColor = [UIColor colorWithHexadecimal:@"#f5f5f5"];
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
            make.top.mas_equalTo(0);
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
        self.win_tag.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.win_tag];
//        [self.win_tag mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.publish_time.mas_right).offset(10);
//            make.top.equalTo(self.name.mas_bottom).offset(5);
//            make.height.mas_equalTo(14);
//        }];
        self.max_continuous_tag = [UILabel new];
        self.max_continuous_tag.backgroundColor = ColorRateTitle;
        self.max_continuous_tag.layer.cornerRadius = 2;
        self.max_continuous_tag.layer.masksToBounds = YES;
        self.max_continuous_tag.textColor = [UIColor whiteColor];
        self.max_continuous_tag.font = [UIFont systemFontOfSize:10];
        self.max_continuous_tag.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.max_continuous_tag];
//        [self.max_continuous_tag mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.win_tag.mas_right).offset(10);
//            make.top.equalTo(self.name.mas_bottom).offset(5);
//            make.height.mas_equalTo(14);
//        }];
        self.backgroudImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backbroundImage"]];
        self.backgroudImageView.userInteractionEnabled = YES;
        [self addSubview:self.backgroudImageView];
        [self.backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        self.emojiLabel = [MLEmojiLabel new];
        self.emojiLabel.textColor = ColorName;
        self.emojiLabel.font = [UIFont systemFontOfSize:15];
        self.emojiLabel.numberOfLines = 0;
        self.emojiLabel.isNeedAtAndPoundSign = YES;
        self.emojiLabel.disableThreeCommon = YES;
        self.emojiLabel.delegate = self;
        [self.backgroudImageView addSubview:self.emojiLabel];
        [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-5);
        }];
        _popup = [[UIButton alloc]initWithFrame:CGRectMake(100, 15, 155, 51)];
        [_popup setBackgroundImage:[UIImage imageNamed:@"tanceng"] forState:UIControlStateNormal];
        
        _popupLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 155, 15)];
        _popupLabel1.backgroundColor = [UIColor clearColor];
        _popupLabel1.textColor = ColorName;
        _popupLabel1.numberOfLines = 0;
        _popupLabel1.font = [UIFont systemFontOfSize:10];
        _popupLabel1.textAlignment = NSTextAlignmentCenter;
        [_popup addSubview:_popupLabel1];
        
        _popupLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 155, 15)];
        _popupLabel2.backgroundColor = [UIColor clearColor];
        _popupLabel2.textColor = ColorName;
        _popupLabel2.numberOfLines = 0;
        _popupLabel2.font = [UIFont systemFontOfSize:10];
        _popupLabel2.textAlignment = NSTextAlignmentCenter;
        [_popup addSubview:_popupLabel2];
        
        _popupLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, 155, 15)];
        _popupLabel3.backgroundColor = [UIColor clearColor];
        _popupLabel3.textColor = ColorName;
        _popupLabel3.numberOfLines = 0;
        _popupLabel3.font = [UIFont systemFontOfSize:10];
        _popupLabel3.textAlignment = NSTextAlignmentCenter;
        [_popup addSubview:_popupLabel3];
        
        self.commentNumLabel = [UILabel new];
        [self addSubview:self.commentNumLabel];
        self.commentNumLabel.textColor = ColorName;
        self.commentNumLabel.font = [UIFont systemFontOfSize:12];
        [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emojiLabel.mas_bottom).offset(10);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(12);
        }];

        self.praiseNumLabel = [UILabel new];
        [self addSubview:self.praiseNumLabel];
        self.praiseNumLabel.textColor = ColorName;
        self.praiseNumLabel.font = [UIFont systemFontOfSize:12];
        [self.praiseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emojiLabel.mas_bottom).offset(10);
            make.right.equalTo(self.commentNumLabel.mas_left).offset(-12);
            make.height.mas_equalTo(12);
        }];
        
        self.sevenDay = [UILabel new];
        [self addSubview:self.sevenDay];
        self.sevenDay.textColor = ColorName;
        self.sevenDay.text = @"近7天获得";
        self.sevenDay.font = [UIFont systemFontOfSize:12];
        [self.sevenDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emojiLabel.mas_bottom).offset(10);
            make.right.equalTo(self.praiseNumLabel.mas_left).offset(-12);
            make.height.mas_equalTo(12);
        }];
        
        self.footerView = [UIView new];
        self.footerView.backgroundColor = ColorCellBackground;
        [self addSubview:self.footerView];
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.commentNumLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(@10);
        }];
        
        _arrow = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -29, 35, 14, 8)];
        [_arrow setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [self addSubview:_arrow];
        _arrowBg = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -45, 35, 40, 20)];
        [self addSubview:_arrowBg];
        [_arrowBg addTarget:self action:@selector(arrowAction) forControlEvents:UIControlEventTouchDown];
        _stampView = [[UIImageView alloc]init];
        [self addSubview:_stampView];
        [_stampView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
            make.left.mas_equalTo(SCREEN_WIDTH - 100);
            make.bottom.equalTo(self.sevenDay.mas_bottom).offset(0);
        }];
    }
    return self;
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
            _popupLabel1.text = _dynamicFrame.dynamicModel.popup_a;
            _popupLabel2.text = _dynamicFrame.dynamicModel.popup_b;
            _popupLabel3.text = _dynamicFrame.dynamicModel.popup_c;
//            float top = [[[NSUserDefaults standardUserDefaults] valueForKey:@"popTop"] floatValue];
//            _popup.top = top + 25;
            _popup.top = 40;
            if (!_isShowPopup) {
                [self addSubview:_popup];
                _isShowPopup = YES;
            }else{
                [_popup removeFromSuperview];
                _isShowPopup = NO;
            }
        }
            break;
        case MLEmojiLabelLinkTypePoundSign:
        {
            
//            if ([RYGUtility validateUserLogin]){
//                RYGUserCenterViewController *userCenterVC = [[RYGUserCenterViewController alloc]init];
//                NSString *name = [link substringWithRange:NSMakeRange(1, link.length-1)];
//                userCenterVC.user_name = name;
//                [[RYGUtility getCurrentVC] pushViewController:userCenterVC animated:YES];
//            }
            
            break;
        }
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
    [super touchesBegan:touches withEvent:event];
}

- (void)tapView{
    if (_popup) {
        [_popup removeFromSuperview];
    }
}

- (void)arrowAction{
    RYGOperationView *operation = [[RYGOperationView alloc]init];
    [[UIApplication sharedApplication].keyWindow addSubview:operation];
    operation.dynamicFrame = self.dynamicFrame;
    [operation arrowAction:self];
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapView) name:kRemoveView object:nil];
    _dynamicFrame = dynamicFrame;
    RYGDynamicModel *dynamicModel = dynamicFrame.dynamicModel;
    [self.avatarImageView setImageURLStr:dynamicModel.publish_user.avatar placeholder:[UIImage imageNamed:@"user_head"]];
    self.headerLabel.text = [NSString stringWithFormat:@"%@的滚球组合",dynamicModel.publish_user.name];
    self.name.text = dynamicModel.publish_user.name;
    self.level.text = [NSString stringWithFormat:@"Lv.%@", dynamicModel.publish_user.grade];
    
    self.publish_time.text = [NSString stringWithFormat:@"最新发布 %@",dynamicModel.publish_time];
    CGFloat publish_timeLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@",self.publish_time.text] font:[UIFont systemFontOfSize:10] height:11];
    self.publish_time.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame)+10, CGRectGetMaxY(self.name.frame)+7, publish_timeLen, 11);
    
    [self layoutIfNeeded];
    self.rank_month.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_month%@",dynamicModel.publish_user.rank_month]];
    self.rank_week.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_week%@",dynamicModel.publish_user.rank_week]];
    
    CGFloat win_tagLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@",dynamicModel.win_tag] font:[UIFont systemFontOfSize:10] height:14]+5;
    if(dynamicModel.win_tag&&![dynamicModel.win_tag isEqualToString:@""]){
        self.win_tag.hidden = NO;
        self.win_tag.text = dynamicModel.win_tag;
        self.win_tag.frame = CGRectMake(CGRectGetMaxX(self.publish_time.frame)+10, CGRectGetMinY(self.publish_time.frame), win_tagLen, 14);
    }else{
        self.win_tag.hidden = YES;
    }
    
    CGFloat max_continuousLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@",dynamicModel.max_continuous_tag] font:[UIFont systemFontOfSize:10] height:14]+5;
    if(dynamicModel.max_continuous_tag&&![dynamicModel.max_continuous_tag isEqualToString:@""]){
        self.max_continuous_tag.hidden = NO;
        self.max_continuous_tag.text = dynamicModel.max_continuous_tag;
        if(dynamicModel.win_tag&&![dynamicModel.win_tag isEqualToString:@""]){
            self.max_continuous_tag.frame = CGRectMake(CGRectGetMaxX(self.win_tag.frame)+10, CGRectGetMinY(self.publish_time.frame), max_continuousLen, 14);
        }
        else {
            self.max_continuous_tag.frame = CGRectMake(CGRectGetMaxX(self.publish_time.frame)+10, CGRectGetMinY(self.publish_time.frame), max_continuousLen, 14);
        }
    }else{
        self.max_continuous_tag.hidden = YES;
    }
    NSString *stapName = [NSString stringWithFormat:@"stamp%@",dynamicModel.stamp];
    _stampView.image = [UIImage imageNamed:stapName];
    
    self.emojiLabel.text = dynamicModel.content;
//    [self layoutIfNeeded];
//    self.backgroudImageView.height = self.emojiLabel.height;
    self.lable.text = [NSString stringWithFormat:@"今日已推:%@",dynamicModel.today_publish?:0];
    self.commentNumLabel.text = [NSString stringWithFormat:@"%@评论",dynamicModel.comment_num];
    self.praiseNumLabel.text = [NSString stringWithFormat:@"%@赞",dynamicModel.praise_num];
    [self layoutIfNeeded];
}

- (void)configCellWithModel:(RYGDynamicModel *)model{
    self.emojiLabel.text = model.content;
    [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5);
    }];
}

+ (CGFloat)heightWithModel:(RYGDynamicFrame *)dynamicFrame{
    RYGDynamicGroupTableViewCell *cell = [[RYGDynamicGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell configCellWithModel:dynamicFrame.dynamicModel];
    [cell layoutIfNeeded];
    CGRect frame =  cell.footerView.frame;
    CGFloat cellHeight = frame.origin.y + frame.size.height;
    return cellHeight;
    
}



@end
