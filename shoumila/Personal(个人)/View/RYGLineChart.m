//
//  RYGLineChart.m
//  shoumila
//
//  Created by Xmj on 15/9/8.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGLineChart.h"
#import <QuartzCore/QuartzCore.h>

@interface RYGLineChart ()

@property (nonatomic, strong) NSMutableArray* data;

@property (nonatomic) CGFloat min;
@property (nonatomic) CGFloat max;
@property (nonatomic) CGMutablePathRef initialPath;
@property (nonatomic) CGMutablePathRef newPath;

@end

@implementation RYGLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setDefaultParameters];
    }
    return self;
}

- (void)setChartData:(NSArray *)chartData
{
    _data = [NSMutableArray arrayWithArray:chartData];
    
    _min = MAXFLOAT;
    _max = -MAXFLOAT;
    
    for(int i=0;i<_data.count;i++) {
        NSNumber* number = _data[i];
        if([number floatValue] < _min)
            _min = [number floatValue];
        
        if([number floatValue] > _max)
            _max = [number floatValue];
    }
    
//    _max = [self getUpperRoundNumber:_max forGridStep:_gridStep];
    _max = _maxLine.floatValue;
    
    // No data
    if(isnan(_max)) {
        _max = 1;
    }
    
    [self strokeChart];
    
    if(_labelForValue) {
        
        int countNum = 1;
        int countEveNum = 0;
        
        for(int i=1;i<=_gridStep;i++) {
            CGPoint p = CGPointMake(_margin + _axisWidth, _axisHeight/2 + _margin - (i + 1) * _axisHeight/ 2 / _gridStep);
            CGPoint p1 = CGPointMake(_margin + _axisWidth, _axisHeight/2 + _margin + (i + 1) * _axisHeight/ 2 / _gridStep);
            
            NSString* text = _labelForValue(_max / _gridStep * (i + 1));
            CGRect rect = CGRectMake(_margin, p.y + 2, self.frame.size.width - _margin * 2 - 4.0f, 14);
            
            float width =
            [text
             boundingRectWithSize:rect.size
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12.0f] }
             context:nil]
            .size.width;
            
            int eveCount = _maxLine.intValue/100+1;
            int eveNum = _gridStep/eveCount;
            
            int totalCount = _maxLine.intValue/300+1;
            
//            NSLog(@"_maxLine - %@",_maxLine);
            
            if (_maxLine.intValue <= 300*totalCount) {
                eveNum = _gridStep*totalCount/eveCount;
            }

            
            if (countNum == eveNum) {
                
                if (countEveNum == 0) {
                    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(- width, _axisHeight/2 + _margin - 7, width + 5, 14)];
                    label.text = @"0";
                    label.font = [UIFont systemFontOfSize:12.0f];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    
                    [self addSubview:label];
                }
                
                countEveNum++;
                
                //正坐标轴
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(- width-20, p.y - 5, width + 20, 14)];
                
                if (_maxLine.intValue <= 300*totalCount) {
                    label.text = [NSString stringWithFormat:@"%d",100*countEveNum*totalCount];
                }
                
                label.font = [UIFont systemFontOfSize:12.0f];
                label.textColor = [UIColor grayColor];
                label.textAlignment = NSTextAlignmentRight;
                label.backgroundColor = [UIColor clearColor];
                
                [self addSubview:label];
                
                //负坐标轴
                UILabel* un_label = [[UILabel alloc] initWithFrame:CGRectMake(- width-25, p1.y - 10, width + 25, 14)];
                
                if (_maxLine.intValue <= 300*totalCount) {
                    un_label.text = [NSString stringWithFormat:@"-%d",100*countEveNum*totalCount];
                }

                un_label.font = [UIFont systemFontOfSize:12.0f];
                un_label.textColor = [UIColor grayColor];
                un_label.textAlignment = NSTextAlignmentRight;
                un_label.backgroundColor = [UIColor clearColor];
                
                [self addSubview:un_label];
                
                countNum = 1;
            }
            else {
                countNum++;
            }
            
        }
    }
    
    //dataType = 0  30天     ｜｜  dataType = 1  90天
