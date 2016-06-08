//
//  RYGPieChartView.m
//  shoumila
//
//  Created by jiaocx on 15/8/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPieChartView.h"
#import "RYGMonthRecntModel.h"

#define Pie_Y_Height 22
#define Pie_X_Magin 20

@interface RYGPieChartView ()

// Y轴显示最大值
@property(nonatomic,assign) NSInteger maxValue;
// Y轴显示最小值
@property(nonatomic,assign) NSInteger minValue;

@property(nonatomic,assign) NSInteger xTitleStartY;

@property(nonatomic,assign) BOOL isOneYvertical;

@end

@implementation RYGPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initProperty {
    // 曲线颜色
    self.pieLineColor = ColorWin;
    // 经线颜色
    self.longitudeColor = ColorLine;
    // 纬线颜色
    self.latitudeColor = ColorLine;
    
    // 经线字体颜色
    self.longitudeFontColor = ColorName;
    // 纬线字体颜色
    self.latitudeFontColor = ColorName;
    
    // 经线字体
    self.longitudeFont = [UIFont systemFontOfSize:6];
    // 纬线字体
    self.latitudeFont = [UIFont systemFontOfSize:6];
    
    // 经线Title显示数目
    self.longitudeNum = 4;
    // 纬线Title显示数目
    self.latitudeNum = 2;

    // 显示起源
     self.displayFrom = 0;
    
    // k线的宽度 用来计算可存放K线实体的个数，也可以由此计算出起始日期和结束日期的时间段
   self.kLineWidth = 1;
    self.xyLineWidth = 0.5;
}

// 根据数据计算
- (void)setLinesData:(NSArray *)linesData {
    _linesData = linesData;
    [self initAxisX];
    [self initAxisY];
    [self setNeedsDisplay];
}

// 初期化经线的title数据
- (void)initAxisX {
    if (self.linesData == nil) {
        return;
    }
    
    if ([self.linesData count] == 0) {
        return;
    }
    NSMutableArray *TitleX = [[NSMutableArray alloc] init];
    //以第1条线作为X轴的标示

    if (self.linesData== nil) {
        return;
    }
    if ([self.linesData count] == 0) {
        return;
    }
    CGFloat average = [self.linesData count] / self.longitudeNum;
    //处理刻度
    for (NSInteger i = 0; i < self.longitudeNum; i++) {
        NSInteger index = self.displayFrom + (NSInteger) floor(i * average);
        if (index > self.displayFrom + [self.linesData count] - 1) {
            index = self.displayFrom + [self.linesData count] - 1;
        }
        RYGMonthRecntModel *lineData = [self.linesData objectAtIndex:index];
        if (i == 0) {
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", [self swtichDate:lineData.date isShowMonth:YES]]];
        }
        else {
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", [self swtichDate:lineData.date isShowMonth:NO]]];
        }
    }
    RYGMonthRecntModel *lineData = [self.linesData objectAtIndex:self.displayFrom + [self.linesData count] - 1];
    //追加标题
    [TitleX addObject:[NSString stringWithFormat:@"%@", [self swtichDate:lineData.date isShowMonth:NO]]];
    
    self.longitudeTitles = TitleX;
}

- (NSString *)swtichDate:(NSString *)ymd isShowMonth:(BOOL)isShowMonth{
    NSString *showDate;
    // 是否显示月份
    if (isShowMonth) {
      NSString  *temp = [ymd substringFromIndex:4];
      showDate = [NSString stringWithFormat:@"%ld月%ld日",[[temp substringToIndex:2] integerValue],[[temp substringFromIndex:2] integerValue]];
    }
    else {
        NSString  *temp = [ymd substringFromIndex:6];
        showDate = [NSString stringWithFormat:@"%ld日",[temp integerValue]];
    }
    return showDate;
}

// 初期化纬线的title的数据
- (void)initAxisY {
    //计算值幅范围
    [self calcValueRange];
    
    if (self.maxValue == 0 && self.minValue == 0) {
        self.isOneYvertical = YES;
    }
    
    NSMutableArray *TitleY = [[NSMutableArray alloc] init];
    [TitleY addObject:[NSString stringWithFormat:@"%ld",self.minValue]];
    [TitleY addObject:[NSString stringWithFormat:@"%ld",self.maxValue]];
    
    self.latitudeTitles = TitleY;
}

