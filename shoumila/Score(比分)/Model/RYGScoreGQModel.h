//
//  RYGScoreGQModel.h
//  shoumila
//
//  Created by 贾磊 on 15/8/20.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGColorChange.h"

@interface RYGScoreGQModel : NSObject
@property(nonatomic,strong) NSString *league_name;
@property(nonatomic,strong) NSArray  *match;
@property(nonatomic,assign)CGFloat cellHeight;
@end

@interface RYGScoreGQEntity : NSObject
@property(nonatomic,strong) NSString *mid;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *stime;
@property(nonatomic,strong) NSString *hc;
@property(nonatomic,strong) NSString *t;
@property(nonatomic,strong) NSString *hs;
@property(nonatomic,strong) NSString *vs;
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
@property(nonatomic,strong) RYGColorChange  *change;
@end
