//
//  RYGLoginViewController.m
//  shoumila
//
//  Created by yinyujie on 15/7/29.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGLoginViewController.h"
#import "RYGRegisterViewController.h"
#import "RYGQuickLoginViewController.h"
#import "RYGForgetPasswordViewController.h"
#import "RYGUserCenterViewController.h"
#import "RYGBindTeleViewController.h"
#import "RYGHttpRequest.h"
#import "RYGUserGetKeyModel.h"
#import "RYGUserInfoModel.h"
#import "RYGUserLoginParam.h"
#import "RSA.h"
#import "StringHelper.h"
#import "StringValidate.h"
#import "RYGSingleton.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "APService.h"

#import "WXApi.h"
#import "WXApiObject.h"

@interface RYGLoginViewController ()
{
    UITextField* teleTextField;
    UITextField* passwordTextField;
    
    NSString* rKey;
    NSString* e;
    NSString* n;
}

@property(nonatomic,strong) RYGUserGetKeyModel *getKeyModel;
@property(nonatomic,strong) RYGUserInfoModel *userInfoModel;

@end

@implementation RYGLoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self removeSystemTabBarItem];
    [MobClick beginLogPageView:@"登录"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"登录";
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pressLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
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

- (void)pressLeftButton
{
    if (_isBackHome == YES) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
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
    
    teleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH-30, 40)];
    teleTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    teleTextField.font=[UIFont systemFontOfSize:14];
    teleTextField.placeholder=@"请输入注册手机号";
    teleTextField.delegate=self;
    teleTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    teleTextField.keyboardType = UIKeyboardTypeNumberPad;
    teleTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:teleTextField];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 105, SCREEN_WIDTH-30, 40)];
    passwordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    passwordTextField.font=[UIFont systemFontOfSize:14];
    passwordTextField.placeholder=@"请输入密码";
    passwordTextField.delegate=self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:passwordTextField];
    
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(20, 160, 60, 20);
    [registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:ColorTabBarButtonTitleSelected forState:UIControlStateNormal];
    registerBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [registerBtn addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:registerBtn];
    
    UIButton* findPasswordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    findPasswordBtn.frame = CGRectMake(SCREEN_WIDTH-100, 160, 70, 20);
    [findPasswordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
    findPasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [findPasswordBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:findPasswordBtn];
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 216, 290*SCREEN_SCALE, 40);
    loginBtn.layer.cornerRadius = 5;
    [loginBtn setBackgroundColor:ColorTabBarButtonTitleSelected];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:loginBtn];
    
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

-(void)goLogin
{
    
    if (stringIsEmpty(teleTextField.text)) {
//        NSLog(@"手机号不能为空");
        [MBProgressHUD showError:@"手机号不能为空"];
        
        return;
    }
    if (![StringValidate isMobileNum:teleTextField.text]) {
//        NSLog(@"请输入正确的手机号");
        [MBProgressHUD showError:@"请输入正确的手机号"];
        
        return;
    }
    if (![StringValidate isEnglishOrNumValue:passwordTextField.text]) {
        [MBProgressHUD showError:@"请输入数字或英文"];
        return;
    }
    if (!(passwordTextField.text.length>=6 && passwordTextField.text.length <=12)) {
        [MBProgressHUD showError:@"请输入6到12位密码"];
        return;
    }
    
    [self sendLoginMessage];
}

-(void)sendLoginMessage
{
    RYGUserLoginParam *loginParam = [RYGUserLoginParam param];
    loginParam.type = @"0";
    loginParam.mobile = teleTextField.text;
    NSString *passW = [RSA encryptString:passwordTextField.text publicKey:PublicKey];
    loginParam.password = passW;
    loginParam.device = @"ios";
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    loginParam.client_id = [APService registrationID];
    loginParam.rkey = rKey;
    [RYGHttpRequest postWithURL:User_Login params:loginParam.keyValues success:^(id json) {
        
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
        NSLog(@"%@",userInfo);
        
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
//    loginParam.code = @"";
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
    
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeQQSpace];
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
            bindTeleController.third_Uid = [credential uid];
            bindTeleController.third_Token = [credential token];
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
    RYGRegisterViewController* registerController = [[RYGRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerController animated:YES];
}

-(void)findPassword
{
    RYGForgetPasswordViewController* forgetPassword = [[RYGForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetPassword animated:YES];
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
    [passwordTextField resignFirstResponder];
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