//    NSMutableArray* dataArray;
//    if (_dataType == 0) {
//        _dataArray = [NSMutableArray arrayWithObjects:@"6-05",@"6-10",@"6-15",@"6-20",@"6-25",@"6-30", nil];
//    }
//    else if (_dataType == 1) {
//        _dataArray = [NSMutableArray arrayWithObjects:@"6-15",@"6-30",@"7-15",@"7-30",@"8-15",@"8-30", nil];
//    }
    
    
    int judgeNum = 0;
    if (_dataType == 0) {
        judgeNum = 5;
    }
    else if (_dataType == 1) {
        judgeNum = 15;
    }
    if(_labelForIndex) {
        float scale = 1.0f;
        int q = (int)_data.count / _gridStep;
        
        int countNum = 1;
        scale = (CGFloat)(q * _gridStep) / (CGFloat)(_data.count - 1);
        
        for(int i=1;i<_gridStep + 1;i++) {
            NSInteger itemIndex = q * i;
            if(itemIndex >= _data.count)
            {
                itemIndex = _data.count - 1;
            }
            
            NSString* text = _labelForIndex(itemIndex);
            CGPoint p = CGPointMake(_margin + i * (_axisWidth / _gridStep) * scale, _axisHeight/2 + _margin);
            
            if (countNum == judgeNum) {
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - 38.0f, p.y + 2, self.frame.size.width, 14)];
                if (_dataArray.count) {
                    NSString* dataStr = _dataArray[text.intValue-1];
                    NSString* str = [dataStr substringFromIndex:4];
                    NSString* str1 = [str substringToIndex:2];
                    NSString* str2 = [str substringFromIndex:2];
                    label.text = [NSString stringWithFormat:@"%@-%@",str1,str2];
                }
                label.font = [UIFont boldSystemFontOfSize:10.0f];
                label.textColor = [UIColor darkGrayColor];
                [self addSubview:label];
                countNum = 1;
            }
            else {
                countNum++;
            }
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawGrid];
}

- (void)drawGrid
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
    
    // draw coordinate axis
    CGContextMoveToPoint(ctx, _margin, _margin);
    CGContextAddLineToPoint(ctx, _margin, _axisHeight + _margin + 3 + 30);
    CGContextStrokePath(ctx);
    
    
    CGContextMoveToPoint(ctx, _margin, _axisHeight/2 + _margin);
    CGContextAddLineToPoint(ctx, _axisWidth + _margin, _axisHeight/2 + _margin);
    CGContextStrokePath(ctx);
    
    float scale = 1.0f;
    int q = (int)_data.count / _gridStep;
    scale = (CGFloat)(q * _gridStep) / (CGFloat)(_data.count - 1);
    
    // draw grid
//    for(int i=0;i<_gridStep;i++) {
//        CGContextSetLineWidth(ctx, 0.5);
//        
//        CGPoint point = CGPointMake((1 + i) * _axisWidth / _gridStep * scale + _margin, _margin);
//        
//        CGContextMoveToPoint(ctx, point.x, point.y);
//        CGContextAddLineToPoint(ctx, point.x, _axisHeight + _margin);
//        CGContextStrokePath(ctx);
//        
//        
//        CGContextSetLineWidth(ctx, 2);
//        CGContextMoveToPoint(ctx, point.x - 0.5f, _axisHeight + _margin);
//        CGContextAddLineToPoint(ctx, point.x - 0.5f, _axisHeight + _margin + 3);
//        CGContextStrokePath(ctx);
//    }
//    
//    for(int i=0;i<_gridStep;i++) {
//        CGContextSetLineWidth(ctx, 0.5);
//        
//        CGPoint point = CGPointMake(_margin, (i) * _axisHeight / _gridStep + _margin);
//        
//        CGContextMoveToPoint(ctx, point.x, point.y);
//        CGContextAddLineToPoint(ctx, _axisWidth + _margin, point.y);
//        CGContextStrokePath(ctx);
//    }
    
}

