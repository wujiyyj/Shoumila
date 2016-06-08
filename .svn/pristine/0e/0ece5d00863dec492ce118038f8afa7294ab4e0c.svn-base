//
//
//  UMFeedbackViewController.h
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGBaseViewController.h"

@protocol ChatViewDelegate <NSObject>

@optional
- (void)reloadData;
- (void)sendButtonPressed:(NSDictionary *)info;
- (void)updateUserInfo:(NSDictionary *)info;
@end

@interface UMFeedbackViewController : RYGBaseViewController
/**
 *  TODO: more description
 */
@property (nonatomic, strong) NSMutableArray *topicAndReplies;

- (void)refreshData;
- (void)setBackButton:(UIButton *)button;
- (void)setTitleColor:(UIColor *)color;
@end