// 计算纬线的最大最小值
- (void)calcValueRange {
    self.minValue = 999999999;
    self.maxValue = -99999999;
    for (int i = 0; i < self.linesData.count; i++) {
        RYGMonthRecntModel *lineData = [self.linesData objectAtIndex:i];
        NSInteger profit = [lineData.profit integerValue];
        if (profit > self.maxValue) {
            self.maxValue = profit;
        }
        if (profit < self.minValue) {
            self.minValue = profit;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    
    //绘制XY轴
    [self drawXAxis:rect];
    [self drawYAxis:rect];
    //绘制X轴标题
    [self drawXAxisTitles:rect];
    //绘制Y轴标题
    [self drawYAxisTitles:rect];
    [self drawLineWithContext:rect];
}

- (void)drawXAxis:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,self.xyLineWidth);

    CGContextMoveToPoint(context, Pie_X_Magin, Pie_Y_Height);
    CGContextAddLineToPoint(context, rect.size.width - self.xyLineWidth, Pie_Y_Height);
    
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextStrokePath(context);
}

- (void)drawYAxis:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.xyLineWidth);

    CGContextMoveToPoint(context, Pie_X_Magin, 0);
    CGContextAddLineToPoint(context, Pie_X_Magin, Pie_Y_Height);

    CGContextSetStrokeColorWithColor(context, self.latitudeColor.CGColor);
    CGContextStrokePath(context);
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
    CGFloat startX = Pie_X_Magin + 2;
    CGFloat lastY = 0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.kLineWidth);
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
            lineLength = 7;
        }
        else {
            lineLength = 3.8;
        }
        RYGMonthRecntModel *lineData = [self.linesData objectAtIndex:j];
        //获取终点Y坐标
        CGFloat valueY = [self calcValueY:[lineData.profit integerValue] inRect:rect];
        if (isnan(valueY)) {
            valueY = 0;
        }
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
    CGFloat rate = 1 - (CGFloat)((CGFloat)(value - self.minValue) / (CGFloat)(self.maxValue - self.minValue));
    
    return  rate * (Pie_Y_Height - 1);
}

- (void)drawXAxisTitles:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
    
    if ([self.longitudeTitles count] <= 0) {
        return;
    }
    
    CGFloat magin = 9;
    CGFloat startX = 11;
    for (NSInteger i = 0; i < [self.longitudeTitles count]; i++) {
        NSString *strDate = (NSString *) [self.longitudeTitles objectAtIndex:i];
        CGSize dateSize = RYG_TEXTSIZE(strDate, self.longitudeFont);
        self.xTitleStartY = rect.size.height - dateSize.height;
        CGRect textRect= CGRectMake(startX , self.xTitleStartY, dateSize.width, dateSize.height);
        UIFont *textFont= self.longitudeFont; //设置字体
        NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];//段落样式
        textStyle.alignment=NSTextAlignmentLeft;
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        //绘制字体
        [strDate drawInRect:textRect withAttributes:@{NSFontAttributeName:textFont,NSParagraphStyleAttributeName:textStyle}];
        if (i == 0) {
            magin = 12;
        }
        else {
            magin = 13;
        }
        startX += dateSize.width + magin;
    }
}

- (void)drawYAxisTitles:(CGRect)rect {
    if ([self.latitudeTitles count] <= 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.latitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.latitudeFontColor.CGColor);
    
//    if (self.isOneYvertical) {
//        NSString *str = (NSString *) [self.latitudeTitles objectAtIndex:0];
//        UIFont *textFont= self.latitudeFont; //设置字体
//        CGSize size = RYG_TEXTSIZE(str, self.latitudeFont);
//        CGRect textRect= CGRectMake(0,(self.height - (Pie_Y_Height - size.height)) / 2, Pie_X_Magin -1, size.height);
//        NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];//段落样式
//        textStyle.alignment=NSTextAlignmentRight;
//        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        //绘制字体
//        [str drawInRect:textRect withAttributes:@{NSFontAttributeName:textFont,NSParagraphStyleAttributeName:textStyle}];
//        return;
//    }
    // 绘制线条
    CGFloat startY = Pie_Y_Height;
    for (NSInteger i = 0; i < [self.latitudeTitles count]; i++) {
        NSString *str = (NSString *) [self.latitudeTitles objectAtIndex:i];
        UIFont *textFont= self.latitudeFont; //设置字体
        CGSize size = RYG_TEXTSIZE(str, self.latitudeFont);
        if (i == 0) {
            startY -= size.height;
        }
        CGRect textRect= CGRectMake(0, startY, Pie_X_Magin -1, size.height);
        NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];//段落样式
        textStyle.alignment=NSTextAlignmentRight;
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        //绘制字体
        [str drawInRect:textRect withAttributes:@{NSFontAttributeName:textFont,NSParagraphStyleAttributeName:textStyle}];
        startY = 1;
    }
}

@end
