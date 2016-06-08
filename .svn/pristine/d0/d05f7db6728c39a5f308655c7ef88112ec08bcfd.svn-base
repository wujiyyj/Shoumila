//
//  RYGSocialPlatformManager.m
//  shoumila
//
//  Created by 阴～ on 15/9/15.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSocialPlatformManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDKTypeDef.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/NSString+Common.h>
#import "NSString+QDConvertToLatin.h"
#import "MBProgressHUD+MJ.h"

typedef void (^CompleteBlock)(NSString *partnerId, NSString *nickName, SFThirdPartLoginFromType from, NSError *error);

@interface RYGSocialPlatformManager()//<ISSViewDelegate, WXApiDelegate>

@property (nonatomic, strong) CompleteBlock completeBlock;

@end

@implementation RYGSocialPlatformManager

- (id)init
{
    if (self = [super init])
    {
//        [ShareSDK registerApp:@"b780397a5910"];  //1224a3c1e1a0
        [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                                   target:self
                                   action:@selector(userInfoUpdateHandler:)];
    }
    return self;
}

+ (id)sharedInstance
{
    static RYGSocialPlatformManager *socialManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socialManager = [[RYGSocialPlatformManager alloc] init];
    });
    return socialManager;
}

- (BOOL)parseOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

#pragma mark -

#pragma mark -
#pragma mark - Update user info
- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist", NSTemporaryDirectory()]];
    if (authList == nil) {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat) {
        case ShareTypeSinaWeibo:
            platName = @"新浪微博";
            break;
        case ShareTypeWeixiSession:
            platName = @"微信好友";
            break;
        case ShareTypeWeixiTimeline:
            platName = @"微信朋友圈";
            break;
        default:
            platName = @"未知";
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++) {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists) {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

#pragma mark -
#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq*)req
{
    
}

- (void)onResp:(BaseResp*)resp
{
    if ([resp isMemberOfClass:[SendAuthResp class]])
    {
//        SendAuthResp *authResp = (SendAuthResp *)resp;
//        [self getAccessTokenForWeiXin:authResp];
    }
}

//- (void)getAccessTokenForWeiXin:(SendAuthResp *)authResp
//{
//    NSString *accessString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WeChatAppID, WeChatAppSecret, authResp.code];
//    NSURLRequest *accessRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:accessString]];
//    [NSURLConnection sendAsynchronousRequest:accessRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        if (connectionError)
//        {
//            self.completeBlock(nil, nil, 0, connectionError);
//        }
//        else
//        {
//            NSDictionary *accessTokenInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            [self getUserInfoForWeiXin:accessTokenInfo];
//        }
//    }];
//}

//- (void)getUserInfoForWeiXin:(NSDictionary *)accessTokenInfo
//{
//    NSString *accessString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessTokenInfo[@"access_token"], accessTokenInfo[@"openid"]];
//    NSURLRequest *accessRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:accessString]];
//    [NSURLConnection sendAsynchronousRequest:accessRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        if (connectionError)
//        {
//            self.completeBlock(nil, nil, 0, connectionError);
//        }
//        else
//        {
//            NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            
//            NSString *uid = userInfo[@"unionid"];
//            NSString *nickname = [userInfo[@"nickname"] unicodeStringConvertToString];
//            self.completeBlock(uid, nickname, SFThirdPartLoginFromTypeWeiXin, nil);
//        }
//    }];
//}


/*
 #pragma mark -
 #pragma mark - Author
 - (void)authorWithType:(ShareType)type completeBlock:(CompleteBlock)completeBlock
 {
 self.completeBlock = completeBlock;
 
 
 if (type == ShareTypeWeixiLogin)
 {
 if ([WXApi isWXAppInstalled])
 {
 [self sendWeiXinAuthRequest];
 }
 else
 {
 NSError *error = [NSError errorWithDomain:@"ErrorDomainCFLocal" code:WXErrCodeUnsupport userInfo:@{NSLocalizedDescriptionKey: @"未安装微信客户端"}];
 self.completeBlock(nil, nil, SFThirdPartLoginFromTypeWeiXin, error);
 }
 return;
 }
 
 id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
 allowCallback:YES
 authViewStyle:SSAuthViewStyleFullScreenPopup
 viewDelegate:nil
 authManagerViewDelegate:self];
 
 [ShareSDK getUserInfoWithType:type authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error){
 
 if (result)
 {
 switch (type)
 {
 case ShareTypeSinaWeibo:
 [self fillSinaWeiboUser:userInfo];
 break;
 
 case ShareTypeTencentWeibo:
 [self fillTecentWeiboUser:userInfo];
 break;
 
 case ShareTypeQQSpace:
 [self fillQQSpaceUser:userInfo];
 break;
 
 default:
 break;
 }
 }
 else
 {
 NSError *authError = [NSError errorWithDomain:@"AuthorError" code:[error errorCode] userInfo:@{ NSLocalizedDescriptionKey: [error errorDescription]}];
 self.completeBlock(nil, nil, 0, authError);
 }
 }];
 }
 */
-(void)sendWeiXinAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"sendWeiXinAuthRequest" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

#pragma mark -
#pragma mark - Share
- (void)shareWithContent:(NSString *)content
          defaultContent:(NSString *)defaultContent
                   image:(UIImage *)image
                   title:(NSString *)title
                     url:(NSString *)url
             description:(NSString *)description
               shareType:(ShareType)shareType
               mediaType:(SSPublishContentMediaType)mediaType
             isFollowing:(BOOL)isFollowing
           compelteBlock:(void (^)(void))compelteBlock
{
//    if (shareType == ShareTypeSinaWeibo)
//    {
//        [self shareSinaWithType:content defaultContent:defaultContent image:image title:title url:url description:description shareType:shareType isFollowing:isFollowing compelteBlock:compelteBlock];
//        return;
//    }
    
    id<ISSCAttachment> productImage = nil;
    if (image)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        UIImage *jpgImage = [UIImage imageWithData:imageData];
        productImage = [ShareSDK jpegImageWithImage:jpgImage quality:0.8];
    }
    
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:productImage
                                                title:title
                                                  url:url
                                          description:content
                                            mediaType:mediaType];
    
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self];
    
    if (isFollowing)
    {
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"收米啦"],
                                        SHARE_TYPE_NUMBER(shareType),
                                        nil]];
    }
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:shareType
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:self
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (end)
                                 {
                                     if (state == SSPublishContentStateSuccess)
                                     {
                                         NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                         [self  resignFirstResponder];
                                         compelteBlock();
                                         [MBProgressHUD showSuccess:@"分享成功"];
                                     }
                                     else if (state == SSPublishContentStateFail)
                                     {
                                         NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                         [self  resignFirstResponder];
                                         [MBProgressHUD showError:@"分享失败"];
                                     }
                                     
                                     
                                 }
                             }];
    
}

