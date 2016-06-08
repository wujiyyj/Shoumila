//
//  NSString+SFConvertToLatin.m
//  SFBestIphone
//
//  Created by lijianjie on 14-3-21.
//  Copyright (c) 2014年 sfbest. All rights reserved.
//

#import "NSString+QDConvertToLatin.h"

@implementation NSString (QDConvertToLatin)

/**
 *  返回输入中文的拼音
 *  @param cityName 中文字符
 *  @return 中文拼音
 */
- (NSString *)StringConvertToLaTin
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)self);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);   // 中文转换成拼音
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO); // 除去拼音的音标
    
    NSString *latinString = (__bridge NSString *)(string);
    latinString = [latinString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 32] withString:@""];  //除去空格
    CFRelease(string);
    
    return latinString;
}

-(NSString *)StringConvertToInitalLaTin
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)self);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);   // 中文转换成拼音
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO); // 除去拼音的音标
    
    NSString *latinString = (__bridge NSString *)(string);
    NSArray *alphabetArray=[latinString componentsSeparatedByString:([NSString stringWithFormat:@"%c", 32])];
    NSMutableString *alphabetStr=[[NSMutableString alloc]init];
    
    for (NSString *item in alphabetArray)
    {
        [alphabetStr appendString:[item substringWithRange:(NSMakeRange(0, 1))]];
    }
    
    CFRelease(string);
    return alphabetStr;
}

/**
 *  @brief 将unicode转换成字符
 *
 *  @warning unicode字符\U00A5(@"\\U00A5") 必须摇对\进行转义
 *
 *  @return 可显示字符
 *
 *  @code [@"\\U00A5" unicodeStringConvertToString];
 */
- (NSString *)unicodeStringConvertToString
{
    NSString *upperString = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *escapeQuot = [upperString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *quotString = [[@"\""stringByAppendingString:escapeQuot] stringByAppendingString:@"\""];
    NSData *unicodeData = [quotString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:unicodeData options:NSPropertyListImmutable format:NULL error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end

