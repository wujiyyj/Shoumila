//
//  RYGForgetPasswordViewController.m
//  shoumila
//
//  Created by yinyujie on 15/8/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGForgetPasswordViewController.h"
#import "RYGLoginViewController.h"
#import "StringHelper.h"
#import "StringValidate.h"
#import "RSA.h"
#import "RYGHttpRequest.h"
#import "RYGUserGetKeyModel.h"
#import "RYGUserInfoModel.h"
#import "RYGUserGetPasswdParam.h"
#import "RYGSmsSendParam.h"
#import "RYGSingleton.h"
#import "MBProgressHUD+MJ.h"

@interface RYGForgetPasswordViewController ()
{
    UITextField* teleTextField;
    UITextField* codeTextField;
    UIButton* getCodeBtn;
    
    UITextField* setPasswordTextField;
    UITextField* makeSurePasswordTextField;
    
    UIScrollView* mainScrollView;
    
    UILabel* teleLabel;
    
    NSString* rKey;
    NSString* e;
    NSString* n;
}

@property(nonatomic,strong) RYGUserGetKeyModel *getKeyModel;
@property(nonatomic,strong) RYGUserInfoModel *userInfoModel;

@end

@implementation RYGForgetPasswordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"忘记密码"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"忘记密码"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"忘记密码";
    
    [self loadPublicKey];
    [self createMainView];
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
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    mainScrollView.backgroundColor = [UIColor redColor];
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    UIControl* backControl = [[UIControl alloc]init];
    backControl.frame = self.view.frame;
    [backControl addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:backControl];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 15)];
    titleLabel.text = @"请输入您注册过或绑定过的手机号,收取验证码";
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    titleLabel.textColor = ColorSecondTitle;
    [backControl addSubview:titleLabel];
    
    teleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 45, SCREEN_WIDTH-30, 40)];
    teleTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    teleTextField.font=[UIFont systemFontOfSize:14];
    teleTextField.placeholder=@"请输入已注册过的手机号";
    teleTextField.delegate=self;
    teleTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    teleTextField.keyboardType = UIKeyboardTypeNumberPad;
    teleTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:teleTextField];
    
    teleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 85, SCREEN_WIDTH-30, 15)];
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
    [getCodeBtn setBackgroundColor:ColorRankMenuBackground];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getCodeBtn.layer.cornerRadius = 6;
    [getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:getCodeBtn];
    
    UILabel* title2Label = [[UILabel alloc]initWithFrame:CGRectMake(15, 170, 100, 15)];
    title2Label.text = @"设置新密码";
    title2Label.font = [UIFont boldSystemFontOfSize:13];
    title2Label.textColor = ColorSecondTitle;
    [backControl addSubview:title2Label];
    
    setPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 190, SCREEN_WIDTH-30, 40)];
    setPasswordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    setPasswordTextField.font=[UIFont systemFontOfSize:14];
    setPasswordTextField.placeholder=@"请输入新密码";
    setPasswordTextField.delegate=self;
    setPasswordTextField.secureTextEntry = YES;
    setPasswordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    setPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:setPasswordTextField];
    
    makeSurePasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 250, SCREEN_WIDTH-30, 40)];
    makeSurePasswordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    makeSurePasswordTextField.font=[UIFont systemFontOfSize:14];
    makeSurePasswordTextField.placeholder=@"请再次输入新密码";
    makeSurePasswordTextField.delegate=self;
    makeSurePasswordTextField.secureTextEntry = YES;
    makeSurePasswordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    makeSurePasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:makeSurePasswordTextField];
    
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 340, 290*SCREEN_SCALE, 40);
    sureBtn.layer.cornerRadius = 5;
    [sureBtn setBackgroundColor:ColorRankMenuBackground];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(goMakeSure) forControlEvents:UIControlEventTouchUpInside];
    [backControl addSubview:sureBtn];
}

-(void)goMakeSure
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
    if (![setPasswordTextField.text isEqualToString:makeSurePasswordTextField.text]) {
        //        NSLog(@"两次输入的密码不一致");
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    if (![StringValidate isEnglishOrNumValue:setPasswordTextField.text]) {
        [MBProgressHUD showError:@"请输入数字或英文"];
        return;
    }
    if (!(setPasswordTextField.text.length>=8 && setPasswordTextField.text.length <=12)) {
        [MBProgressHUD showError:@"请输入8到12位密码"];
        return;
    }
    
    RYGUserGetPasswdParam *getPasswdParam = [RYGUserGetPasswdParam param];
    getPasswdParam.mobile = teleTextField.text;
    NSString *passW = [RSA encryptString:setPasswordTextField.text publicKey:PublicKey];
    getPasswdParam.password = passW;
    getPasswdParam.vercode = codeTextField.text;
    getPasswdParam.rkey = rKey;
    [RYGHttpRequest postWithURL:User_GetPasswd params:getPasswdParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        _userInfoModel = [RYGUserInfoModel objectWithKeyValues:dic];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserInfo];
        
        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
        [NSKeyedArchiver archiveRootObject:_userInfoModel toFile:path];
        
//        [RYGSingleton sharedSingleton].userInfo = _userInfoModel;
        //        [RYGSingleton sharedSingleton].userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfo];
//        NSLog(@"%@",[RYGSingleton sharedSingleton].userInfo);
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            RYGLoginViewController* loginVC = [[RYGLoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
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
    smsSendParam.type = @"2";   //短信用途 1：注册验证  2：取回密码验证 3: 第三方账号绑定
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
        
        //        [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"预约加号"] forState:UIControlStateNormal];
        [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCodeBtn setBackgroundColor:ColorRankMenuBackground];
        
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
        [getCodeBtn setBackgroundColor:ColorLine];
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == makeSurePasswordTextField)
    {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == setPasswordTextField || textField == makeSurePasswordTextField)
    {
        if (SCREEN_HEIGHT <= 568) {
            [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }
    return YES;
}

-(void)backgroundTapped
{
    NSLog(@"dddd");
    [teleTextField resignFirstResponder];
    [codeTextField resignFirstResponder];
    [setPasswordTextField resignFirstResponder];
    [makeSurePasswordTextField resignFirstResponder];
    
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
