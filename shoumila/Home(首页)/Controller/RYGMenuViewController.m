//
//  MJMenuViewController.m
//  侧滑菜单
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "RYGMenuViewController.h"
#import "MBProgressHUD+MJ.h"
#import "RYGGrandeMarkView.h"
#import "RYGUserCenterViewController.h"
#import "RYGPersonalUserModel.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGAddTargetViewController.h"
#import "RYGSettingViewController.h"
#import "RYGUserDetailParam.h"
#import "RYGHttpRequest.h"
#import "RYGPersonalCenterModel.h"

@interface RYGMenuViewController ()
@property(nonatomic,strong) NSMutableArray  *data;
@property(nonatomic,strong) NSString        *plistPath;
@property(nonatomic,strong) RYGPersonalUserModel *user;
@property(nonatomic) UITableView *menuTableView;
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *level;
//@property(nonatomic,strong) RYGGrandeMarkView *grandMarkView;
@end

@implementation RYGMenuViewController{
    UIButton *selectBtn;
}
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(45*SCREEN_SCALE, 64*SCREEN_SCALE, 70*SCREEN_SCALE, 70*SCREEN_SCALE)];
        _icon.layer.cornerRadius = _icon.width/2;
        _icon.layer.borderWidth = 3;
        _icon.layer.masksToBounds = YES;
        _icon.userInteractionEnabled = YES;
        _icon.layer.borderColor = ColorGreen.CGColor;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userCenterAction)];
        [self.icon addGestureRecognizer:recognizer];
        [self.view addSubview:self.icon];
    }
    return _icon;
}
-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.icon.frame)+10, RYGMenuWidth/2, 14)];
        _name.textAlignment = NSTextAlignmentRight;
        _name.textColor = [UIColor whiteColor];
        _name.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_name];
    }
    return _name;
}

- (UILabel *)level{
    if (!_level) {
        self.level = [UILabel new];
        self.level.frame = CGRectMake(CGRectGetMaxX(self.name.frame)+5, self.name.top, 33*SCREEN_SCALE, 11*SCREEN_SCALE);
        self.level.textColor = ColorYeallow;
        self.level.font = [UIFont systemFontOfSize:12];
//        NSString *grade = _user.grade?:@"0";
//        NSString *score = [NSString stringWithFormat:@"Lv%@",grade];
//        [_level setTitle:score forState:UIControlStateNormal];
        [self.view addSubview:_level];
    }
    return _level;
}

//- (RYGGrandeMarkView *)grandMarkView{
//    if (!_grandMarkView) {
//        _grandMarkView = [[RYGGrandeMarkView alloc]initWithFrame:CGRectMake(0, 0, RYGMenuWidth, 40)];
//        [self.view addSubview:_grandMarkView];
//    }
//    return _grandMarkView;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    backgroundView.frame = CGRectMake(0, 0, RYGMenuWidth, SCREEN_HEIGHT);
    [self.view addSubview:backgroundView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setUp) name:MENU_ITEMS object:nil];
}

- (void)loadUser{
    RYGUserDetailParam *userDetailParam = [RYGUserDetailParam param];
    userDetailParam.userid = [RYGUtility getUserInfo].userid;
    [RYGHttpRequest postWithURL:User_Personal_center params:userDetailParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        RYGPersonalCenterModel *personalCenterModel = [RYGPersonalCenterModel objectWithKeyValues:dic];
        _user = personalCenterModel.user;
        [self.icon setImageURLStr:_user.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
        self.name.text = _user.user_name;
        NSString *grade = _user.grade?:@"0";
        NSString *score = [NSString stringWithFormat:@"Lv%@",grade];
        self.level.text = score;
//        self.grandMarkView.integralRank = _user.grade;
//        _grandMarkView.center = CGPointMake(RYGMenuWidth/2, CGRectGetMaxY(self.level.frame)+15);
    } failure:^(NSError *error) {
        
    }];
}

- (void)setUp{
    [self loadUser];
    _plistPath = [[NSBundle mainBundle] pathForResource:@"MenuItem" ofType:@"plist"];
    _data = [[NSMutableArray alloc] initWithContentsOfFile:_plistPath];

    [self.icon setImageURLStr:self.user.user_logo placeholder:[UIImage imageNamed:@"user_head"]];
    self.name.text = self.user.user_name;
    
    NSString *grade = self.user.grade?:@"0";
    NSString *score = [NSString stringWithFormat:@"Lv.%@",grade];
    self.level.text = score;

//    self.grandMarkView.integralRank = grade;
//    _grandMarkView.center = CGPointMake(RYGMenuWidth/2, CGRectGetMaxY(self.level.frame)+15);
    for (int i = 1; i<=4; i++) {
        UIView *lastBtn = [self.view viewWithTag:i];
        if (lastBtn) {
            [lastBtn removeFromSuperview];
        }

    }
    [_data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(14*SCREEN_SCALE, CGRectGetMaxY(self.level.frame)+40*idx+20*SCREEN_SCALE, 130*SCREEN_SCALE, 40)];
        NSDictionary *dic = obj;
        [menuBtn setTitle:[dic valueForKey:@"name"] forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [menuBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [menuBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateHighlighted];
        menuBtn.tag = idx+1;
        [menuBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:menuBtn];
    }];
    
    UIButton *plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(60*SCREEN_SCALE, SCREEN_HEIGHT-180*SCREEN_SCALE, 40*SCREEN_SCALE, 40*SCREEN_SCALE)];
    [plusBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(addTarget) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:plusBtn];
    
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(RYGMenuWidth/2 - 25*SCREEN_SCALE, SCREEN_HEIGHT-39, 50*SCREEN_SCALE, 19)];
    [settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [settingBtn addTarget:self action:@selector(settingActin) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.titleLabel.tintColor = ColorAttionunCanBackground;
    [self.view addSubview:settingBtn];
    
    UIButton *nightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(settingBtn.frame)+30*SCREEN_SCALE, SCREEN_HEIGHT-39, settingBtn.width, settingBtn.height)];
    [nightBtn setImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
    [nightBtn setTitle:@"夜间" forState:UIControlStateNormal];
    nightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    nightBtn.titleLabel.tintColor = ColorAttionunCanBackground;
}

-(void)addItem:(NSString *)itemName atIndex:(NSInteger)index{
    [self reloadInputViews];
}

- (void)btnAction:(UIButton *)btn{
    selectBtn.selected = NO;
    selectBtn = btn;
    btn.selected = YES;
    NSDictionary *dic = _data[btn.tag-1];
    NSString *str = [dic valueForKey:@"class"];
     id class =  [[NSClassFromString(str) alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:MENU_NOTIFICATION object:class];
    NSLog(@"%@",[dic valueForKey:@"class"]);
}

- (void)addTarget{
    RYGAddTargetViewController *addTargetVC = [[RYGAddTargetViewController alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:MENU_NOTIFICATION object:addTargetVC];
}
- (void)userCenterAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:USERCENTER_NOTIFICATION object:nil];
}
- (void)settingActin{
    RYGSettingViewController *settingVC = [[RYGSettingViewController alloc]init];
    settingVC.user_logo = _user.user_logo;
    settingVC.userId = [RYGUtility getUserInfo].userid;
    settingVC.user_name = _user.user_name;
    [[NSNotificationCenter defaultCenter]postNotificationName:MENU_NOTIFICATION object:settingVC];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
