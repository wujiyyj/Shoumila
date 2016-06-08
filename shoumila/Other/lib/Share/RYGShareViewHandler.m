//
//  RYGShareViewHandler.m
//  shoumila
//
//  Created by 阴～ on 15/9/15.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGShareViewHandler.h"
#import "RYGShareView.h"

static UIView *bgView;
static RYGShareView *shareView;
static RYGShareViewHandler *instance;

@implementation RYGShareViewHandler

+(instancetype)shareInstance{
    
    if (!instance) {
        instance = [[RYGShareViewHandler alloc]init];
    }
    [self setUpShareView];
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _removeViewBlock = ^{
            [RYGShareViewHandler removeShareView];
        };
    }
    return self;
}

+(void)setUpShareView{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    UITapGestureRecognizer* removeView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShareView)];
    [bgView addGestureRecognizer:removeView];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    shareView = [[RYGShareView alloc]initWithHandler:instance];
    shareView.backgroundColor = ColorShareView;
    [UIView animateWithDuration:0.3 animations:^{
        shareView.top = SCREEN_HEIGHT - 243;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}

+ (void)removeShareView{
    [UIView animateWithDuration:0.3 animations:^{
        bgView.alpha = 0;
        shareView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [shareView removeFromSuperview];
    }];
}

@end
