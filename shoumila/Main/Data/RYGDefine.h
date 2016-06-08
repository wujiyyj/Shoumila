//
//  RYGDefine.h
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#ifndef shoumila_RYGDefine_h
#define shoumila_RYGDefine_h

#define PI 3.141592653f

//测试
//#define BaseUrl     @"http://182.92.64.145/"
//线上
#define BaseUrl     @"http://api.sml88.com/"

//通知名称
#define kLoginNSNotification @"kLoginNSNotification"
#define kReloadHomeNotification @"kReloadHomeNotification"
#define kPublishVCCancelNotification @"kPublishVCCancelNotification"
#define kRemoveView  @"kRemoveView"

//设备唯一标志符UUID
#define DeviceUUID  [[UIDevice currentDevice].identifierForVendor UUIDString]

//测试token
#define Token       @"3b64xOuIYxkFIv86EDjbvQTifLNBx7VZVxpS0f7Aw5sRvHmbWpaC-4VMznXqNMZcCsust7yDqNaqxpp_H7epbnS8-63w"
#define UserInfo    @"userInfo"
#define PublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCqE+lblPdEKjTY/HiLiZGHiQSBDE+/5FO6H6SdXPfzEnuz310YmFTKejIAd0ZeQ+73a/+6JloMlwNXsXnVRk20CmnnPxOb6hd/RZAW7uBgMCr4yk9EpjNYMEhzH5ASYiij4biR3j01oIOoMfZMFYBGyeoC6gp4HxCyBxzmNUfPDQIDAQAB"

//****************************   首页   ****************************//

#define Feed_List  @"feed/feed_list_new"
#define Feed_praise @"feed/praise"
#define Feed_add_favorite   @"feed/add_favorite"
#define Feed_detail @"feed/detail"
#define Article_detail @"/feed/article_detail"
#define Feed_threads    @"feed/threads"
#define Feed_delelte    @"feed/del"
#define Feed_comment    @"feed/comment"
#define Feed_favorite   @"feed/favorited"
#define Feed_published  @"feed/published"
#define Feed_involvemented   @"feed/involvemented"
#define User_report     @"user/report"
#define Feed_publish    @"feed/publish"
#define Upload_uptoken  @"upload/uptoken"
#define Search_hot_words    @"search/hot_words"
#define Feed_lock       @"feed/lock"
#define Feed_hide       @"feed/hide"
#define Feed_closure    @"feed/closure"
#define Feed_can_recommend  @"feed/can_recommend"
#define Feed_up_sharenum    @"feed/up_sharenum"

#define Feed_myAttention    @"feed/my_attention"
#define Feed_myPackage      @"feed/my_package"
#define Feed_gq_list        @"feed/gq_list"

//****************************   比分   ****************************//
#define Score_Gq    @"score/gq"
#define Score_Today @"score/today"



//****************************   排行榜   ****************************//


#define Ranking_Week_list @"ranking/week_list"
#define Ranking_Month_list @"ranking/month_list"
#define Ranking_Vip_list @"ranking/vip_list"
#define Ranking_Active_list @"ranking/active_list"


//****************************   消息   ****************************//
#define Message_List @"msg/index_list"
#define Message_Reply_Me @"feed/comment_me"
#define Message_Refer_To_Me @"feed/at_me"
#define Message_Praise_Me @"feed/praise_me"
#define Message_Center @"msg/msg_center"
#define Message_Atteded_Person_Dynamic @"msg/attention_msg"
#define Message_Total_Num @"msg/total_num"
#define Message_AttentionDel @"msg/attention_del"



//****************************   个人   ****************************//

#define User_Get_EncryptionKey  @"user/get_encryptionkey"

#define User_Register       @"user/register"
#define User_Login          @"user/login"
#define User_Detail         @"user/detail"
#define User_ThirdReg       @"user/third_reg"
#define User_Modify         @"user/modify"
#define User_GetPasswd      @"user/get_passwd"
#define User_ChangePasswd   @"user/change_pwd"
#define User_Logout         @"user/logout"
#define User_Personal_center    @"user/personal_center"
#define User_Attention      @"user/attention"
#define User_AttentionList  @"user/attention_list"
#define User_AddBlack       @"user/add_blacklist"
#define User_BlackList      @"user/blacklist"
#define User_FunsList       @"user/funs_list"
#define User_Search         @"user/search"
#define User_PushSettingList    @"user/push_setting_list"
#define User_PushSetting    @"user/push_setting"
#define User_UserMoney      @"user/user_money"
#define User_UserPraise     @"user/praise"
#define User_Report         @"user/report"
#define User_Refund         @"user/refund"
#define User_MoneyLog       @"user/money_log"
#define User_MoneyBack      @"orderpay/money_back"

#define User_WinLose        @"feed/win_list"

#define Package_Bought      @"package/bought"
#define Package_Created     @"package/created"
#define Package_Subscribe   @"package/subscribe"    //订阅套餐
#define Package_Detail      @"package/detail"
#define Package_Add_edit    @"package/add_edit"

#define OrderPay_list       @"orderpay/order_list"
#define OrderPay_detail     @"orderpay/order_detail"

//****************************   其他   ****************************//

//短信验证码
#define Sms_Send     @"sms/send"

//****************************   shareSDK   ****************************//
#define WeChatAppID         @"wx34880a332749382e"
#define WeChatAppSecret     @"946bf0f65e4dba678ba8012a57f8f8a3"
#define QQAPPID             @"1104884542"
#define QQAPPKey            @"O3zVj3YmKbKV6O7e"
#define kAppKey             @"840542347"
#define kAppSecret          @"05548afc9a6f042f93549ece4e81d8db"
#define kAppRedirectURL     @"https://api.weibo.com/oauth2/default.html"

#endif