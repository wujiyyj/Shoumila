//
//  ViewController.h
//  test
//
//  Created by  on 15/4/23.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGBaseViewController.h"


@class RYGScoreParam;

@protocol QDPublishFeedDelegate <NSObject>

-(void)publishFeedComplite;

@end

@interface RYGPublishViewController : RYGBaseViewController<UITextViewDelegate>

@property(nonatomic,assign) id<QDPublishFeedDelegate> delegate;
@property (nonatomic, strong) RYGScoreParam *scoreParam;
- (void)scoreCallBack;
@end

