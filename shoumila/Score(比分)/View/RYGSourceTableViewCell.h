//
//  RYGSourceTableViewCell.h
//  shoumila
//
//  Created by 贾磊 on 15/8/29.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGScoreGQModel.h"
#import "RYGScoreTodayModel.h"
#import "RYGScoreParam.h"

@interface RYGSourceTableViewCell : UITableViewCell
@property(nonatomic,strong) RYGScoreGQEntity *data;
@property(nonatomic,assign) BOOL    isGQ;


@property (strong, nonatomic) UILabel *l1;
@property (strong, nonatomic) UILabel *l2;
@property (strong, nonatomic) UILabel *l3;
@property (strong, nonatomic) UILabel *ht;
@property (strong, nonatomic) UILabel *vt;
@property (strong, nonatomic) UIButton *hvo;
@property (strong, nonatomic) UIButton *vvo;
@property (strong, nonatomic) UIButton *dro;
@property (strong, nonatomic) UIButton *hr;
@property (strong, nonatomic) UIButton *vr;
@property (strong, nonatomic) UIButton *hro;
@property (strong, nonatomic) UIButton *vro;
@property (strong, nonatomic) UIButton *dx;
@property (strong, nonatomic) UIButton *dxh;
@property (strong, nonatomic) UIButton *dxv;

@property (strong, nonatomic) void(^selectScoreBlock)(RYGScoreParam *);

@end
