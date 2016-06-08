//
//  RYGRegisterViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/29.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRegisterViewController.h"
#import "RYGLoginViewController.h"
#import "RYGQuickLoginViewController.h"
#import "StringHelper.h"
#import "StringValidate.h"
#import "RSA.h"
#import "RYGHttpRequest.h"
#import "RYGUserGetKeyModel.h"
#import "RYGUserInfoModel.h"
#import "RYGUserLoginParam.h"
#import "RYGUserRegisterParam.h"
#import "RYGSmsSendParam.h"
#import "RYGSingleton.h"
#import "RYGPersonInfoViewController.h"
#import "RYGBindTeleViewController.h"
#import "MBProgressHUD+MJ.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "APService.h"

#import "WXApi.h"
#import "WXApiObject.h"

@interface RYGRegisterViewController ()
{
    UITextField* teleTextField;
    UITextField* setPasswordTextField;
    UITextField* codeTextField;
    UIButton* getCodeBtn;
    
    UILabel* teleLabel;
    UILabel* codeLabel;
    
    NSString* rKey;
    NSString* e;
    NSString* n;
}

@property(nonatomic,strong) RYGUserGetKeyModel *getKeyModel;
@property(nonatomic,strong) RYGUserInfoModel *userInfoModel;

@end

@implementation RYGRegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self removeSystemTabBarItem];
    [MobClick beginLogPageView:@"注册"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"注册";
    
    [self loadPublicKey];
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

//获取publickey
-(void)loadPublicKey
{
    [RYGHttpRequest postWithURL:User_Get_EncryptionKey params:nil success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        _getKeyModel = [RYGUserGetKeyModel objectWithKeyValues:dic];
        
        e = _getKeyModel.e;
        rKey = _getKeyModel.rkey;
        n = _getKeyModel.n;
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)createMainView
{
    UIControl* backControl = [[UIControl alloc]init];
    backControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [backControl addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backControl];
    
    teleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH-30, 40)];
    teleTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    teleTextField.font=[UIFont systemFontOfSize:14];
    teleTextField.placeholder=@"请输入注册手机号";
    teleTextField.delegate=self;
    teleTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    teleTextField.keyboardType = UIKeyboardTypeNumberPad;
    teleTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:teleTextField];
    
    teleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, SCREEN_WIDTH-30, 15)];
    teleLabel.textColor = [UIColor colorWithHexadecimal:@"#e22618"];
    teleLabel.font = [UIFont systemFontOfSize:11];
    //    teleLabel.text = @"您填写的手机号码不正确/请填写您的手机号码";
    teleLabel.hidden = YES;
    [backControl addSubview:teleLabel];
    
    codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 90, SCREEN_WIDTH-130, 40)];
    codeTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    codeTextField.font=[UIFont systemFontOfSize:14];
    codeTextField.placeholder=@"请输入验证码";
    codeTextField.delegate=self;
    codeTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    codeTextField.keyboardType = UIKeyboardTypeDefault;
    codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:codeTextField];
    
    getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBtn.frame = CGRectMake(SCREEN_WIDTH-110, 95, 95, 30);
    //    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"预约加号"] forState:UIControlStateNormal];
    [getCodeBtn setBackgroundColor:ColorTabBarButtonTitleSelected];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getCodeBtn.layer.cornerRadius = 6;
    [getCodeBtn addTarget:setPasswordTextField action:@selector(getCodes) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:getCodeBtn];
    
    codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 130, SCREEN_WIDTH-30, 15)];
    codeLabel.textColor = [UIColor colorWithHexadecimal:@"#e22618"];
    codeLabel.font = [UIFont systemFontOfSize:11];
    //    codeLabel.text = @"验证码错误/验证码已失效,请重新获取";
    codeLabel.hidden = YES;
    [backControl addSubview:codeLabel];
    
    setPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 150, SCREEN_WIDTH-30, 40)];
    setPasswordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    setPasswordTextField.font=[UIFont systemFontOfSize:14];
    setPasswordTextField.placeholder=@"设置密码";
    setPasswordTextField.delegate=self;
    setPasswordTextField.secureTextEntry = YES;
    setPasswordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    setPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:setPasswordTextField];
    
    
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 206, 290*SCREEN_SCALE, 40);
    registerBtn.layer.cornerRadius = 5;
    [registerBtn setBackgroundColor:ColorTabBarButtonTitleSelected];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:registerBtn];
    
    UIButton* gotoLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    gotoLoginBtn.frame = CGRectMake(SCREEN_WIDTH-100, 256, 80, 20);
    [gotoLoginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [gotoLoginBtn setTitleColor:ColorTabBarButtonTitleSelected forState:UIControlStateNormal];
    gotoLoginBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [gotoLoginBtn addTarget:self action:@selector(gotoLoginView) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:gotoLoginBtn];
        
    UIImageView* leftLine = [[UIImageView alloc]init];
    leftLine.frame = CGRectMake(20, backControl.frame.size.height-130, SCREEN_WIDTH/2-55, 0.5);
    leftLine.backgroundColor = ColorLine;
    [backControl addSubview:leftLine];
    
    UIImageView* rightLine = [[UIImageView alloc]init];
    rightLine.frame = CGRectMake(SCREEN_WIDTH/2+35, backControl.frame.size.height-130, SCREEN_WIDTH/2-55, 0.5);
    rightLine.backgroundColor = ColorLine;
    [backControl addSubview:rightLine];
    
    UILabel* loginLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, backControl.frame.size.height-140, 60, 20)];
    loginLabel.text = @"快速登录";
    loginLabel.font = [UIFont systemFontOfSize:15];
    loginLabel.textColor = ColorRankMedal;
    [backControl addSubview:loginLabel];
    
    UIButton* weiXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiXinBtn.frame = CGRectMake(35, backControl.frame.size.height-100, 50, 50);
    [weiXinBtn setBackgroundImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
    [weiXinBtn setBackgroundImage:[UIImage imageNamed:@"login_weixin_Click"] forState:UIControlStateHighlighted];
    [weiXinBtn addTarget:self action:@selector(ClickWeiXinBtn) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:weiXinBtn];
    
    UILabel* weiXinLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, backControl.frame.size.height-40, 60, 20)];
    weiXinLabel.text = @"微信";
    weiXinLabel.textColor = ColorRankMedal;
    weiXinLabel.font = [UIFont systemFontOfSize:14];
    weiXinLabel.textAlignment = NSTextAlignmentCenter;
    [backControl addSubview:weiXinLabel];
    
    UIButton* weiBoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiBoBtn.frame = CGRectMake(SCREEN_WIDTH/2-25, backControl.frame.size.height-100, 50, 50);
    [weiBoBtn setBackgroundImage:[UIImage imageNamed:@"login_weibo"] forState:UIControlStateNormal];
    [weiBoBtn setBackgroundImage:[UIImage imageNamed:@"login_weibo_Click"] forState:UIControlStateHighlighted];
    [weiBoBtn addTarget:self action:@selector(ClickWeiBoBtn) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:weiBoBtn];
    
    UILabel* weiBoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, backControl.frame.size.height-40, 60, 20)];
    weiBoLabel.text = @"新浪微博";
    weiBoLabel.textColor = ColorRankMedal;
    weiBoLabel.font = [UIFont systemFontOfSize:14];
    weiBoLabel.textAlignment = NSTextAlignmentCenter;
    [backControl addSubview:weiBoLabel];
    
    UIButton* qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = CGRectMake(SCREEN_WIDTH-85, backControl.frame.size.height-100, 50, 50);
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"login_qq_Click"] forState:UIControlStateHighlighted];
    [qqBtn addTarget:self action:@selector(ClickqqBtn) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:qqBtn];
    
    UILabel* qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, backControl.frame.size.height-40, 60, 20)];
    qqLabel.text = @"QQ";
    qqLabel.textColor = ColorRankMedal;
    qqLabel.font = [UIFont systemFontOfSize:14];
    qqLabel.textAlignment = NSTextAlignmentCenter;
    [backControl addSubview:qqLabel];
    
    if (![WXApi isWXAppInstalled]) {
        weiXinBtn.hidden = YES;
        weiXinLabel.hidden = YES;
        weiBoBtn.centerX = SCREEN_WIDTH/3;
        weiBoLabel.centerX = SCREEN_WIDTH/3;
        qqBtn.centerX = SCREEN_WIDTH/3*2;
        qqLabel.centerX = SCREEN_WIDTH/3*2;
    }
    else {
        weiXinBtn.hidden = NO;
        weiXinLabel.hidden = NO;
        weiBoBtn.frame = CGRectMake(SCREEN_WIDTH/2-25, backControl.frame.size.height-100, 50, 50);
        weiBoLabel.frame = CGRectMake(SCREEN_WIDTH/2-30, backControl.frame.size.height-40, 60, 20);
        
    }
    
}

