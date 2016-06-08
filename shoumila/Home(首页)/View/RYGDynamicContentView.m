//
//  RYGDynamicContentView.m
//  shoumila
//
//  Created by 贾磊 on 15/9/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicContentView.h"
#import "RYGPhotosView.h"
#import "RYGGrandeMarkView.h"
#import "RYGDynamicUserModel.h"
#import "UIImageView+WebCache.h"
#import "RYGHttpRequest.h"
#import "MBProgressHUD+MJ.h"
#import "RYGPersonalUserModel.h"
#import "MLEmojiLabel.h"
#import "RYGFeedIdParam.h"
#import "RYGUserCenterViewController.h"
#import "RYGReportViewController.h"
#import "RYGNavigationController.h"
#import "RYGAttentionParam.h"
#import "RYGFavoriteParam.h"
#import "Masonry.h"
#import "RYGStringUtil.h"

@interface RYGDynamicContentView ()<MLEmojiLabelDelegate>
@property(nonatomic,weak) UIImageView *avatar;
@property(nonatomic,weak) UILabel *name;
@property(nonatomic,weak) UILabel *publish_time;
@property(nonatomic,strong) UILabel *level;
@property(nonatomic,strong) UIButton *arrow;
@property(nonatomic,strong) UIButton *arrowBg;
@property(nonatomic,weak) UIButton *type;
@property(nonatomic,weak) MLEmojiLabel  *content;
@property(nonatomic,weak) RYGPhotosView *photosView;
@property(nonatomic,weak) UIImageView   *redView;
@property(nonatomic,strong) UIImageView   *stampView;
@property(nonatomic,strong) UIView   *tancengView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIButton *delBtn;
@property(nonatomic,strong) UIButton *lockBtn;
@property(nonatomic,strong) UIButton *hideBtn;
@property(nonatomic,strong) UIButton *closureBtn;
@property(nonatomic,strong) UIButton *shoucangBtn;
@property(nonatomic,strong) UIButton *laheiBtn;
@property(nonatomic,strong) UIButton *reportBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,assign) BOOL isShowPopup;
@property(nonatomic,strong) UIButton *popup;
@property(nonatomic,strong) UILabel *popupLabel1;
@property(nonatomic,strong) UILabel *popupLabel2;
@property(nonatomic,strong) UILabel *popupLabel3;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UILabel *fullMsgLabel;
@property(nonatomic,strong) UILabel *max_continuous_tag;
@property(nonatomic,strong) UILabel *win_tag;
@property(nonatomic,strong) UIImageView   *rank_month;
@property(nonatomic,strong) UIImageView   *rank_week;
@end
@implementation RYGDynamicContentView

