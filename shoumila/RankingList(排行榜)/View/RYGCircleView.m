//
//  RYGCircleView.m
//  最近的圆
//
//  Created by jiaocx on 15/8/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGCircleView.h"

@implementation RYGCircleView
{
    CAShapeLayer *arcLayer;
}

- (id)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor {
    self = [super initWithFrame:frame];
    if (self) {
        _fillColor = fillColor;
        [self setupCircle];
    }
    
    return self;
}

- (void)setupCircle {
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(kCircleCornerRadius / 2,kCircleCornerRadius / 2) radius:kCircleCornerRadius / 2 startAngle:0 endAngle:2*M_PI clockwise:NO];
    arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=self.fillColor.CGColor;
    [self.layer addSublayer:arcLayer];
}

@end
