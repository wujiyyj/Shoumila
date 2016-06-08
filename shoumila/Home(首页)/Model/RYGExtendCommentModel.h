//
//  RYGExtendCommentModel.h
//  shoumila
//
//  Created by 贾磊 on 15/9/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGPackage.h"
#import "RYGAttention.h"
 
@interface RYGExtendCommentModel : NSObject
@property(nonatomic,copy) NSString *userid;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *text;

@property(nonatomic,strong) RYGAttention *attention;
@property(nonatomic,strong) RYGPackage *package;
@property(nonatomic,copy) NSString *max_continuous_win;
@property(nonatomic,copy) NSString *win_rate;
@property(nonatomic,copy) NSString *profit_margin;


@end
