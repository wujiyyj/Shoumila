//
//  RYGDynamicShareHandler.m
//  shoumila
//
//  Created by 贾磊 on 15/10/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicShareHandler.h"
#import "RYGDynamicShareView.h"

@interface RYGDynamicShareHandler ()
@property(nonatomic,strong)RYGDynamicShareView *shareView;
@property(nonatomic,strong)UIButton   *bgView;
@end

@implementation RYGDynamicShareHandler

-(instancetype)init{
    self = [super init];
    if (self) {
       
    }
    return self;
}

+ (void)shareViewModel:(RYGShareContentModel *)contentModel{
    RYGDynamicShareHandler *handler = [[RYGDynamicShareHandler alloc]init];
    handler.contentModel = contentModel;
    [handler showShareView];
}

-(void)showShareView{
    _shareView = [[RYGDynamicShareView alloc]initWithModel:_contentModel];
    __weak RYGDynamicShareHandler *weakSelf = self;
    __strong RYGDynamicShareHandler *sself = weakSelf;
    _shareView.cancelBlock = ^{
        [sself removeContentShareView];
    };
    _bgView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.alpha = 0;
    _bgView.backgroundColor = [UIColor blackColor];
    [_bgView addTarget:self action:@selector(removeContentShareView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.3;
        _shareView.top = SCREEN_HEIGHT - _shareView.height;
    }];
}

- (void)removeContentShareView{
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        if (_shareView) {
            [_shareView removeFromSuperview];
        }
        if (_bgView) {
            [_bgView removeFromSuperview];
        }
    }];
}

@end
