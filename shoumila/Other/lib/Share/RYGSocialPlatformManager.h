//
//  RYGSocialPlatformManager.h
//  shoumila
//
//  Created by 阴～ on 15/9/15.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

typedef NS_ENUM(NSInteger, SFThirdPartLoginFromType)
{
    SFThirdPartLoginFromTypeSelf           = 0,   // self
    SFThirdPartLoginFromTypeSina           = 1,   // sina
    SFThirdPartLoginFromTypeTencentWeibo   = 2,   // 腾讯微博
    SFThirdPartLoginFromTypeAlipay         = 3,   // 阿里支付
    SFThirdPartLoginFromTypeEgou           = 4,   // egou
    SFThirdPartLoginFromTypeQQ             = 5,   // QQ
    SFThirdPartLoginFromTypeQQCB           = 6,   // QQ彩贝
    SFThirdPartLoginFromTypeDG             = 7,   // 豆果网
    SFThirdPartLoginFromTypeSF             = 8,   // 速运大网
    SFThirdPartLoginFromTypeWeiXin         = 9,   // 微信
};

@interface RYGSocialPlatformManager : NSObject

+ (id)sharedInstance;
- (BOOL)parseOpenURL:(NSURL *)url;

//- (void)authorWithType:(ShareType)type completeBlock:(void (^)(NSString *partnerId, NSString *nickName, SFThirdPartLoginFromType from, NSError *error))completeBlock;

/**
 *	@brief	创建分享内容对象，根据以下每个字段适用平台说明来填充参数值
 *
 *	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
 *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
 *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、facebook、twitter、邮件、打印、微信、QQ、拷贝）
 *	@param 	title 	标题（QQ空间、人人、微信、QQ）
 *	@param 	url 	链接（QQ空间、人人、instapaper、微信、QQ）
 *	@param 	description 	主体内容（人人）
 *	@param 	shareType 	分享类型（QQ、微信）
 *	@param 	compelteBlock 	返回事件
 */
- (void)shareWithContent:(NSString *)content
          defaultContent:(NSString *)defaultContent
                   image:(UIImage *)image
                   title:(NSString *)title
                     url:(NSString *)url
             description:(NSString *)description
               shareType:(ShareType)shareType
               mediaType:(SSPublishContentMediaType)mediaType
             isFollowing:(BOOL)isFollowing
           compelteBlock:(void (^)(void))compelteBlock;

@end