- (void)strokeChart
{
    if([_data count] == 0) {
        NSLog(@"Warning: no data provided for the chart");
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *noPath = [UIBezierPath bezierPath];
//    UIBezierPath* fill = [UIBezierPath bezierPath];
//    UIBezierPath* noFill = [UIBezierPath bezierPath];
    _max = _max==0?1:_max;
    CGFloat scale = _axisHeight / 2 / _max;
    NSNumber* first = _data[0];
    
//    for(int i=1;i<_data.count;i++) {
//        NSNumber* last = _data[i - 1];
//        NSNumber* number = _data[i];
//        
//        CGPoint p1 = CGPointMake(_margin + (i - 1) * (_axisWidth / (_data.count - 1)), _axisHeight/2 + _margin - [last floatValue] * scale);
//        
//        CGPoint p2 = CGPointMake(_margin + i * (_axisWidth / (_data.count - 1)), _axisHeight/2 + _margin - [number floatValue] * scale);
//        
//        fill.lineCapStyle = kCGLineJoinRound;
//        [fill moveToPoint:p1];
//        [fill addLineToPoint:p2];
//        [fill addLineToPoint:CGPointMake(p2.x, _axisHeight/2 + _margin)];
//        [fill addLineToPoint:CGPointMake(p1.x, _axisHeight/2 + _margin)];
//        
//        noFill.lineCapStyle = kCGLineJoinRound;
//        [noFill moveToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
//        [noFill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
//        [noFill addLineToPoint:CGPointMake(p2.x, _axisHeight + _margin)];
//        [noFill addLineToPoint:CGPointMake(p1.x, _axisHeight + _margin)];
//    }
    
    
    path.lineCapStyle = kCGLineJoinRound;
    noPath.lineCapStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(_margin, _axisHeight/2 + _margin - [first floatValue] * scale)];
//    [noPath moveToPoint:CGPointMake(_margin, _axisHeight + _margin)];
    
    for(int i=1;i<_data.count;i++) {
        NSNumber* number = _data[i];
        
        NSNumber* last = _data[i - 1];
        CGPoint p1 = CGPointMake(_margin + (i - 1) * (_axisWidth / (_data.count - 1)), _axisHeight/2 + _margin - [last floatValue] * scale);
        CGPoint p2 = CGPointMake(_margin + i * (_axisWidth / (_data.count - 1)), _axisHeight/2 + _margin - [number floatValue] * scale);
        
        CGPoint midPoint = midPointForPoints(p1, p2);
        [path addQuadCurveToPoint:midPoint controlPoint:controlPointForPoints(midPoint, p1)];
        [path addQuadCurveToPoint:p2 controlPoint:controlPointForPoints(midPoint, p2)];
        
//        [path addLineToPoint:CGPointMake(_margin + i * (_axisWidth / (_data.count - 1)), _axisHeight/2 + _margin - [number floatValue] * scale)];
//        [noPath addLineToPoint:CGPointMake(_margin + i * (_axisWidth / (_data.count - 1)), _axisHeight + _margin)];
    }
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.bounds = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor colorWithHexadecimal:@"#e53f2a"] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 2;
    pathLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:pathLayer];
    
    //动画路径
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//    pathAnimation.duration = 0.25;
//    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    pathAnimation.fromValue = (__bridge id)(noPath.CGPath);
//    pathAnimation.toValue = (__bridge id)(path.CGPath);
//    [pathLayer addAnimation:pathAnimation forKey:@"path"];
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
    CGPoint controlPoint = midPointForPoints(p1, p2);
    CGFloat diffY = fabs(p2.y - controlPoint.y);
    
    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    
    return controlPoint;
}

- (void)setDefaultParameters
{
    _color = [UIColor colorWithHexadecimal:@"#c91800"];
    _gridStep = 6;
    _margin = 5.0f;
    _axisWidth = self.frame.size.width - 10;
    _axisHeight = self.frame.size.height;
    _axisColor = [UIColor colorWithWhite:0.7 alpha:1.0];
}

- (CGFloat)getUpperRoundNumber:(CGFloat)value forGridStep:(int)gridStep
{
    // We consider a round number the following by 0.5 step instead of true round number (with step of 1)
    CGFloat logValue = log10f(value);
    CGFloat scale = powf(10, floorf(logValue));
    CGFloat n = ceilf(value / scale * 2);
    
    int tmp = (int)(n) % gridStep;
    
    if(tmp != 0) {
        n += gridStep - tmp;
    }
    
    return n * scale / 2.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
