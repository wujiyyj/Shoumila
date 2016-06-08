//
//  RYGOperationView.h
//  shoumila
//
//  Created by 贾磊 on 16/4/9.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGDynamicFrame.h"

@interface RYGOperationView : UIView
//@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIButton *delBtn;
@property(nonatomic,strong) UIButton *lockBtn;
@property(nonatomic,strong) UIButton *hideBtn;
@property(nonatomic,strong) UIButton *closureBtn;
@property(nonatomic,strong) UIButton *shoucangBtn;
@property(nonatomic,strong) UIButton *laheiBtn;
@property(nonatomic,strong) UIButton *reportBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *arrow;
@property(nonatomic,strong) UIButton *arrowBg;
@property(nonatomic,strong) UIView   *tancengView;
@property(nonatomic,strong) RYGDynamicFrame *dynamicFrame;
- (void)arrowAction:(id) test;
@end
