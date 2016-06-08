//
//  RYGStringUtil.h
//  shoumila
//
//  Created by Xmj on 16/4/11.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGStringUtil : NSObject

+ (instancetype)shareInstance;

/**
 *  检测输入的字符串是否为空字符串，null，<null>
 *
 *  @param content 字符串
 *
 *  @return 非空字符串YES,反之为NO
 */
- (BOOL)isNONil:(NSString*)content;

/**
 *  检测输入是否为电话号码
 *
 *  @param content 字符串
 *
 *  @return 电话号码YES,反之为NO
 */
+(BOOL)checkIsPhoneNumber:(NSString *)content;

/**
 *  检测输入是否为email
 *
 *  @param content 字符串
 *
 *  @return email返回YES,反之为NO
 */
+(BOOL)checkIsEmail:(NSString *)content;//检测email

/**
 *  检测输入是否为身份证号
 *
 *  @param identityCard 字符串
 *
 *  @return 正确返回YES,错误返回NO
 */
+ (BOOL)validateIdentityCard: (NSString *)identityCard;


//得到一个字符串的前多少位 index 从0计算 例如Str = @"123" ， 想要取12 ， index 设为 2
+ (NSString *)getPerfixNumberWithIndex:(NSUInteger )index WithResourceStr:(NSString *)resourceStr;

+ (NSDate *)getUserLocaleDateFromAnyDate:(NSDate *)anyData;//标准时间转换成当前时间

+ (NSString *)getUserLocaStringDateWith:(NSString *)UTCString;

+ (NSDate *)stringToDate:(NSString *)time;

+ (NSString *)chectWeek:(NSInteger)day;//检查当前时间是星期几

/*
 oldStr 是要改变的字符串，法则：如果odlStr.legth >= 5 ，返回的Str 就是对应的*.*万；
 例如：oldStr = @"12345";  返回的是  newStr = @"1.2万";
 */
+ (NSString *)backNewStrWithOldStr:(NSString *)oldStr;


/*
 去除掉 oldStr 中的前后的空格（中间的空格不移除），返回新的NewStr 中前后不含空格（中间可能会含有空格）
 oldStr 不能为空
 */
- (NSString *)backBothEndsRemoveOfSpaceNewStrWithOldStr:(NSString *)oldStr;

/*
 去除掉 oldStr 中的所有的空格（中间的空格也会移除），返回新的 NewStr 中不含空格（中间也不含）
 oldStr 不能为空
 */
+ (NSString *)backRemoveOfSpaceNewStrWithOldStr:(NSString *)oldStr;

//+(NSString *)stringDisposeWithFloat:(float)floatValue;


+(CGSize)getSizeWith:(NSString*)string font:(UIFont *)font size:(CGSize)size;

+(NSString *)convertToUserDefaultTime:(NSString *)time;

+(CGFloat)getLabelLength:(NSString *)strString font:(UIFont*)font height:(CGFloat)height;

+(CGFloat)getLabelHeight:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

/**
 *  获取截取后的城市名称
 *
 *  @param string 城市
 *
 *  @return 截取掉省市区，盟，自治区之后的中文字符
 */
+ (NSString *)getCityNameWithOutSuffix:(NSString *)string;

/**
 *  获取用户的userAgent
 *
 *  @return 用户userAgent
 */
+ (NSString *)fetchUserAgent;

/**
 *  去除字符串中的横杠   例如：234-234-32   ->  23423432
 *
 *  @param string 目标字符串
 *
 *  @return 没有横杠的字符串
 */
+ (NSString *)clearBridgeWithStr:(NSString *)string;

@end
