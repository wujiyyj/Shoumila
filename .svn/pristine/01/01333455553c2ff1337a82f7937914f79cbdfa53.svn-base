//
//  RYGOperationView.m
//  shoumila
//
//  Created by 贾磊 on 16/4/9.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import "RYGOperationView.h"
#import "RYGFavoriteParam.h"
#import "RYGHttpRequest.h"
#import "MBProgressHUD+MJ.h"
#import "RYGAttentionParam.h"
#import "RYGReportViewController.h"
#import "RYGNavigationController.h"
#import "RYGFeedIdParam.h"


@implementation RYGOperationView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        _tancengView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 70)];
        _tancengView.backgroundColor = ColorLine;
        _shoucangBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _shoucangBtn.backgroundColor = ColorShareView;
        
        _delBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _delBtn.backgroundColor = ColorShareView;
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_delBtn];
        
        _lockBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _lockBtn.backgroundColor = ColorShareView;
        [_lockBtn setTitle:@"锁定" forState:UIControlStateNormal];
        [_lockBtn setTitle:@"已锁定" forState:UIControlStateSelected];
        [_lockBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_lockBtn addTarget:self action:@selector(lockAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_lockBtn];
        
        _hideBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _hideBtn.backgroundColor = ColorShareView;
        [_hideBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        [_hideBtn setTitle:@"已隐藏" forState:UIControlStateSelected];
        [_hideBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_hideBtn addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_hideBtn];
        
        _closureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _closureBtn.backgroundColor = ColorShareView;
        [_closureBtn setTitle:@"禁言" forState:UIControlStateNormal];
        [_closureBtn setTitle:@"已禁言" forState:UIControlStateSelected];
        [_closureBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_closureBtn addTarget:self action:@selector(closureAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_closureBtn];
        
        [_shoucangBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_shoucangBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
        [_shoucangBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_shoucangBtn addTarget:self action:@selector(shouchang) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_shoucangBtn];
        
        _laheiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _laheiBtn.backgroundColor = ColorShareView;
        [_laheiBtn setTitle:@"拉黑" forState:UIControlStateNormal];
        [_laheiBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_laheiBtn addTarget:self action:@selector(lahei) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_laheiBtn];
        
        _reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _reportBtn.backgroundColor = ColorShareView;
        [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
        [_reportBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_reportBtn addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_reportBtn];
        
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _cancelBtn.backgroundColor = ColorShareView;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_tancengView addSubview:_cancelBtn];
        
        //设置更多操作frame
        RYGUserInfoModel *userModel = [RYGUtility getUserInfo];
        
        float top = 1.0f;
        if ([userModel.is_admin isEqualToString:@"1"]) {
            _delBtn.top = top;
            top = top + 45;
            _lockBtn.top = top;
            top = top + 45;
            _hideBtn.top = top;
            top = top + 45;
            _closureBtn.top = top;
            top = top + 45;
        }
        _shoucangBtn.top = top;
        top = top + 45;
        _laheiBtn.top = top;
        top = top + 45;
        _reportBtn.top = top;
        top = top + 48;
        _cancelBtn.top = top;
        top = top + 45;
        _tancengView.height = top;
        
        if ([self.dynamicFrame.dynamicModel.is_favorite boolValue]) {
            _shoucangBtn.selected = YES;
        }
        if ([self.dynamicFrame.dynamicModel.is_lock boolValue]) {
            _lockBtn.selected = YES;
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelAction];
}
//更多操作
- (void)arrowAction:(id)test{
    if (![RYGUtility validateUserLogin]) {
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kRemoveView object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:UIKeyboardWillHideNotification object:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:_tancengView];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.3;
        _tancengView.top = SCREEN_HEIGHT - _tancengView.height;
    }];
    
}

- (void)shouchang{
    RYGFavoriteParam *param = [RYGFavoriteParam param];
    param.id = _dynamicFrame.dynamicModel.id;
    param.op = _dynamicFrame.dynamicModel.is_favorite;
    [RYGHttpRequest getWithURL:Feed_add_favorite params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"收藏成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"收藏失败"];
        
    }];
    [self cancelAction];
}


- (void)lahei{
    RYGAttentionParam *attentionParam = [RYGAttentionParam param];
    attentionParam.userid = _dynamicFrame.dynamicModel.publish_user.userid;
    attentionParam.op = @"0";
    [RYGHttpRequest postWithURL:User_AddBlack params:attentionParam.keyValues success:^(id json) {
        NSNumber *code = [json valueForKey:@"code"];
        if (code && code.integerValue == 0) {
            [MBProgressHUD showSuccess:@"添加黑名单成功"];
        }
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}
- (void)report{
    
    RYGReportViewController *reportVC = [[RYGReportViewController alloc]init];
    RYGNavigationController *nav = [[RYGNavigationController alloc]initWithRootViewController:reportVC];
    reportVC.feed_id = _dynamicFrame.dynamicModel.id;
    reportVC.user_id = _dynamicFrame.dynamicModel.publish_user.userid;
    [[RYGUtility getCurrentVC] presentViewController:nav animated:YES completion:^{
        
    }];
    [self cancelAction];
}

- (void)lockAction{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    [RYGHttpRequest getWithURL:Feed_lock params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"锁定成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}
- (void)hideAction{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    param.op = [self.dynamicFrame.dynamicModel.is_hide boolValue]?@"1":@"0";
    [RYGHttpRequest getWithURL:Feed_hide params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"隐藏成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}

- (void)closureAction{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    param.op = [self.dynamicFrame.dynamicModel.is_closure boolValue]?@"1":@"0";
    [RYGHttpRequest getWithURL:Feed_closure params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"禁言成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}

-(void)del{
    RYGFeedIdParam *param = [RYGFeedIdParam param];
    param.feed_id = _dynamicFrame.dynamicModel.id;
    [RYGHttpRequest getWithURL:Feed_delelte params:[param keyValues] success:^(id json) {
        [MBProgressHUD showSuccess:@"删除成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kReloadHomeNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
    [self cancelAction];
}
- (void)cancelAction{
    [UIView animateWithDuration:0.3 animations:^{
        _tancengView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
//        if (_bgView) {
            [self removeFromSuperview];
//        }
        if (_tancengView) {
            [_tancengView removeFromSuperview];
        }
    }];
}
@end
