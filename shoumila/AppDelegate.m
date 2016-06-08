//
//  AppDelegate.m
//  shoumila
//
//  Created by 贾磊 on 15/7/21.
//  Copyright (c) 2015年 贾磊. All rights reserved.
//

#import "AppDelegate.h"
#import "RYGTabBarViewController.h"
#import "RYGViewController.h"
#import "UMFeedback.h"
#import "UMessage.h"
#import "UMOpus.h"
#import "UMOpenMacros.h"
#import "RYGLoginViewController.h"
#import "RYGPayResultViewController.h"
#import "RYGMessageManager.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "APService.h"
#import "RYGMessageManager.h"

#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setUpShareSDK];
    [UMOpus setAudioEnable:YES];
    [UMFeedback setAppkey:APPKEY];
    [UMFeedback setLogEnabled:NO];
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
    
    application.statusBarHidden = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[RYGViewController alloc] init];
    self.window.rootViewController = self.viewController;
    
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
    {
        [UMFeedback didReceiveRemoteNotification:notificationDict];
    }
    
    // with remote push notification
    [UMessage startWithAppkey:APPKEY launchOptions:launchOptions];
    if (UM_IOS_8_OR_LATER) {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    } else {
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert];
    }
    [UMessage setLogEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkFinished:)
                                                 name:UMFBCheckFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginAction)
                                                 name:kLoginNSNotification
                                               object:nil];
    
    [self.window makeKeyAndVisible];
    
    //友盟统计
    UMConfigInstance.appKey = APPKEY;
    UMConfigInstance.eSType = E_UM_NORMAL; // 仅适用于游戏场景
    [MobClick startWithConfigure:UMConfigInstance];
    
    
    //向微信注册
    [WXApi registerApp:@"wx34880a332749382e" withDescription:@"cn.shoumila"];
    
    // 极光推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
    // 启动时异步进行网络请求，消息数据
    [self sendAsynchronousRequest];
    
    
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    
    return YES;

}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        
        RYGPayResultViewController* payResultVC = [[RYGPayResultViewController alloc]init];
        //支付成功
        if (resp.errCode == WXSuccess) {
            payResultVC.isSuccess = YES;
        }
        else {
            payResultVC.isSuccess = NO;
        }
        UINavigationController *curNav = [self getCurrentVC];
        [curNav pushViewController:payResultVC animated:YES];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        NSLog(@"--%d",resp.errCode);
        
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)sendAsynchronousRequest
{
    // 是否登录
    if ([RYGUtility isLogin])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[RYGMessageManager shareMessageManager] messageSendAsynchronousRequest];
        });
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)receiveNotification:(id)receiveNotification {
    //    NSLog(@"receiveNotification = %@", receiveNotification);
}

- (void)checkFinished:(NSNotification *)notification {
    NSLog(@"class checkFinished = %@", notification);
}

- (void)setUpShareSDK{
    
    [ShareSDK registerApp:@"b780397a5910"];//字符串api20为您的ShareSDK的AppKey
    [ShareSDK ssoEnabled:YES];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    //
    [ShareSDK connectSinaWeiboWithAppKey:kAppKey
                               appSecret:kAppSecret
                             redirectUri:kAppRedirectURL];

    [ShareSDK connectSinaWeiboWithAppKey:kAppKey
                               appSecret:kAppSecret
                             redirectUri:kAppRedirectURL
                             weiboSDKCls:[WeiboSDK class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
//    [ShareSDK connectWeChatWithAppId:WeChatAppID
//                           wechatCls:[WXApi class]];
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:WeChatAppID
                           appSecret:WeChatAppSecret
                           wechatCls:[WXApi class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:QQAPPID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQZoneWithAppKey:QQAPPID
                           appSecret:QQAPPKey
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //微博联合登录
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:kAppKey];

    
}

#pragma mark - Remote Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"device token is: %@", deviceToken);
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"umeng message alias is: %@", [UMFeedback uuid]);
    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    self.device_token = [deviceToken description];
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    [UMessage didReceiveRemoteNotification:userInfo];
    [UMFeedback didReceiveRemoteNotification:userInfo];
    // 收到通知
    [APService handleRemoteNotification:userInfo];
    [self afterNotificationHandle];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self afterNotificationHandle];
}

- (void)afterNotificationHandle {
    RYGMessageManager *shareMessage = [RYGMessageManager shareMessageManager];
    [shareMessage messageSendAsynchronousRequest];
    
    [self updateMessageItem];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    NSString *strUrl = [url absoluteString];
    if ([strUrl hasPrefix:@"wb840542347://"] || [strUrl hasPrefix:@"wx34880a332749382e://"] || [strUrl hasPrefix:@"QQ41DB333E://"] || [strUrl hasPrefix:@"tencent1104884542://"]) {
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
    
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"new feedback", nil)])
    {
        if (buttonIndex == 1) // "open" button
        {
            UINavigationController *currentVC = (UINavigationController *)self.window.rootViewController;
            [currentVC pushViewController:[UMFeedback feedbackViewController]
                                 animated:YES];
        }
    }
}

- (void)loginAction{
    RYGLoginViewController *loginViewController = [[RYGLoginViewController alloc]init];
    loginViewController.isBackHome = YES;
    UINavigationController *curNav = [self getCurrentVC];
    [curNav pushViewController:loginViewController animated:YES];
}

//获取当前窗口导航控制器
- (UINavigationController *)getCurrentVC
{
    UITabBarController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    UITabBarController *tabVc = result.childViewControllers[1];
    NSInteger index = tabVc.selectedIndex;
    
    return tabVc.viewControllers[index];
}

- (void)updateMessageItem {
    // 是否登录
    if ([RYGUtility isLogin])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[RYGMessageManager shareMessageManager] unreadMessageCont:^(RYGMessageCount *messageCount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateMessageItem:messageCount.total_num];
                });
            }];
        });
    }
}

- (void)updateMessageItem:(NSString *)messageNums {
    
    RYGTabBarViewController *tabBarCtr = self.viewController.centerVc;
    if (nil == messageNums || [messageNums isEqualToString:@""]) {
        return;
    }
    NSInteger messageTotal = [messageNums integerValue];
    UITabBarItem *tabItem = [tabBarCtr.tabBarItems objectAtIndex:3];
    if (messageTotal > 999) {
        tabItem.badgeValue = @"N";
    }
    else if (messageTotal > 0) {
        tabItem.badgeValue = [NSString stringWithFormat:@"%@", messageNums];
    }
    else {
        tabItem.badgeValue = nil;
    }
}

@end