- (void)shareSinaWithType:(NSString *)content
           defaultContent:(NSString *)defaultContent
                    image:(UIImage *)image
                    title:(NSString *)title
                      url:(NSString *)url
              description:(NSString *)description
                shareType:(ShareType)shareType
              isFollowing:(BOOL)isFollowing
            compelteBlock:(void (^)(void))compelteBlock
{
    id<ISSCAttachment> productImage = nil;
    if (image)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        UIImage *jpgImage = [UIImage imageWithData:imageData];
        productImage = [ShareSDK jpegImageWithImage:jpgImage quality:0.8];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:defaultContent
                                                image:productImage
                                                title:title
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:(id)self];
    
    if (isFollowing)
    {
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"收米啦"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        nil]];
    }
    
    if ([ShareSDK hasAuthorizedWithType:shareType])
    {
        [ShareSDK oneKeyShareContent:publishContent
                           shareList:[ShareSDK getShareListWithType:shareType, nil]
                         authOptions:authOptions
                       statusBarTips:YES
                              result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                  if (end&&state ==SSResponseStateSuccess) {
                                      compelteBlock();
                                      
                                  }
                                  
                                  
                              }];
        
        return;}
    
    
    [ShareSDK getUserInfoWithType:shareType authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result)
        {
            //分享内容
            [ShareSDK oneKeyShareContent:publishContent
                               shareList:[ShareSDK getShareListWithType:shareType, nil]
                             authOptions:authOptions
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      
                                      if (end&&state ==SSResponseStateSuccess) {
                                          compelteBlock();
                                          //                                          [[SFTipView sharedInstance ] showMessage:@"分享成功"];
                                      }
                                  }];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

#pragma mark -
#pragma mark - ISSViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending) {
        UIButton *leftBtn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
        UIButton *rightBtn = (UIButton *)viewController.navigationItem.rightBarButtonItem.customView;
        
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = viewController.title;
        label.font = [UIFont boldSystemFontOfSize:18];
        [label sizeToFit];
        
        viewController.navigationItem.titleView = label;
    }
    
    if ([UIDevice currentDevice].isPad) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:22];
        viewController.navigationItem.titleView = label;
        label.text = viewController.title;
        [label sizeToFit];
        
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation)) {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        } else {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    } else {
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation)) {
            if ([[UIDevice currentDevice] isPhone5]) {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            } else {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        } else {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    }
}
- (void)viewOnWillDismiss:(UIViewController *)viewController shareType:(ShareType)shareType
{
    
}
- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
    if ([UIDevice currentDevice].isPad) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        } else {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    } else
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            if ([[UIDevice currentDevice] isPhone5]) {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            } else {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        } else {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
}

#pragma mark -
#pragma mark - Cache Author Data
- (void)fillSinaWeiboUser:(id<ISSPlatformUser>)userInfo
{
    NSDictionary *sourceData = [userInfo sourceData];
    NSString *uid = [sourceData objectForKey:@"idstr"];
    NSString *nickname = [sourceData objectForKey:@"screen_name"];
    self.completeBlock(uid, nickname, SFThirdPartLoginFromTypeSina, nil);
}

- (void)fillTecentWeiboUser:(id<ISSPlatformUser>)userInfo
{
    NSDictionary *sourceData = [userInfo sourceData];
    NSString *uid = [sourceData objectForKey:@"openid"];
    NSString *nickname = [sourceData objectForKey:@"nick"];
    self.completeBlock(uid, nickname, SFThirdPartLoginFromTypeTencentWeibo, nil);
}

- (void)fillQQSpaceUser:(id<ISSPlatformUser>)userInfo
{
    id<ISSPlatformCredential> credential = userInfo.credential;
    NSString *uid = [credential uid];
    
    NSDictionary *sourceData = [userInfo sourceData];
    NSString *nickname = [sourceData objectForKey:@"nickname"];
    
    self.completeBlock(uid, nickname, SFThirdPartLoginFromTypeQQ, nil);
}

- (void)resignFirstResponder{
    UITextView *text = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [[UIApplication sharedApplication].keyWindow addSubview:text];
    [text becomeFirstResponder];
    [text resignFirstResponder];
    [text removeFromSuperview];
}

@end
