//
//  StringHelper.m
//  VANCL
//
//  Created by yek on 10-12-24.
//  Copyright 2010 yek. All rights reserved.
//

#import "StringHelper.h"


@implementation StringHelper

@end

/*
 字符串是否没有内容
 */
inline BOOL stringIsEmpty(NSString* str){
	BOOL ret=NO;
	if(str==nil){
		ret=YES;
	}else{
		NSString * temp=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if([temp length]<1){
			ret=YES;
		}
	}
	return ret;
}

inline NSString* stringOrEmpty(NSString* str){
	return (str==nil?@"":str);
}
inline BOOL stringIsEqual(NSString* str,NSString *str2){
NSString * temp=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * temp2=[str2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([temp isEqualToString:temp2]) {
        return YES;
    }
    return NO;
}
NSString* unitLink(NSString* str){
    
    return [NSString stringWithFormat:@"￥%@",str];
}
NSString* stringLink(NSString* str,NSString *str2){
    
    return [NSString stringWithFormat:@"%@%@",str,str2];
}
NSString* stringUnitLink(NSString* str,NSString *str2){
    
    return [NSString stringWithFormat:@"%@￥%@",str,str2];
}

NSString* startChineseString(NSString* str, int length){
	NSString* ret=str;
	if(str!=nil){
		assert(length>0);
		const int twiceLength=length*2;
		int newLength=0;
		int i=0;
		int lastIndex=0;
		for(i=0;i<twiceLength && i<[str length];++i){
			unichar c=[str characterAtIndex:i];
			if(isalnum(c) || ' '==c){
				//英文算半个
				if(newLength+1<=twiceLength){
					newLength+=1;
				}else{
					break;
				}
			}else{
				if(newLength+2<=twiceLength){
					newLength+=2;
				}else{
					break;
				}
			}
			++lastIndex;
		}
		ret=[str substringToIndex:lastIndex];
		assert(ret!=nil);
	}
	return ret;
}

/*
 从字符串中解析出日期，使用东八时区
 str: yyyy-MM-dd HH:mm:ss
 */
NSDate* dateFromString2(NSString* str, NSString* format){
	NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+8:00"]];
	[dateFormatter setDateFormat:format];
	NSDate* ret=[dateFormatter dateFromString:str];
	[dateFormatter release];
	return ret;	
}


NSDate* dateFromString(NSString* str){
	return dateFromString2(str,@"yyyy-MM-dd HH:mm:ss");
}


/*
日期格式化成字符串格式为:yyyy-MM-dd HH:mm:ss，使用东八时区
 */
NSString* stringFromDate(NSDate* date){
	NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+8:00"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* ret=[dateFormatter stringFromDate:date];
	[dateFormatter release];
	return ret;
}

NSString* generateGUID(){
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];	
}


