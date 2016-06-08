//
//  RYGDynamicCat6TableViewCell.h
//  shoumila
//
//  Created by 贾磊 on 16/4/6.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGBarView.h"
#import "RYGDynamicCommnetView.h"
#import "RYGRecommendContentView1.h"
@class RYGDynamicFrame;
@interface RYGDynamicCat6TableViewCell : UITableViewCell
@property(nonatomic,strong) RYGDynamicFrame *dynamicFrame;
@property(nonatomic,strong) RYGDynamicCommnetView *commentView;
@property(nonatomic,strong) RYGRecommendContentView1 *recommendView;
@property(nonatomic,strong) RYGBarView *barView;
+ (CGFloat)heightWithModel:(RYGDynamicFrame *)dynamicFrame;
@end
