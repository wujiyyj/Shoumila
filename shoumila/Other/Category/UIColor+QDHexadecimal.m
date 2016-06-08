//
//  UIColor+QDHexadecimal.m
//  qudouzhuanjia
//
//  Created by  on 15/5/1.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "UIColor+QDHexadecimal.h"

@implementation UIColor (QDHexadecimal)

+(UIColor *)colorWithHexadecimal:(NSString *)hexadecimal{
    
    if (!hexadecimal || [hexadecimal isEqualToString:@""]) {
        return nil;
    }
    @try {
        unsigned red,green,blue;
        NSRange range;
        range.length = 2;
        range.location = 1;
        [[NSScanner scannerWithString:[hexadecimal substringWithRange:range]] scanHexInt:&red];
        range.location = 3;
        [[NSScanner scannerWithString:[hexadecimal substringWithRange:range]] scanHexInt:&green];
        range.location = 5;
        [[NSScanner scannerWithString:[hexadecimal substringWithRange:range]] scanHexInt:&blue];
        UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
        return color;
    }
    @catch (NSException *exception) {
        return nil;
    }
    
}
@end