- (UILabel *)fullMsgLabel{
    if (!_fullMsgLabel) {
        _fullMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 15)];
        _fullMsgLabel.text = @"查看全部信息";
        _fullMsgLabel.textColor = ColorTabBarButtonTitleSelected;
        _fullMsgLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _fullMsgLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *avatar = [[UIImageView alloc]init];
        avatar.layer.masksToBounds = YES;
        avatar.layer.cornerRadius = 4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userCenterAction)];
        [avatar addGestureRecognizer:tap];
        avatar.userInteractionEnabled = YES;
        [self addSubview:avatar];
        _avatar = avatar;
        
        UILabel *name = [[UILabel alloc]init];
        name.textColor = ColorName;
        name.font = [UIFont systemFontOfSize:15];
        [self addSubview:name];
        _name = name;
        
        UILabel *publish_time = [[UILabel alloc]init];
        publish_time.font = [UIFont systemFontOfSize:10];
        publish_time.textColor = ColorRankMedal;
        [self addSubview:publish_time];
        _publish_time = publish_time;
        
        self.max_continuous_tag = [UILabel new];
        self.max_continuous_tag.backgroundColor = ColorRateTitle;
        self.max_continuous_tag.layer.cornerRadius = 2;
        self.max_continuous_tag.layer.masksToBounds = YES;
        self.max_continuous_tag.textColor = [UIColor whiteColor];
        self.max_continuous_tag.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.max_continuous_tag];
        
        self.win_tag = [UILabel new];
        self.win_tag.backgroundColor = ColorRateTitle;
        self.win_tag.layer.cornerRadius = 2;
        self.win_tag.layer.masksToBounds = YES;
        self.win_tag.textColor = [UIColor whiteColor];
        self.win_tag.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.win_tag];
        
        self.level = [UILabel new];
        self.level.textColor = ColorYeallow;
        self.level.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.level];
        
        self.rank_week = [UIImageView new];
        [self addSubview:self.rank_week];
        [self.rank_week mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.level.mas_right).offset(5);
            make.top.mas_equalTo(15);
            make.width.mas_equalTo(11);
            make.height.mas_equalTo(16);
        }];
        self.rank_month = [UIImageView new];
        [self addSubview:self.rank_month];
        [self.rank_month mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rank_week.mas_right).offset(5);
            make.top.mas_equalTo(15);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(16);
        }];
        
        _arrow = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -29, 15, 14, 8)];
        [self addSubview:_arrow];
        _arrowBg = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -45, 15, 40, 40)];
        [self addSubview:_arrowBg];
        [_arrowBg addTarget:self action:@selector(arrowAction) forControlEvents:UIControlEventTouchDown];
        UIButton *type = [[UIButton alloc]init];
        [type setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [type setBackgroundColor:[UIColor redColor]];
        type.layer.cornerRadius = 2;
        [self addSubview:type];
        _type = type;
        
        MLEmojiLabel *content = [MLEmojiLabel new];
        content.textColor = ColorName;
        content.font = [UIFont systemFontOfSize:15];
        content.numberOfLines = 0;
        content.isNeedAtAndPoundSign = YES;
        content.disableThreeCommon = YES;
        content.delegate = self;
        [self addSubview:content];
        _content = content;
        
        RYGPhotosView *photosView = [[RYGPhotosView alloc] init];
        [self addSubview:photosView];
        _photosView = photosView;
        
        UIImageView *redView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 133, 15, 57, 37)];
        [self addSubview:redView];
        _redView = redView;
        
        _stampView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 100, 100, 100)];
        
        _tancengView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70)];
        _tancengView.backgroundColor = ColorLine;
        _tancengView.userInteractionEnabled = YES;
        _shoucangBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _shoucangBtn.backgroundColor = ColorShareView;
        
        
        _delBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _delBtn.backgroundColor = ColorShareView;
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_delBtn];
        
        _lockBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _lockBtn.backgroundColor = ColorShareView;
        [_lockBtn setTitle:@"锁定" forState:UIControlStateNormal];
        [_lockBtn setTitle:@"已锁定" forState:UIControlStateSelected];
        [_lockBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_lockBtn addTarget:self action:@selector(lockAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_lockBtn];
        
        _hideBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _hideBtn.backgroundColor = ColorShareView;
        [_hideBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        [_hideBtn setTitle:@"已隐藏" forState:UIControlStateSelected];
        [_hideBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_hideBtn addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_hideBtn];
        
        _closureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _closureBtn.backgroundColor = ColorShareView;
        [_closureBtn setTitle:@"禁言" forState:UIControlStateNormal];
        [_closureBtn setTitle:@"已禁言" forState:UIControlStateSelected];
        [_closureBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_closureBtn addTarget:self action:@selector(closureAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_closureBtn];
        
        [_shoucangBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_shoucangBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
        [_shoucangBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_shoucangBtn addTarget:self action:@selector(shouchang) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_shoucangBtn];
        
        _laheiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _laheiBtn.backgroundColor = ColorShareView;
        [_laheiBtn setTitle:@"拉黑" forState:UIControlStateNormal];
        [_laheiBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_laheiBtn addTarget:self action:@selector(lahei) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_laheiBtn];

        _reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _reportBtn.backgroundColor = ColorShareView;
        [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
        [_reportBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_reportBtn addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_reportBtn];
        
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _cancelBtn.backgroundColor = ColorShareView;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_cancelBtn];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.0;
        [_bgView addGestureRecognizer:tapGesture];
        
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
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 28, 15)];
        _label.backgroundColor = [UIColor redColor];
        _label.text = @"赛前";
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:11];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.cornerRadius = 2;
//        [_content addSubview:_label];
        
    }
    return self;
}

