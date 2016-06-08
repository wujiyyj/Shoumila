//
//  RYGDynamicViewController.h
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"
#import "RYGMenuItemView.h"

@interface RYGDynamicViewController : RYGBaseViewController<UIScrollViewDelegate>

@property (nonatomic, strong)RYGMenuItemView *menuItemView;
@property (nonatomic, strong)UIScrollView *scrollView;

@end
