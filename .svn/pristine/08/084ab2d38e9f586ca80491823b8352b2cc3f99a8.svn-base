//
//  RYGStringUtil.m
//  shoumila
//
//  Created by Xmj on 16/4/11.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import "RYGStringUtil.h"
#import <objc/runtime.h>
#import <sys/sysctl.h>

#define OSVersionIsAtLeastiOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

@implementation RYGStringUtil

+ (instancetype)shareInstance
{
    static dispatch_once_t pred = 0;
    static RYGStringUtil *_shareIntance = nil;
    dispatch_once(&pred, ^{
        _shareIntance = [[self alloc] init]; // or some other init method
    });
    return _shareIntance;
}

-(BOOL)isNONil:(NSString*)content{
    //    NSAssert(content != nil, @"content is null");
    if (!content) {
        return false;
    }
    if ([content isKindOfClass:[NSNull class]]) {
        return false;
    }
    if (![content isKindOfClass:[NSString class]] || content==nil||[content length]<1) {
        return false;
    }
    content= [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([@"" isEqualToString:content]) {
        return false;
    }
    if ([content isEqualToString:@"\" \""]) {
        return false;
    }
    if ([content isEqualToString:@"(null)"]) {
        return false;
    }
    if ([content isEqualToString:@"<null>"]) {
        return false;
    }
    if ([content isEqualToString:@"null"]) {
        return false;
    }
    if ([content isEqualToString:@"*nil description*"]) {
        return false;
    }
    return true;
}

+ (BOOL)checkIsPhoneNumber:(NSString *)content
{
    if (!content) {
        return false;
    }
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:content];
}

+ (BOOL)checkIsEmail:(NSString *)content
{
    if (!content) {
        return false;
    }
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:content];
    
}
//身份证号验证
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//得到一个字符串的前多少位 index 从0计算 例如Str = @"123"  想要取12  index 设为 2
+ (NSString *)getPerfixNumberWithIndex:(NSUInteger )index WithResourceStr:(NSString *)resourceStr
{
    NSString *perfixStr;
    if (resourceStr.length > index) {
        perfixStr = [resourceStr substringToIndex:index];
    }else {
        perfixStr = resourceStr;
    }
    return perfixStr;
}

+ (NSDate *)getUserLocaleDateFromAnyDate:(NSDate *)anyData
{
    //UTC为标准时间、GST为中国时间
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    
    NSInteger sourceOffSet = [sourceTimeZone secondsFromGMTForDate:anyData];
    
    NSInteger detinationOffSet = [destinationTimeZone secondsFromGMTForDate:anyData];
    
    NSTimeInterval interval = detinationOffSet - sourceOffSet;
    
    NSDate *date = [[NSDate alloc]initWithTimeInterval:interval sinceDate:anyData];
    return date;
}