//设置frame
-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    RYGDynamicUserModel *user =model.publish_user;
    self.frame = dynamicFrame.contentViewF;
    _name.text = user.name;
    _name.frame = dynamicFrame.nameF;
    float x = CGRectGetMaxX(_name.frame) + 5;
    float y = _name.top;
    _level.frame = CGRectMake(x, y, 35, _name.height);
    _level.text = [NSString stringWithFormat:@"Lv.%@",user.grade];
    _publish_time.frame = dynamicFrame.publish_timeF;
    _publish_time.text = model.publish_time;
    if (_isDeatil) {
//        [_arrow setTitle:@"" forState:UIControlStateNormal];
//        [_arrow setTitleColor:ColorName forState:UIControlStateNormal];
        _arrow.hidden = YES;

    }else{
        _arrow.hidden = NO;
        [_arrow setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    }
    [self layoutIfNeeded];
    self.rank_month.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_month%@",model.publish_user.rank_month]];
    self.rank_week.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_week%@",model.publish_user.rank_week]];
    _avatar.frame = dynamicFrame.avatarF;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"user_head"]];
    
    CGFloat win_tagLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@",model.win_tag] font:[UIFont systemFontOfSize:10] height:14]+5;
    if(model.win_tag&&![model.win_tag isEqualToString:@""]){
        self.win_tag.hidden = NO;
        self.win_tag.text = model.win_tag;
        self.win_tag.textAlignment = NSTextAlignmentCenter;
        self.win_tag.frame = CGRectMake(CGRectGetMaxX(self.publish_time.frame)+10, CGRectGetMinY(self.publish_time.frame), win_tagLen, 14);
    }else{
        self.win_tag.hidden = YES;
    }
    
    CGFloat max_continuousLen = [RYGStringUtil getLabelLength:[NSString stringWithFormat:@"%@",model.max_continuous_tag] font:[UIFont systemFontOfSize:10] height:14]+5;
    if(model.max_continuous_tag&&![model.max_continuous_tag isEqualToString:@""]){
        self.max_continuous_tag.hidden = NO;
        self.max_continuous_tag.text = model.max_continuous_tag;
        self.max_continuous_tag.textAlignment = NSTextAlignmentCenter;
        if(model.win_tag&&![model.win_tag isEqualToString:@""]){
            self.max_continuous_tag.frame = CGRectMake(CGRectGetMaxX(self.win_tag.frame)+10, CGRectGetMinY(self.publish_time.frame), max_continuousLen, 14);
        }
        else {
            self.max_continuous_tag.frame = CGRectMake(CGRectGetMaxX(self.publish_time.frame)+10, CGRectGetMinY(self.publish_time.frame), max_continuousLen, 14);
        }
    }else{
        self.max_continuous_tag.hidden = YES;
    }
    _content.frame = dynamicFrame.contentF;
    //赛前加标签
//    if (1 == [model.type intValue]) {
//        NSString *contentStr = [NSString stringWithFormat:@"        %@",model.content];
//        _content.emojiText = contentStr;
//        _label.alpha = 1;
//    }else{
//        _label.alpha = 0;
//    }
    if (_content.height==220) {
        [self addSubview:self.fullMsgLabel];
        self.fullMsgLabel.top = CGRectGetMaxY(_content.frame)+3;
    }else{
        _content.height +=5;
        [self.fullMsgLabel removeFromSuperview];
    }
    _content.text = model.content;
    _photosView.frame = dynamicFrame.photosViewF;
    _photosView.photos = model.pics;
    NSString *redName = [NSString stringWithFormat:@"red%@",user.max_continuous_win];
    _redView.image = [UIImage imageNamed:redName];
    if ([model.stamp boolValue]) {
        NSString *stapName = [NSString stringWithFormat:@"stamp%@",model.stamp];
        _stampView.image = [UIImage imageNamed:stapName];
        _stampView.top = self.height - 100;
        [self addSubview:_stampView];
    }else{
        [_stampView removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapView) name:kRemoveView object:nil];
    
    
    //设置更多操作frame
    RYGUserInfoModel *userModel = [RYGUtility getUserInfo];
    
    float top = 1.0f;
    if ([userModel.is_admin isEqualToString:@"1"]) {
        _delBtn.top = top;
        top = top + 45;
        _lockBtn.top = top;
        top = top + 45;
        _hideBtn.top = top;
        top = top + 45;
        _closureBtn.top = top;
        top = top + 45;
    }
    _shoucangBtn.top = top;
    top = top + 45;
    _laheiBtn.top = top;
    top = top + 45;
    _reportBtn.top = top;
    top = top + 48;
    _cancelBtn.top = top;
    top = top + 45;
    _tancengView.height = top;
    
    if ([model.is_favorite boolValue]) {
        _shoucangBtn.selected = YES;
    }
    if ([model.is_lock boolValue]) {
        _lockBtn.selected = YES;
    }
    if ([model.is_hide boolValue]) {
        _hideBtn.selected = YES;
    }
    if ([model.is_closure boolValue]) {
        _closureBtn.selected = YES;
    }
    [self layoutIfNeeded];
}

