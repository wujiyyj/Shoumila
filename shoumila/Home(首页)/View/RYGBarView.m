//
//  RYGBarView.m
//  shoumila
//
//  Created by 贾磊 on 15/9/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBarView.h"
#import "RYGHttpRequest.h"
#import "RYGPraiseParam.h"
#import "RYGDateUtility.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGDynamicShareHandler.h"
#import "RYGShareContentModel.h"


@implementation RYGBarView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _praiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 20)];
        [self addSubview:_praiseBtn];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_sel"] forState:UIControlStateSelected];
        _praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 8, 0, 0);
        [_praiseBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_praiseBtn addTarget:self action:@selector(praiseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_praiseBtn.frame)+20, 0, 45, 20)];
        [self addSubview:_shareBtn];
        [_shareBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 8, 0, 0);
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shareBtn.frame)+20, 0, 45, 20)];
        [self addSubview:_msgBtn];
        [_msgBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        _msgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_msgBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        _msgBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 8, 0, 0);
        _msgBtn.userInteractionEnabled = NO;
    }
    
    return self;
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    self.frame = dynamicFrame.barViewF;
    if ([model.self_is_praised intValue]) {
        _praiseBtn.selected = YES;
       
    }else{
        _praiseBtn.selected = NO;
    }
     [_praiseBtn setTitle:model.praise_num forState:UIControlStateNormal];

//    if ([model.share_num intValue]) {
        [_shareBtn setTitle:model.share_num forState:UIControlStateNormal];
//    }else{
//        [_shareBtn setTitle:@"0" forState:UIControlStateNormal];
//    }
    
    [_msgBtn setTitle:model.comment_num forState:UIControlStateNormal];
    
}

- (void)praiseBtnAction{
    RYGPraiseParam *param = [RYGPraiseParam param];
    RYGDynamicModel *model = _dynamicFrame.dynamicModel;
    param.feed_id = _dynamicFrame.dynamicModel.id;
    param.cancel = @"0";
    if ([model.self_is_praised boolValue]) {
        return;
    }
    [RYGHttpRequest getWithURL:Feed_praise params:[param keyValues] success:^(id json) {
        _praiseBtn.selected = YES;
        int praiseNum = [model.praise_num intValue] +1;
        NSString *numStr = [NSString stringWithFormat:@"%d",praiseNum];
        [_praiseBtn setTitle:numStr forState:UIControlStateSelected];
    } failure:^(NSError *error) {
        
    }];
}

- (void)shareBtnAction{
    RYGShareContentModel *model = [[RYGShareContentModel alloc]init];
    RYGDynamicModel *dynamicModel = _dynamicFrame.dynamicModel;
    model.shareUrl = dynamicModel.share_url;
    model.mediaType = SSPublishContentMediaTypeNews;
    model.content = dynamicModel.content;
    model.feed_id = dynamicModel.id;
//    [[RYGDynamicShareHandler new] shareViewModel:model];
    RYGDynamicShareHandler *handler = [[RYGDynamicShareHandler alloc]init];
    handler.contentModel = model;
    [handler showShareView];
}

@end
