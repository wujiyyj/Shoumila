//
//  RYGAttendedMessageModel.m
//  关注我的消息
//
//  Created by jiaocx on 15/9/11.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAttendedMessageModel.h"

@implementation RYGAttendedMessageModel

#define KeyRYGMessageUserId    @"KeyRYGMessageUserId"
#define KeyRYGMessageUserLogo   @"KeyRYGMessageUserLogo"
#define KeyRYGMessageUserName  @"KeyRYGMessageUserName"

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.userId = [decoder decodeObjectForKey:KeyRYGMessageUserId];
        self.user_logo = [decoder decodeObjectForKey:KeyRYGMessageUserLogo];
        self.user_name = [decoder decodeObjectForKey:KeyRYGMessageUserName];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userId forKey:KeyRYGMessageUserId];
    [encoder encodeObject:self.user_logo forKey:KeyRYGMessageUserLogo];
    [encoder encodeObject:self.user_name forKey:KeyRYGMessageUserName];
}

@end
