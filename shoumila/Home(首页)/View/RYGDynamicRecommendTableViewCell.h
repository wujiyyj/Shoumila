//
//  RYGDynamicRecommendTableViewCell.h
//  shoumila
//
//  Created by 贾磊 on 15/9/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGDynamicFrame.h"
#import "RYGDynamicCommnetView.h"
#import "RYGRecommendContentView.h"
#import "RYGBarView.h"

@interface RYGDynamicRecommendTableViewCell : UITableViewCell
@property(nonatomic,strong) RYGDynamicFrame *dynamicFrame;
@property(nonatomic,strong) RYGRecommendContentView *recommendContentView;
@property(nonatomic,strong) RYGDynamicCommnetView *commentView;
@property(nonatomic,strong) RYGBarView *barView;

@end