-(void)gotoLoginView
{
    RYGLoginViewController *loginController = [[RYGLoginViewController alloc]init];
    [self.navigationController pushViewController:loginController animated:YES];
}

-(void)ClickWeiBoBtn
{
    RYGQuickLoginViewController* quickLogin = [[RYGQuickLoginViewController alloc]init];
    [self.navigationController pushViewController:quickLogin animated:YES];
}

-(void)ClickWeiXinBtn
{
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showError:@"未安装微信客户端"];
        return ;
    }
    
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"%d",result);
        if (result) {
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            //            [self reloadStateWithType:ShareTypeSinaWeibo];
            [self NewWeiXinUserInfo];
        }
        else {
            [MBProgressHUD showError:@"认证失败"];
        }
    }];
}

-(void)ClickqqBtn
{
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"%d",result);
        if (result) {
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            //            [self reloadStateWithType:ShareTypeSinaWeibo];
            [self NewQQUserInfo];
        }
        else {
            [MBProgressHUD showError:@"认证失败"];
        }
    }];
}

-(void)NewWeiXinUserInfo{
    
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeWeixiSession];
    
    RYGUserLoginParam *loginParam = [RYGUserLoginParam param];
    loginParam.type = @"1";
    loginParam.third_uid = [credential uid];
    loginParam.third_token = [credential token];
    loginParam.device = @"ios";
