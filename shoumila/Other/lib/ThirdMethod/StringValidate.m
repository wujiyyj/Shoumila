//
//  StringValidate.m
//  YKProduct
//
//  Created by HeQingshan on 11-10-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StringValidate.h"
#import "RegexKitLite.h"

NSString* const REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
NSString* const REG_MOBILE = @"^(14[0-9]|13[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
NSString* const REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";
NSString* const REG_ENGLISH = @"^[A-Za-z0-9]+$";





@implementation StringValidate
+(BOOL)isChineseValue:(NSString *)input{
    BOOL bChinese = YES;
    for(int i=0; i< [(NSString *)input length];i++) {
        int a = [(NSString *)input characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fa6) {
            
        } else {
            bChinese = NO;
            break;
        }
    }
    
    return bChinese;
}

+(BOOL)isEmail:(NSString *)input{
	return [input isMatchedByRegex:REG_EMAIL];
}

+(BOOL)isPhoneNum:(NSString *)input{
	return [input isMatchedByRegex:REG_PHONE];
}

+(BOOL)isMobileNum:(NSString *)input{
	return [input isMatchedByRegex:REG_MOBILE];
}
//+(BOOL)isEnglishValue:(NSString *)input{
//    return [input isMatchedByRegex:REG_ENGLISH];
//}
+(BOOL)isPhoneOrMobileNum:(NSString*)input
{
    return [self isPhoneNum:input] || [self isMobileNum:input];
}

+(CGSize)sizeOfString:(NSString*)aString size:(float)aSize
{
    UIFont * font = [UIFont systemFontOfSize:aSize];
    return [aString sizeWithFont:font];
}

+(BOOL)isEnglishValue:(NSString *)input{
    BOOL bEngilsh = YES;
    for(int i=0; i< [(NSString *)input length];i++) {
        int a = [(NSString *)input characterAtIndex:i];
        
        if((65 <= a  && a <= 90) ||
           (97 <= a  && a <= 122)) {
        } else {
            bEngilsh = NO;
        }
        
    }
    
    return bEngilsh;
}

+(BOOL)isEnglishOrNumValue:(NSString *)input{
    BOOL bEngilsh = YES;
    for(int i=0; i< [(NSString *)input length];i++) {
        int a = [(NSString *)input characterAtIndex:i];
        
        if((65 <= a  && a <= 90) ||
           (97 <= a  && a <= 122) || [self isNum:a]) {
        } else {
            bEngilsh = NO;
        }
        
    }
    
    return bEngilsh;
}

+ (BOOL)isEnglishCharacters:(NSInteger)characterAtIndex {
    if((65 <= characterAtIndex  && characterAtIndex <= 90) ||
       (97 <= characterAtIndex  && characterAtIndex <= 122)) {
        return YES;
    } else {
        return NO;
    }
}


+ (BOOL)isSpace:(NSInteger)characterAtIndex {
    if (32 == characterAtIndex) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)iswhitespace:(NSInteger)characterAtIndex {
    if (20 == characterAtIndex) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isPunctuation:(NSInteger)characterAtIndex {
    if (44 == characterAtIndex ||
        46 == characterAtIndex ||
        33 == characterAtIndex ||
        63 == characterAtIndex ||
        39 == characterAtIndex) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isTextNoPunctuation:(NSString *)_text {
    for(int i = 0; i < [(NSString *)_text length]; ++i) {
        int a = [(NSString *)_text characterAtIndex:i];
        if ([self isChineseCharacters:a] ||
            [self isEnglishCharacters:a] ||
            [self isNum:a] ||
            [self isSpace:a]) {
        } else {
            return NO;
        }
    }
    return YES;
}
//判断字符串是否含有特殊字符（“（）”除外）
+ (BOOL)isTextNoPunctuationExceptBrackets:(NSString *)_text {
    for(int i = 0; i < [(NSString *)_text length]; ++i) {
        int a = [(NSString *)_text characterAtIndex:i];
        if ([self isChineseCharacters:a] ||
            [self isEnglishCharacters:a] ||
            [self isNum:a] ||
            [self isSpace:a] || 
            [self iswhitespace:a] ||
            a == 40 ||
            a == 41 ||
            a == 65288 ||
            a == 65289
            
            ) {
        } else {
            return NO;
        }
    }
    return YES;
}
//判断字符串是否含有特殊字符（逗号、空格、点、横杆、下划线、撇号）
+ (BOOL)isTextPunctuationExceptBrackets:(NSString *)_text {
    for(int i = 0; i < [(NSString *)_text length]; ++i) {
        int a = [(NSString *)_text characterAtIndex:i];
        if ([self isChineseCharacters:a] ||
            [self isEnglishCharacters:a] ||
            [self isNum:a] ||
            [self isSpace:a] ||
            [self iswhitespace:a] ||
            a == 39 ||
            a == 44 ||
            a == 46 ||
            a == 45 ||
            a == 95
            ) {
        } else {
            return YES;
        }
    }
    return NO;
}

//判断字符串是否含有空格
+ (BOOL)isTextHaswhitespace:(NSString *)_text {
    for(int i = 0; i < [(NSString *)_text length]; ++i) {
        int a = [(NSString *)_text characterAtIndex:i];
        if (
            [self isSpace:a] || 
            [self iswhitespace:a]            
            ) 
        {
            
        } 
        else {
            return NO;
        }
    }
    return YES;
}

+(BOOL)isNumberStr:(NSString *)_text{
    for(int i = 0; i < [(NSString *)_text length]; ++i) {
        int a = [(NSString *)_text characterAtIndex:i];
        if ([self isNum:a]) {
        } else {
            return NO;
        }
    }
    return YES;
}
+ (BOOL)isNum:(NSInteger)characterAtIndex {
    if(48 <= characterAtIndex  && characterAtIndex <= 57) {
        return YES;
    } else {
        return NO;
    }
}
+ (BOOL)isZeroNum:(NSInteger)characterAtIndex {
    
    
    if(48 == characterAtIndex ) {
        return YES;
    } else {
        return NO;
    }
}


+ (BOOL)isChineseCharacters:(NSInteger)characterAtIndex {
    if(characterAtIndex >= 0x4e00 && characterAtIndex <= 0x9fa6) {
        return YES;
    } else {
        return NO;
    }
}
+ (BOOL)isTextHavePunctuation:(NSString *)_text {
    for(int i = 0; i < [(NSString *)_text length]; ++i) {
        int a = [(NSString *)_text characterAtIndex:i];
        if ([self isChineseCharacters:a] ||
            [self isEnglishCharacters:a] ||
            [self isNum:a] ||
            [self isSpace:a] ||
            [self isPunctuation:a]) {
        } else {
            return NO;
        }
    }
    return YES;
}

//判断用户输入的是中文或者英文
+ (BOOL)ischineseOrEnglish:(NSString *)input{

    BOOL bCOE = YES;
    for(int i=0; i< [(NSString *)input length];i++) {
        int a = [(NSString *)input characterAtIndex:i];
        
        if( (a >= 0x4e00 && a <= 0x9fa6) || (65 <= a  && a <= 90) ||
           (97 <= a  && a <= 122) ) {
            
        } else {
            bCOE = NO;
            break;
        }
    }
    
    return bCOE;
}

@end
