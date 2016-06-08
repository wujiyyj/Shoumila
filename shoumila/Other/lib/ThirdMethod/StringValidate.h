//
//  StringValidate.h
//  YKProduct
//
//  Created by HeQingshan on 11-10-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const REG_EMAIL;
extern NSString* const REG_PHONE;
extern NSString* const REG_MOBILE;
extern NSString* const REG_ENGLISH;
extern NSString* const REG_CHINESE;
@interface StringValidate : NSObject {
    
}
+(BOOL)isNumberStr:(NSString *)_text;
+ (BOOL)isZeroNum:(NSInteger)characterAtIndex;
+(BOOL)isChineseValue:(NSString *)input;
+(BOOL)isEmail:(NSString *)input;
+(BOOL)isPhoneNum:(NSString *)input;
+(BOOL)isMobileNum:(NSString *)input;
+(BOOL)isEnglishValue:(NSString *)input;
+(BOOL)isEnglishOrNumValue:(NSString *)input;
+(BOOL)isPhoneOrMobileNum:(NSString*)input;
+(CGSize)sizeOfString:(NSString*)aString size:(float)aSize;
// 判断是否有特殊字符（无标点）
+ (BOOL)isTextNoPunctuation:(NSString *)_text;
// 判断是否有特殊字符（有标点）
+ (BOOL)isTextHavePunctuation:(NSString *)_text;
//出去含括号的特殊字符
+ (BOOL)isTextNoPunctuationExceptBrackets:(NSString *)_text;
//判断字符串是否含有特殊字符（逗号、空格、点、横杆、下划线、撇号）
+ (BOOL)isTextPunctuationExceptBrackets:(NSString *)_text;
//包含空格
+ (BOOL)isTextHaswhitespace:(NSString *)_text;

+ (BOOL)isChineseCharacters:(NSInteger)characterAtIndex;
+ (BOOL)isNum:(NSInteger)characterAtIndex;

//判断用户输入的是中文或者英文
+ (BOOL)ischineseOrEnglish:(NSString *)input;

@end
