//
//  RYGDynamicDetailViewController.h
//  shoumila
//
//  Created by 贾磊 on 15/9/8.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"

@protocol ChatViewDelegate <NSObject>

@optional
- (void)reloadData;
- (void)sendButtonPressed:(NSDictionary *)info;
- (void)updateUserInfo:(NSDictionary *)info;
@end


@interface RYGDynamicDetailViewController : RYGBaseViewController
@property(nonatomic,copy) NSString * feed_id;
@property(nonatomic,copy) NSString * cat;
@end