//    loginParam.client_id = [APService registrationID];
    [RYGHttpRequest postWithURL:User_Login params:loginParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        
        if ([[json valueForKey:@"code"] intValue] == 211) {
            RYGBindTeleViewController* bindTeleController = [[RYGBindTeleViewController alloc]init];
            bindTeleController.third_type = @"1";
            bindTeleController.third_Uid = loginParam.third_uid;
            bindTeleController.third_Token = loginParam.third_token;
            [self.navigationController pushViewController:bindTeleController animated:YES];
            return;
        }
        
        _userInfoModel = [RYGUserInfoModel objectWithKeyValues:dic];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserInfo];
        
        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
        [NSKeyedArchiver archiveRootObject:_userInfoModel toFile:path];
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [MobClick profileSignInWithPUID:_userInfoModel.userid provider:@"WX"];
        }
        
//        [RYGSingleton sharedSingleton].userInfo = _userInfoModel;
        
    } failure:^(NSError *error) {
        if ([[error valueForKey:@"code"] intValue] == 211) {
            RYGBindTeleViewController* bindTeleController = [[RYGBindTeleViewController alloc]init];
            bindTeleController.third_type = @"1";
            bindTeleController.third_Uid = loginParam.third_uid;
            bindTeleController.third_Token = loginParam.third_token;
            [self.navigationController pushViewController:bindTeleController animated:YES];
            return;
        }
    }];
}

-(void)NewQQUserInfo{
    
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeQQ];
    id<ISSPlatformUser> credent = [ShareSDK currentAuthUserWithType:ShareTypeQQSpace];
    
    RYGUserLoginParam *loginParam = [RYGUserLoginParam param];
    loginParam.type = @"3";
    loginParam.third_uid = [credential uid];
    loginParam.third_token = [credential token];
    loginParam.device = @"ios";
