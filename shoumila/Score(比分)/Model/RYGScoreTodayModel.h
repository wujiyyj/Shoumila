//
//  RYGScoreTodayModel.h
//  shoumila
//
//  Created by 贾磊 on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGScoreTodayModel : NSObject

@property(nonatomic,strong) NSString *league_name;
@property(nonatomic,strong) NSArray  *match;
@property(nonatomic,assign)CGFloat cellHeight;

@end

@interface RYGScoreTodayEntity : NSObject
@property(nonatomic,strong) NSString *mid;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *stime;
@property(nonatomic,strong) NSString *ht;
@property(nonatomic,strong) NSString *vt;
@property(nonatomic,strong) NSString *hvo;
@property(nonatomic,strong) NSString *vvo;
@property(nonatomic,strong) NSString *dro;
@property(nonatomic,strong) NSString *hr;
@property(nonatomic,strong) NSString *vr;
@property(nonatomic,strong) NSString *hro;
@property(nonatomic,strong) NSString *vro;
@property(nonatomic,strong) NSString *dx;
@property(nonatomic,strong) NSString *dxh;
@property(nonatomic,strong) NSString *dxv;
@end
