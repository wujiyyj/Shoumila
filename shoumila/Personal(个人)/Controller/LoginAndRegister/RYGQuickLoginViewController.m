//
//  RYGQuickLoginViewController.m
//  shoumila
//
//  Created by yinyujie on 15/8/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGQuickLoginViewController.h"
#import "RYGBindTeleViewController.h"
#import "RYGUserLoginParam.h"
#import "RYGHttpRequest.h"
#import "RYGUserInfoModel.h"
#import "RYGSingleton.h"
#import <ShareSDK/ShareSDK.h>
//#import "WeiboUser.h"
//#import "WeiboSDK.h"
#import "APService.h"
#import "MBProgressHUD+MJ.h"

@interface RYGQuickLoginViewController ()

@property(nonatomic,strong) RYGUserInfoModel *userInfoModel;

@end

@implementation RYGQuickLoginViewController

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
    
    self.navigationItem.title = @"快速登录";
    self.view.backgroundColor = ColorRankMyRankBackground;
    
    [self performSelectorOnMainThread:@selector(login)withObject:nil waitUntilDone:NO];
    
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

-(void)login
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiBoDidLogin:) name:@"weiBoDidLogin" object:nil];
}

-(void)createMainView
{
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 190)];
    backView.backgroundColor = ColorRankBackground;
    [self.view addSubview:backView];
    
    UIView* top_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    top_lineView.backgroundColor = ColorLine;
    [backView addSubview:top_lineView];
    
    UIView* bottom_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    bottom_lineView.backgroundColor = ColorLine;
    [backView addSubview:bottom_lineView];
    
    UIImageView* picImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, 80, 50, 50)];
    picImage.image = [UIImage imageNamed:@"sdk_weibo_logo"];
    [backView addSubview:picImage];
    
    UILabel* weiBoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 135, 60, 20)];
    weiBoLabel.text = @"新浪微博";
    weiBoLabel.textColor = ColorRankMedal;
    weiBoLabel.font = [UIFont systemFontOfSize:14];
    weiBoLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:weiBoLabel];
    
    UIButton* authorBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    authorBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 220, 290*SCREEN_SCALE, 40);
    authorBtn.layer.cornerRadius = 5;
    [authorBtn setBackgroundColor:ColorTabBarButtonTitleSelected];
    [authorBtn setTitle:@"确认授权" forState:UIControlStateNormal];
    [authorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    authorBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [authorBtn addTarget:self action:@selector(goAuthor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authorBtn];
}

-(void)goAuthor
{
    [self loginWithSinaWeibo];
    
}

#pragma mark -- LoginwithSinaWeibo Methods
-(void)loginWithSinaWeibo
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"%d",result);
        if (result) {
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
//            [self reloadStateWithType:ShareTypeSinaWeibo];
            [self NewSinaWeiboUserInfo];
        }
        else {
            [MBProgressHUD showError:@"认证失败"];
        }
    }];

    
}

-(void)NewSinaWeiboUserInfo{
//    AppDelegate* myDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    [WBHttpRequest requestForUserProfile:myDelegate.wbCurrentUserID withAccessToken:myDelegate.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
//        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
    
    
    RYGUserLoginParam *loginParam = [RYGUserLoginParam param];
    loginParam.type = @"2";
    loginParam.third_uid = [credential uid];
    loginParam.third_token = [credential token];
    loginParam.device = @"ios";
//    loginParam.client_id = [APService registrationID];
    [RYGHttpRequest postWithURL:User_Login params:loginParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        
        if ([[json valueForKey:@"code"] intValue] == 211) {
            RYGBindTeleViewController* bindTeleController = [[RYGBindTeleViewController alloc]init];
            bindTeleController.third_Uid = [credential uid];
            bindTeleController.third_Token = [credential token];
            bindTeleController.third_type = @"2";

            [self.navigationController pushViewController:bindTeleController animated:YES];
            return;
        }
        
        _userInfoModel = [RYGUserInfoModel objectWithKeyValues:dic];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserInfo];
        
        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
        [NSKeyedArchiver archiveRootObject:_userInfoModel toFile:path];
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [MobClick profileSignInWithPUID:_userInfoModel.userid provider:@"WB"];
        }
        
//        [RYGSingleton sharedSingleton].userInfo = _userInfoModel;
        //        [RYGSingleton sharedSingleton].userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfo];
//            NSLog(@"%@",[RYGSingleton sharedSingleton].userInfo);
        
    } failure:^(NSError *error) {
        if ([[error valueForKey:@"code"] intValue] == 211) {
            RYGBindTeleViewController* bindTeleController = [[RYGBindTeleViewController alloc]init];
            bindTeleController.third_Uid = [credential uid];
            bindTeleController.third_Token = [credential token];
            bindTeleController.third_type = @"2";

//            bindTeleController.third_Name = nikename;
            [self.navigationController pushViewController:bindTeleController animated:YES];
            return;
        }
    }];

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
