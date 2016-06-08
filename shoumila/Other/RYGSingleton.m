//
//  RYGSingleton.m
//  shoumila
//
//  Created by yinyujie on 15/8/7.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSingleton.h"

@implementation RYGSingleton
@synthesize userInfo;

+ (RYGSingleton *)sharedSingleton
{
    static RYGSingleton *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[RYGSingleton alloc] init];
        
        return sharedSingleton;
    }
}

@end
