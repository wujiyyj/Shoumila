//
//  RYGMessageBaseModel.m
//  shoumila
//
//  Created by jiaocx on 15/9/11.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageBaseModel.h"

@implementation RYGMessageBaseModel

#define KeyRYGMessageNum    @"KeyRYGMessageNum"
#define KeyRYGMessageText   @"KeyRYGMessageText"
#define KeyRYGMessageCtime  @"KeyRYGMessageCtime"
#define KeyRYGMessageMtype @"KeyRYGMessageMtype"
#define KeyRYGMessageUserId    @"KeyRYGMessageUserId"
#define KeyRYGMessageUserLogo   @"KeyRYGMessageUserLogo"
#define KeyRYGMessageUserName  @"KeyRYGMessageUserName"

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.num = [decoder decodeObjectForKey:KeyRYGMessageNum];
        self.text = [decoder decodeObjectForKey:KeyRYGMessageText];
        self.ctime = [decoder decodeObjectForKey:KeyRYGMessageCtime];
        self.mtype = [decoder decodeObjectForKey:KeyRYGMessageMtype];
        self.userid = [decoder decodeObjectForKey:KeyRYGMessageUserId];
        self.user_logo = [decoder decodeObjectForKey:KeyRYGMessageUserLogo];
        self.user_name = [decoder decodeObjectForKey:KeyRYGMessageUserName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.num forKey:KeyRYGMessageNum];
    [encoder encodeObject:self.text forKey:KeyRYGMessageText];
    [encoder encodeObject:self.ctime forKey:KeyRYGMessageCtime];
    [encoder encodeObject:self.mtype forKey:KeyRYGMessageMtype];
    [encoder encodeObject:self.userid forKey:KeyRYGMessageUserId];
    [encoder encodeObject:self.user_logo forKey:KeyRYGMessageUserLogo];
    [encoder encodeObject:self.user_name forKey:KeyRYGMessageUserName];
}

@end
