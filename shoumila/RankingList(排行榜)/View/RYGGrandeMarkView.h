//
//  RYGGrandeMarkView.h
//  等级标志
//
//  Created by jiaocx on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYGGrandeMarkView : UIView

// 积分等级
@property(nonatomic,copy)NSString *integralRank;
@property(nonatomic,strong,readonly)NSArray *rankImages;
@property(nonatomic,strong) UILabel *level;
- (CGFloat)getGrandWidth:(NSString *)integralRank;

@end
