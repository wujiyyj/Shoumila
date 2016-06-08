//
//  RYGShareViewHandler.h
//  shoumila
//
//  Created by 阴～ on 15/9/15.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGShareContentModel.h"

@interface RYGShareViewHandler : NSObject
@property(nonatomic,copy) void (^removeViewBlock)();
@property(nonatomic,strong) RYGShareContentModel *contentModel;
+(instancetype)shareInstance;
+ (void)removeShareView;

@end
