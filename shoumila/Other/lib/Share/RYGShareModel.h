//
//  RYGShareModel.h
//  shoumila
//
//  Created by 阴～ on 15/9/15.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface RYGShareModel : NSObject

@property(nonatomic)        ShareType   shareType;
@property(nonatomic,strong) NSString    *shareName;
@property(nonatomic,strong) NSString    *iconName;
@property(nonatomic,strong) NSString    *iconName_Sel;
@property(nonatomic,strong) NSString    *feed_id;
@end