//
//  RYGBindTeleViewController.m
//  shoumila
//
//  Created by yinyujie on 15/8/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBindTeleViewController.h"
#import "RYGUserCenterViewController.h"
#import "StringHelper.h"
#import "StringValidate.h"
#import "RYGSmsSendParam.h"
#import "RYGSingleton.h"
#import "RYGUserThirdRegParam.h"
#import "RYGSmsSendParam.h"
#import "RYGHttpRequest.h"
#import "APService.h"

@interface RYGBindTeleViewController ()
{
    UITextField* teleTextField;
    UITextField* codeTextField;
    UIButton* getCodeBtn;
    
    UILabel* teleLabel;
    UIViewController *parentViewController;
}

@property(nonatomic,strong) RYGUserInfoModel *userInfoModel;

@end

@implementation RYGBindTeleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self removeSystemTabBarItem];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createMainView];
}

- (void)removeSystemTabBarItem
{
    for (UIView *subView in self.tabBarController.tabBar.subviews) {
        if ([subView isKindOfClass:[UIControl class]]) {
            subView.hidden = YES;
            [subView removeFromSuperview];
        }
    }
}

-(void)createMainView
{
    UIControl* backControl = [[UIControl alloc]init];
    backControl.frame = self.view.frame;
    [backControl addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backControl];
    
    teleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH-30, 40)];
    teleTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    teleTextField.font=[UIFont systemFontOfSize:14];
    teleTextField.placeholder=@"请输入注册手机号";
    teleTextField.delegate=self;
    teleTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    teleTextField.keyboardType = UIKeyboardTypeDefault;
    teleTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:teleTextField];
    
    teleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, SCREEN_WIDTH-30, 15)];
    teleLabel.textColor = [UIColor colorWithHexadecimal:@"#e22618"];
    teleLabel.font = [UIFont systemFontOfSize:11];
    //    teleLabel.text = @"您填写的手机号码不正确/请填写您的手机号码";
    teleLabel.hidden = YES;
    [backControl addSubview:teleLabel];
    
    codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 105, SCREEN_WIDTH-130, 40)];
    codeTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    codeTextField.font=[UIFont systemFontOfSize:14];
    codeTextField.placeholder=@"请输入验证码";
    codeTextField.delegate=self;
    codeTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    codeTextField.keyboardType = UIKeyboardTypeDefault;
    codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:codeTextField];
    
    getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBtn.frame = CGRectMake(SCREEN_WIDTH-110, 110, 95, 30);
    //    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"预约加号"] forState:UIControlStateNormal];
    [getCodeBtn setBackgroundColor:ColorTabBarButtonTitleSelected];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getCodeBtn.layer.cornerRadius = 6;
    [getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:getCodeBtn];
    
    UIButton* bindBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bindBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 215, 290*SCREEN_SCALE, 40);
    bindBtn.layer.cornerRadius = 5;
    [bindBtn setBackgroundColor:ColorTabBarButtonTitleSelected];
    [bindBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    bindBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bindBtn addTarget:self action:@selector(goBind) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:bindBtn];
}

-(void)goBind
{
    NSLog(@"goBind  立即体验");
    
    
    RYGUserThirdRegParam *thirdRegParam = [RYGUserThirdRegParam param];
    thirdRegParam.type = _third_type;
    thirdRegParam.mobile = teleTextField.text;
    thirdRegParam.vercode = codeTextField.text;
    thirdRegParam.user_name = _third_Name;
    thirdRegParam.third_uid = _third_Uid;
    thirdRegParam.third_token = _third_Token;
    thirdRegParam.nickname = _third_Name;
    thirdRegParam.figureurl = _third_profileImage;
    thirdRegParam.device = @"ios";
//    thirdRegParam.client_id = [APService registrationID];
    [RYGHttpRequest postWithURL:User_ThirdReg params:thirdRegParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        
        _userInfoModel = [RYGUserInfoModel objectWithKeyValues:dic];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserInfo];
        
        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
        [NSKeyedArchiver archiveRootObject:_userInfoModel toFile:path];
        
//        [RYGSingleton sharedSingleton].userInfo = _userInfoModel;
        //        [RYGSingleton sharedSingleton].userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfo];
//        NSLog(@"%@",[RYGSingleton sharedSingleton].userInfo);
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getCode
{
    if (stringIsEmpty(teleTextField.text)) {
        
        teleLabel.text = @"请填写您的手机号码";
        teleLabel.hidden = NO;
        
        return;
    }
    if (![StringValidate isMobileNum:teleTextField.text]) {
        
        teleLabel.text = @"您填写的手机号码不正确";
        teleLabel.hidden = NO;
        
        return;
    }
    
    RYGSmsSendParam *smsSendParam = [RYGSmsSendParam param];
    smsSendParam.mobile = teleTextField.text;
    smsSendParam.type = @"3";   //短信用途 1：注册验证  2：取回密码验证 3: 第三方账号绑定
    [RYGHttpRequest postWithURL:Sms_Send params:smsSendParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        
        NSLog(@"%@",dic);
        NSNumber *code = [json valueForKey:@"code"];
        if ([code intValue]==0) {
            thread = nil;
            thread = [[NSThread alloc] initWithTarget:self selector:@selector(CountButton) object:nil];
            [thread start];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    teleLabel.hidden = YES;
    
    
}

-(void)CountButton
{
    counttime = 0;
    [getCodeBtn setEnabled:NO];
    while (counttime>=0 && counttime<=59)
    {
        [self performSelectorOnMainThread:@selector(resetButton:) withObject:[NSString stringWithFormat:@"%d",counttime] waitUntilDone:YES];
        [NSThread sleepForTimeInterval:1];
        counttime++;
    }
    if (counttime>=60 || counttime<0)
    {
        [getCodeBtn setEnabled:YES];
        
        [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCodeBtn setBackgroundColor:ColorTabBarButtonTitleSelected];
        
        //        [self performSelectorOnMainThread:@selector(resetButton:) withObject:[NSString stringWithFormat:@"%d",0] waitUntilDone:YES];
        return;
    }
}

-(void)resetButton:(NSString *)time
{
    int counttime1 = [time intValue];
    NSLog(@"counttime1 = %d",counttime1);
    if (counttime1>=0 && counttime1<=59)
    {
        //        [getCodeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [getCodeBtn setTitle:[NSString stringWithFormat:@"等待%ds",60-counttime1] forState:UIControlStateDisabled];
        //        getCodeBtn set
        [getCodeBtn setBackgroundColor:[UIColor colorWithHexadecimal:@"#cccccc"]];
    }
    else
    {
        NSLog(@"fff");
    }
    
}

#pragma mark - Textfield Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)backgroundTapped
{
    NSLog(@"dddd");
    [teleTextField resignFirstResponder];
    [codeTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
