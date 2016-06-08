//
//  RYGMyDataTableViewCell.h
//  shoumila
//
//  Created by yinyujie on 15/7/31.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGMenuItemView.h"
#import "RYGScrollPageView.h"
#import "RYGPersonalDatasModel.h"
#import "RYGPersonalUserModel.h"

@interface RYGMyDataTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property(nonatomic,copy) void(^dataBlock)();
@property(nonatomic,copy) void(^timeBlock)();
@property(nonatomic,copy) void(^tapWinLoseBlock)();

@property(nonatomic,copy) void(^tapYpslBlock)(NSInteger tag);
@property(nonatomic,copy) void(^tapDxqslBlock)(NSInteger tag);
@property(nonatomic,copy) void(^tapJcslBlock)(NSInteger tag);
@property(nonatomic,copy) void(^tapPjtjswBlock)(NSInteger tag);
@property(nonatomic,copy) void(^tapZglhBlock)(NSInteger tag);
@property(nonatomic,copy) void(^tapWdxBlock)(NSInteger tag);

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;

@property (nonatomic, strong)RYGPersonalUserModel  *userDataModel;
@property (nonatomic, strong)RYGPersonalDatasModel *weekDataModel;
@property (nonatomic, strong)RYGPersonalDatasModel *monthDataModel;
@property (nonatomic, strong)RYGPersonalDatasModel *ninetyDataModel;

@end
