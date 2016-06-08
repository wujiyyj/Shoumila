//
//  RYGDynamicTableViewCell.h
//  shoumila
//
//  Created by 贾磊 on 15/9/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGDynamicContentView.h"
#import "RYGDynamicCommnetView.h"
#import "RYGDynamicFrame.h"
#import "RYGBarView.h"

@interface RYGDynamicTableViewCell : UITableViewCell

@property(nonatomic,strong) RYGDynamicFrame *dynamicFrame;
@property(nonatomic,strong) RYGDynamicContentView *dynamicContentView;
@property(nonatomic,strong) RYGDynamicCommnetView *commentView;
@property(nonatomic,strong) RYGBarView  *barView;

@end
