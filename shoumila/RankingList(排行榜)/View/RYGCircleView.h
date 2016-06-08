//
//  RYGCircleView.h
//  最近的圆
//
//  Created by jiaocx on 15/8/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCircleCornerRadius 7

@interface RYGCircleView : UIView

@property(nonatomic,strong)UIColor *fillColor;

- (id)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor;

@end