//更多操作
- (void)arrowAction{
    if (![RYGUtility validateUserLogin]) {
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:UIKeyboardWillHideNotification object:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_tancengView];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.3;
        _tancengView.top = SCREEN_HEIGHT - _tancengView.height;
    }];
    
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

- (void)cancelAction{
    [UIView animateWithDuration:0.3 animations:^{
        _tancengView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (_bgView) {
            [_bgView removeFromSuperview];
        }
        if (_tancengView) {
            [_tancengView removeFromSuperview];
        }
    }];
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
//            _popup.top = top;
            _popup.top = 15;
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
            
            if ([RYGUtility validateUserLogin]){
                RYGUserCenterViewController *userCenterVC = [[RYGUserCenterViewController alloc]init];
                NSString *name = [link substringWithRange:NSMakeRange(1, link.length-1)];
                userCenterVC.user_name = name;
                [[RYGUtility getCurrentVC] pushViewController:userCenterVC animated:YES];
            }

            break;
        }
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}

- (void)shouchang{
    RYGFavoriteParam *param = [RYGFavoriteParam param];
    param.id = _dynamicFrame.dynamicModel.id;
    param.op = _dynamicFrame.dynamicModel.is_favorite;
    [RYGHttpRequest getWithURL:Feed_add_favorite params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"收藏成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"收藏失败"];
        
    }];
    [self cancelAction];
}


- (void)lahei{
    RYGAttentionParam *attentionParam = [RYGAttentionParam param];
    attentionParam.userid = _dynamicFrame.dynamicModel.publish_user.userid;
    attentionParam.op = @"0";
    [RYGHttpRequest postWithURL:User_AddBlack params:attentionParam.keyValues success:^(id json) {
        NSNumber *code = [json valueForKey:@"code"];
        if (code && code.integerValue == 0) {
            [MBProgressHUD showSuccess:@"添加黑名单成功"];
        }
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}
- (void)report{
    
    RYGReportViewController *reportVC = [[RYGReportViewController alloc]init];
    RYGNavigationController *nav = [[RYGNavigationController alloc]initWithRootViewController:reportVC];
    reportVC.feed_id = _dynamicFrame.dynamicModel.id;
    reportVC.user_id = _dynamicFrame.dynamicModel.publish_user.userid;
    [[RYGUtility getCurrentVC] presentViewController:nav animated:YES completion:^{
        
    }];
    [self cancelAction];
}

- (void)lockAction{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    [RYGHttpRequest getWithURL:Feed_lock params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"锁定成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}
- (void)hideAction{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    param.op = [self.dynamicFrame.dynamicModel.is_hide boolValue]?@"1":@"0";
    [RYGHttpRequest getWithURL:Feed_hide params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"隐藏成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}

- (void)closureAction{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    param.op = [self.dynamicFrame.dynamicModel.is_closure boolValue]?@"1":@"0";
    [RYGHttpRequest getWithURL:Feed_closure params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"禁言成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}

-(void)del{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    [RYGHttpRequest getWithURL:Feed_delelte params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"删除成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}
- (void)userCenterAction{
    if ([RYGUtility validateUserLogin]){
        RYGUserCenterViewController *userCenterVC = [[RYGUserCenterViewController alloc]init];
        userCenterVC.userId = _dynamicFrame.dynamicModel.publish_user.userid;
        [[RYGUtility getCurrentVC] pushViewController:userCenterVC animated:YES];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
