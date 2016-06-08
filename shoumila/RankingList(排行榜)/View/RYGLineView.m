//
//  RYGLineView.m
//  shoumila
//
//  Created by jiaocx on 15/8/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGLineView.h"
#import "RYGMonthRecntModel.h"

#define Line_Widht 1

@implementation RYGLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSet];
    }
    return self;
}

#pragma mark 初始化参数
-(void)initSet{
    self.backgroundColor = [UIColor clearColor];
    self.startPoint = self.frame.origin;
    self.endPoint = self.frame.origin;
    self.color = @"#000000";
    self.lineWidth = Line_Widht;
}


- (void)drawRect:(CGRect)rect
{
    // 画连接线
    [self drawLineWithContext:rect];
}

#pragma mark 画连接线
- (void)drawLineWithContext:(CGRect)rect {
    
    if (self.linesData == nil) {
        return;
    }
    
    if ([self.linesData count] == 0) {
        return;
    }
    // 起始位置
    CGFloat lineLength;
    CGFloat startX = 0;
    CGFloat lastY = 0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAllowsAntialiasing(context, YES);
    
    if (self.linesData == nil || self.linesData.count == 0) {
        return;
    }

    //设置线条颜色
    CGContextSetStrokeColorWithColor(context, self.pieLineColor.CGColor);
    
    //遍历并绘制线条
    for (NSInteger j = self.displayFrom; j < self.displayFrom + [self.linesData count]; j++) {
        if (j == self.displayFrom) {
            // 点线距离
            lineLength = 9;
        }
        else {
            lineLength = 13;
        }
        RYGMonthRecntModel *lineData = [self.linesData objectAtIndex:j];
        //获取终点Y坐标
        CGFloat valueY = [self calcValueY:[lineData.profit integerValue] inRect:rect];
        //绘制线条路径
        if (j == self.displayFrom) {
            CGContextMoveToPoint(context, startX, valueY);
            lastY = valueY;
        } else {
            CGContextAddLineToPoint(context, startX, valueY);
            lastY = valueY;
        }
        //X位移
        startX = startX + lineLength;
    }
    //绘制路径
    CGContextStrokePath(context);

}

- (CGFloat) calcValueY:(NSInteger)value inRect:(CGRect) rect{
    return  (value - self.minValue) / (self.maxValue - self.minValue) * rect.size.height;
}



@end
