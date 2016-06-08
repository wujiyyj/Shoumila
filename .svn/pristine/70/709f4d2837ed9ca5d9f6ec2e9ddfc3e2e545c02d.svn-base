//
//  RYGDynamicDetailHeaderView.m
//  shoumila
//
//  Created by 贾磊 on 15/9/9.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicDetailHeaderView.h"
#import "RYGArticleDetailView.h"

@implementation RYGDynamicDetailHeaderView

-(instancetype)initWithcat:(NSString*)cat{
    _cat = cat;
    self.backgroundColor = [UIColor whiteColor];
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        if ([cat isEqualToString:@"1"]) {
            [self setUpContentView];
        }else if([cat isEqualToString:@"5"]){
            [self setUpRecommendView1];
        }else if([cat isEqualToString:@"6"]){
            [self setUpCat6View];
            return self;
        }
        else{
            [self setUpRecommendView];
        }
        
        [self setUpBarView];
    }
    return self;
}

-(void)setUpContentView{
    RYGDynamicContentView *contentView = [[RYGDynamicContentView alloc]init];
    
    [self addSubview:contentView];
    self.dynamicContentView = contentView;
}
-(void)setUpRecommendView1{
    RYGRecommendContentView1 *recommendContentView = [[RYGRecommendContentView1 alloc]init];
    _recommendContentView1 = recommendContentView;
    [self addSubview:recommendContentView];
}
-(void)setUpRecommendView{
    RYGRecommendContentView *recommendContentView = [[RYGRecommendContentView alloc]init];
    _recommendContentView = recommendContentView;
    [self addSubview:recommendContentView];
}

-(void)setUpCat6View{
    _articleView = [[RYGArticleDetailView alloc]init];
    [self addSubview:_articleView];
}
-(void)setUpBarView{
    RYGBarView *barView = [[RYGBarView alloc]init];
    [self addSubview:barView];
    self.barView = barView;
}
-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    _dynamicContentView.isDeatil = YES;
    _dynamicContentView.dynamicFrame = dynamicFrame;
    _recommendContentView.dynamicFrame = dynamicFrame;
    _recommendContentView1.dynamicFrame = dynamicFrame;
    _articleView.dynamicModel = dynamicFrame;
    _barView.dynamicFrame = dynamicFrame;
    
    if ([_cat isEqualToString:@"1"]) {
        self.height = _dynamicContentView.height;
        self.frame = _dynamicContentView.frame;
    }else if([_cat isEqualToString:@"5"]){
        self.height = _recommendContentView1.height;
        self.frame = _recommendContentView1.frame;
    }else if([_cat isEqualToString:@"6"]){
        self.frame = _articleView.frame;
        self.height = _articleView.height;
        self.title = @"文章详情";
    }else{
        self.height = _recommendContentView.height;
        self.frame = _recommendContentView.frame;
    }
}
@end
