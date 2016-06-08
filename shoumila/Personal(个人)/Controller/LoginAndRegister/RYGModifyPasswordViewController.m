//
//  RYGModifyPasswordViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/13.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGModifyPasswordViewController.h"
#import "StringHelper.h"
#import "StringValidate.h"
#import "RYGHttpRequest.h"
#import "RYGUserInfoModel.h"
#import "RYGUserChangePasswdParam.h"
#import "RYGSingleton.h"
#import "RSA.h"
#import "RYGUserGetKeyModel.h"
#import "MBProgressHUD+MJ.h"

@interface RYGModifyPasswordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UITextField* oldPasswordTextField;;
    
    UITextField* setNewPasswordTextField;
    UITextField* makeSureNewPasswordTextField;
    
    UIScrollView* mainScrollView;
    
    NSString* rKey;
    NSString* e;
    NSString* n;
}
@property(nonatomic,strong) RYGUserGetKeyModel *getKeyModel;

@end

@implementation RYGModifyPasswordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self removeSystemTabBarItem];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"修改密码";
    
    [self loadPublicKey];
    [self createMainView];
}

-(void)createMainView
{
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainScrollView.backgroundColor = ColorRankMyRankBackground;
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    UIControl* backControl = [[UIControl alloc]init];
    backControl.frame = self.view.frame;
    [backControl addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:backControl];
    
    
    oldPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH-30, 40)];
    oldPasswordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    oldPasswordTextField.font=[UIFont systemFontOfSize:14];
    oldPasswordTextField.placeholder=@"请输入当前登录密码";
    oldPasswordTextField.delegate=self;
    oldPasswordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    oldPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    oldPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:oldPasswordTextField];
    
    UILabel* title2Label = [[UILabel alloc]initWithFrame:CGRectMake(15, 95, 100, 15)];
    title2Label.text = @"设置新密码";
    title2Label.font = [UIFont boldSystemFontOfSize:13];
    title2Label.textColor = ColorSecondTitle;
    [backControl addSubview:title2Label];
    
    setNewPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 115, SCREEN_WIDTH-30, 40)];
    setNewPasswordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    setNewPasswordTextField.font=[UIFont systemFontOfSize:14];
    setNewPasswordTextField.placeholder=@"请输入新密码";
    setNewPasswordTextField.delegate=self;
    setNewPasswordTextField.secureTextEntry = YES;
    setNewPasswordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    setNewPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    setNewPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:setNewPasswordTextField];
    
    makeSureNewPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 175, SCREEN_WIDTH-30, 40)];
    makeSureNewPasswordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    makeSureNewPasswordTextField.font=[UIFont systemFontOfSize:14];
    makeSureNewPasswordTextField.placeholder=@"请再次输入新密码";
    makeSureNewPasswordTextField.delegate=self;
    makeSureNewPasswordTextField.secureTextEntry = YES;
    makeSureNewPasswordTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    makeSureNewPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    makeSureNewPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backControl addSubview:makeSureNewPasswordTextField];
    
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 265, 290*SCREEN_SCALE, 40);
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
    if (![setNewPasswordTextField.text isEqualToString:makeSureNewPasswordTextField.text]) {
        //        NSLog(@"两次输入的密码不一致");
            [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    if (![StringValidate isEnglishOrNumValue:setNewPasswordTextField.text]) {
            [MBProgressHUD showError:@"请输入数字或英文"];
        return;
    }
    if (!(setNewPasswordTextField.text.length>=6 && setNewPasswordTextField.text.length <=12)) {
            [MBProgressHUD showError:@"请输入6到12位密码"];
        return;
    }
    
    RYGUserChangePasswdParam *changePasswdParam = [RYGUserChangePasswdParam param];
    NSString *oldpassW = [RSA encryptString:oldPasswordTextField.text publicKey:PublicKey];
    NSString *newpassW = [RSA encryptString:setNewPasswordTextField.text publicKey:PublicKey];
    changePasswdParam.pwd_old = oldpassW;
    changePasswdParam.pwd_new = newpassW;
    changePasswdParam.rkey = rKey;
    [RYGHttpRequest postWithURL:User_ChangePasswd params:changePasswdParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
//        _userInfoModel = [RYGUserInfoModel objectWithKeyValues:dic];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserInfo];
        
//        [RYGSingleton sharedSingleton].userInfo = _userInfoModel;
        //        [RYGSingleton sharedSingleton].userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfo];
//        NSLog(@"%@",[RYGSingleton sharedSingleton].userInfo);
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Textfield Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == makeSureNewPasswordTextField)
    {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == setNewPasswordTextField || textField == makeSureNewPasswordTextField)
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
    [oldPasswordTextField resignFirstResponder];
    [setNewPasswordTextField resignFirstResponder];
    [makeSureNewPasswordTextField resignFirstResponder];
    
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
