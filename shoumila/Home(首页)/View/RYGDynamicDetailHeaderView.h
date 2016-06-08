//
//  RYGDynamicDetailHeaderView.h
//  shoumila
//
//  Created by 贾磊 on 15/9/9.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGDynamicContentView.h"
#import "RYGDynamicCommnetView.h"
#import "RYGDynamicFrame.h"
#import "RYGBarView.h"
#import "RYGRecommendContentView1.h"
#import "RYGRecommendContentView.h"

@class RYGArticleDetailView;
@interface RYGDynamicDetailHeaderView : UIView

@property(nonatomic,strong) RYGDynamicFrame *dynamicFrame;
@property(nonatomic,strong) RYGDynamicContentView *dynamicContentView;
@property(nonatomic,strong) RYGRecommendContentView1 *recommendContentView1;
@property(nonatomic,strong) RYGRecommendContentView *recommendContentView;
@property(nonatomic,strong) RYGArticleDetailView *articleView;
@property(nonatomic,strong) RYGBarView  *barView;
@property(nonatomic,strong) NSString *cat;
@property(nonatomic,strong) NSString *title;

-(instancetype)initWithcat:(NSString*)cat;
@end