//    loginParam.client_id = [APService registrationID];
    [RYGHttpRequest postWithURL:User_Login params:loginParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        
        if ([[json valueForKey:@"code"] intValue] == 211) {
            RYGBindTeleViewController* bindTeleController = [[RYGBindTeleViewController alloc]init];
            bindTeleController.third_Uid = loginParam.third_uid;
            bindTeleController.third_Token = loginParam.third_token;
            bindTeleController.third_type = @"3";
            bindTeleController.third_Name = [credent nickname];
            bindTeleController.third_profileImage = [credent profileImage];
            
            [self.navigationController pushViewController:bindTeleController animated:YES];
            return;
        }
        
        _userInfoModel = [RYGUserInfoModel objectWithKeyValues:dic];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserInfo];
        
        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
        [NSKeyedArchiver archiveRootObject:_userInfoModel toFile:path];
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [MobClick profileSignInWithPUID:_userInfoModel.userid provider:@"QQ"];
        }
        
//        [RYGSingleton sharedSingleton].userInfo = _userInfoModel;
        
    } failure:^(NSError *error) {
        if ([[error valueForKey:@"code"] intValue] == 211) {
            RYGBindTeleViewController* bindTeleController = [[RYGBindTeleViewController alloc]init];
            bindTeleController.third_Uid = loginParam.third_uid;
            bindTeleController.third_Token = loginParam.third_token;
            bindTeleController.third_type = @"3";
            bindTeleController.third_Name = [credent nickname];
            bindTeleController.third_profileImage = [credent profileImage];
            [self.navigationController pushViewController:bindTeleController animated:YES];
            return;
        }
    }];
}

-(void)goRegister
{
    if (stringIsEmpty(teleTextField.text)) {
        NSLog(@"手机号不能为空");
        
        teleLabel.text = @"请填写您的手机号码";
        teleLabel.hidden = NO;
        
        return;
    }
    if (![StringValidate isMobileNum:teleTextField.text]) {
        NSLog(@"请输入正确的手机号");
        
        teleLabel.text = @"您填写的手机号码不正确";
        teleLabel.hidden = NO;
        
        return;
    }
    if (![StringValidate isEnglishOrNumValue:setPasswordTextField.text]) {
        [MBProgressHUD showError:@"请输入数字或英文"];
        return;
    }
    if (!(setPasswordTextField.text.length>=6 && setPasswordTextField.text.length <=12)) {
        [MBProgressHUD showError:@"请输入6到12位密码"];
        return;
    }
    
    teleLabel.hidden = YES;
    
    
    RYGUserRegisterParam *registerParam = [RYGUserRegisterParam param];
    registerParam.mobile = teleTextField.text;
    NSString *passW = [RSA encryptString:setPasswordTextField.text publicKey:PublicKey];
    registerParam.password = passW;
    registerParam.vercode = codeTextField.text;
    registerParam.device = @"ios";
//    registerParam.client_id = [APService registrationID];
    registerParam.rkey = rKey;
    [RYGHttpRequest postWithURL:User_Register params:registerParam.keyValues success:^(id json) {
        
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
            
            [MobClick profileSignInWithPUID:_userInfoModel.userid];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)getCodes
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
    smsSendParam.type = @"1";   //短信用途 1：注册验证  2：取回密码验证 3: 第三方账号绑定
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
        
        return;
    }
}

-(void)resetButton:(NSString *)time
{
    int counttime1 = [time intValue];
    NSLog(@"counttime1 = %d",counttime1);
    if (counttime1>=0 && counttime1<=59)
    {
        //        [getCodeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [getCodeBtn setTitle:[NSString stringWithFormat:@"等待%ds",60-counttime1] forState:UIControlStateDisabled];
        //        getCodeBtn set
        [getCodeBtn setBackgroundColor:ColorLine];
        
    }
    else
    {
        
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
    [teleTextField resignFirstResponder];
    [setPasswordTextField resignFirstResponder];
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