+ (NSString *)getUserLocaStringDateWith:(NSString *)UTCString
{
    NSDateFormatter *origionFormatter = [[NSDateFormatter alloc]init];
    [origionFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    NSDate *anyDate = [origionFormatter dateFromString:UTCString];
    NSString *dateString = [NSString stringWithFormat:@"%@",[RYGStringUtil getUserLocaleDateFromAnyDate:anyDate]];
    return dateString;
}

+ (NSDate *)stringToDate:(NSString *)time
{
    NSDateFormatter *origionFormatter = [[NSDateFormatter alloc]init];
    if (time.length>24) {
        [origionFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSSzzzz"];
    }else{
        [origionFormatter setDateFormat:@"yyyy-MM-dd HH:mm:sszzzz"];
    }
    return [origionFormatter dateFromString:time];
}


+ (NSString *)chectWeek:(NSInteger)day
{
    NSString *week = nil;
    if (day ==1) {
        week = @"周日";
    }else if (day ==2){
        week = @"周一";
    }else if (day ==3){
        week = @"周二";
    }
    else if (day ==4){
        week = @"周三";
    }else if (day ==5){
        week = @"周四";
    }else if (day ==6){
        week = @"周五";
    }else if (day ==7)
    {
        week = @"周六";
    }else{
        week = @"时间出错";
    }
    return week;
}

+ (NSString *)getWeekDayWithDay:(NSInteger )day
{
    NSString *week = nil;
    if (day ==1) {
        week = @"周日";
    }else if (day ==2){
        week = @"周一";
    }else if (day ==3){
        week = @"周二";
    }else if (day ==4){
        week = @"周三";
    }else if (day ==5){
        week = @"周四";
    }else if (day ==6){
        week = @"周五";
    }else if (day ==7)
    {
        week = @"周六";
    }else{
        week = @"周一";
    }
    return week;
}


/*
 oldStr 是要改变的字符串，法则：如果odlStr.legth >= 5 ，返回的Str 就是对应的*.*万；
 例如：oldStr = @"12345";  返回的是  newStr = @"1.2万";
 
 */
+ (NSString *)backNewStrWithOldStr:(NSString *)oldStr
{
    
    NSString *newStr;
    NSInteger strLength = oldStr.length;
    if (strLength >= 5) {
        NSString *tempStr = [oldStr substringToIndex:(strLength - 3)];
        NSMutableString *tempMutableStr = [NSMutableString stringWithString:tempStr];
        [tempMutableStr insertString:@"." atIndex:(tempStr.length - 1)];
        newStr = [NSString stringWithFormat:@"%@万",tempMutableStr];
    }else {
        newStr = oldStr;
    }
    return newStr;
}


/*
 去除掉 oldStr 中的前后的空格（中间的空格不移除），返回新的NewStr 中前后不含空格（中间可能会含有空格）
 oldStr 不能为空
 */
- (NSString *)backBothEndsRemoveOfSpaceNewStrWithOldStr:(NSString *)oldStr
{
    NSString *newStr = @"";
    NSMutableString *oldMutableStr = [NSMutableString stringWithString:oldStr];
    newStr = [oldMutableStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return newStr;
}


/*
 去除掉 oldStr 中的所有的空格（中间的空格也会移除），返回新的 NewStr 中不含空格（中间也不含）
 oldStr 不能为空
 */
+ (NSString *)backRemoveOfSpaceNewStrWithOldStr:(NSString *)oldStr
{
    NSString *newStr = @"";
    if (oldStr==nil) {
        return newStr;
    }
    NSMutableString *oldMutableStr = [NSMutableString stringWithString:oldStr];
    newStr = [oldMutableStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
    
}

+(NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%f",floatValue];
    NSInteger len = str.length;
    for (NSInteger i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [NSString stringWithFormat:@"%@00",str];
        //        [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}


+(CGSize)getSizeWith:(NSString*)string font:(UIFont *)font size:(CGSize)size
{
    CGSize newSize=CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    newSize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine  attributes:attribute context:nil].size;
    
    return newSize;
}


+(NSString *)convertToUserDefaultTime:(NSString *)time
{
    NSDateFormatter *origionFormatter = [[NSDateFormatter alloc]init];
    if (time.length>25) {
        [origionFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSSzzzz"];
    }else{
        [origionFormatter setDateFormat:@"yyyy-MM-dd HH:mm:sszzzz"];
    }
    
    NSDate *anyDate = [origionFormatter dateFromString:time];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    NSString *convertString = [NSString stringWithFormat:@"%@",destinationDateNow];
    if (convertString.length>19) {
        convertString = [convertString substringWithRange:NSMakeRange(5, 11)];
    }
    return convertString;
}



+(CGFloat)getLabelLength:(NSString *)strString font:(UIFont*)font height:(CGFloat)height{
    CGSize size=CGSizeMake(MAXFLOAT, height);
    CGFloat newPriceWidth=0;
    if (OSVersionIsAtLeastiOS7) {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize newSize =[strString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine  attributes:attribute context:nil].size;
        newPriceWidth=newSize.width;
    }else{
        newPriceWidth= [strString sizeWithFont:font
                             constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping].width;
    }
    return newPriceWidth;
}
+(CGFloat)getLabelHeight:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGSize size =CGSizeMake(width,MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize  actualsize;
    if (OSVersionIsAtLeastiOS7) {
        actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    }else{
        actualsize=[string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return actualsize.height;
}

+(NSString *)getCityNameWithOutSuffix:(NSString *)string
{
    if (![[RYGStringUtil shareInstance]isNONil:string]) {
        return @"北京";
    }
    NSString *cityName=[NSString stringWithFormat:@"%@",string];
    NSInteger len=cityName.length;
    if ([[RYGStringUtil shareInstance]isNONil:cityName]) {
        if ([cityName hasSuffix:@"市"]||[cityName hasSuffix:@"省"]||[cityName hasSuffix:@"地"]||[cityName hasSuffix:@"盟"]) {
            cityName = [cityName substringToIndex:len-1];
        }else if([cityName hasSuffix:@"自治"]||[cityName hasSuffix:@"地区"]){
            cityName = [cityName substringToIndex:len-2];
        }else if([cityName hasSuffix:@"自治州"]){
            cityName = [cityName substringToIndex:len-3];
        }else if ([cityName hasSuffix:@"市市辖区"]){
            cityName = [cityName substringToIndex:len-4];
        }
    }else{
        cityName = @"北京";
    }
    return cityName;
}

+ (NSString *)fetchUserAgent{
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableString *userAgent = [NSMutableString stringWithCapacity:1];
    [userAgent appendString:@"showseller"];
    [userAgent appendString:@" "];
    [userAgent appendString:appVersion];
    NSString *name = [RYGStringUtil fetchDevicePlatform];
    [userAgent appendString:@";"];
    [userAgent appendString:@"iOS"];
    [userAgent appendString:@"("];
    [userAgent appendString:name];
    [userAgent appendString:@" "];
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    [userAgent appendFormat:@"%f",version];
    [userAgent appendString:@")"];
    return userAgent;
}

- (NSString *)platformString{
    NSString *platform = [RYGStringUtil fetchDevicePlatform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2G (Cellular)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (NSString *)fetchDevicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
+ (NSString *)clearBridgeWithStr:(NSString *)string;
{
    return [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
