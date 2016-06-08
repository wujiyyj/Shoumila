//
//  RYGRadarChart.m
//  shoumila
//
//  Created by Xmj on 15/9/7.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRadarChart.h"
#import "RYGLegendView.h"

#define PADDING 13
#define LEGEND_PADDING 3
#define ATTRIBUTE_TEXT_SIZE 9
#define COLOR_HUE_STEP 5
#define MAX_NUM_OF_COLOR 17

@interface RYGRadarChart ()

@property (nonatomic, assign) NSUInteger numOfV;
@property (nonatomic, strong) RYGLegendView *legendView;
@property (nonatomic, strong) UIFont *scaleFont;

@end

@implementation RYGRadarChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _maxValue = 100.0;
        _centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        _r = MIN(self.frame.size.width / 2 - PADDING, self.frame.size.height / 2 - PADDING);
        _steps = 1;
        _drawPoints = NO;
        _showLegend = NO;
        _showStepText = NO;
        _fillArea = NO;
        _minValue = 0;
        _colorOpacity = 0.9;
        _backgroundLineColor = ColorLine;
        
        self.legendView = [[RYGLegendView alloc] initWithFrame:CGRectMake(frame.size.width - 60*SCREEN_SCALE, 10, 50*SCREEN_SCALE, 70*SCREEN_SCALE)];
        self.legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.legendView.backgroundColor = [UIColor grayColor];
        self.legendView.colors = [NSMutableArray array];
        //		self.attributes = @[@"you", @"should", @"set", @"these", @"data", @"titles,",
        //		                    @"this", @"is", @"just", @"a", @"placeholder"];
        
        self.scaleFont = [UIFont systemFontOfSize:ATTRIBUTE_TEXT_SIZE];
    }
    return self;
}

- (void)setShowLegend:(BOOL)showLegend {
    _showLegend = showLegend;
    if (_showLegend) {
        [self addSubview:self.legendView];
    }
    else {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[RYGLegendView class]]) {
                [subView removeFromSuperview];
            }
        }
    }
}

- (void)setTitles:(NSArray *)titles {
    self.legendView.titles = titles;
}

- (void)setColors:(NSArray *)colors {
    [self.legendView.colors removeAllObjects];
    for (UIColor *color in colors) {
        [self.legendView.colors addObject:[color colorWithAlphaComponent:self.colorOpacity]];
    }
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [self.legendView sizeToFit];
    [self.legendView setNeedsDisplay];
}

- (void)setDataSeries:(NSArray *)dataSeries {
    _dataSeries = dataSeries;
    _numOfV = [_dataSeries[0] count];
    if (self.legendView.colors.count < _dataSeries.count) {
        for (int i = 0; i < _dataSeries.count; i++) {
            UIColor *color = [UIColor colorWithHue:1.0 * (i * COLOR_HUE_STEP % MAX_NUM_OF_COLOR) / MAX_NUM_OF_COLOR
                                        saturation:1
                                        brightness:1
                                             alpha:self.colorOpacity];
            self.legendView.colors[i] = color;
        }
    }
}

- (void)layoutSubviews {
    [self.legendView sizeToFit];
    CGRect r = self.legendView.frame;
    r.origin.x = self.frame.size.width - self.legendView.frame.size.width - LEGEND_PADDING;
    r.origin.y = LEGEND_PADDING;
    self.legendView.frame = r;
    [self bringSubviewToFront:self.legendView];
}

- (void)drawRect:(CGRect)rect {
    NSArray *colors = [self.legendView.colors copy];
    CGFloat radPerV = M_PI * 2 / _numOfV;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw attribute text
    CGFloat height = [self.scaleFont lineHeight];
    CGFloat padding = 2.0;
    for (int i = 0; i < _numOfV; i++) {
        NSString *attributeName = _attributes[i];
        CGPoint pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
        
        CGSize attributeTextSize = JY_TEXT_SIZE(attributeName, self.scaleFont);
        NSInteger width = attributeTextSize.width;
        
        CGFloat xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
        CGFloat yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
        CGPoint legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset);
        
        //TODO: use attributes in iOS 7
        int countNum = 0;
        if (i == 0) {
            countNum = -10;
        }
        else if (i == 3) {
            countNum = 15;
        }
        else {
            countNum = 0;
        }
        [attributeName drawInRect:CGRectMake(legendCenter.x - width / 2.0 + countNum,
                                             legendCenter.y - height / 2.0,
                                             width,
                                             height)
                         withFont:self.scaleFont
                    lineBreakMode:NSLineBreakByClipping
                        alignment:NSTextAlignmentCenter];
    }
    
    
    //draw steps line
    //static CGFloat dashedPattern[] = {3,3};
    //TODO: make this color a variable
    
    //四周边线颜色
    [[UIColor lightGrayColor] setStroke];
    
    [ColorLine setFill];
//    CGContextFillPath(context);
    
//    CGContextSaveGState(context);
    
    for (int step = 1; step <= _steps; step++) {
        for (int i = 0; i <= _numOfV; ++i) {
            
            
            if (i == 0) {
                
                CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r * step / _steps);
            }
            else {
                //                CGContextSetLineDash(context, 0, dashedPattern, 2);
                CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV) * step / _steps,
                                        _centerPoint.y - _r * cos(i * radPerV) * step / _steps);
            }
        }
//        CGContextStrokePath(context);
        CGContextFillPath(context);
    }
//    CGContextRestoreGState(context);
    
    //draw lines from center
    //TODO: make this color a variable
    
    //内部辐射状线条颜色
    [[UIColor colorWithWhite:1 alpha:0.3] setStroke];
    for (int i = 0; i < _numOfV; i++) {
        
        CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
        CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
                                _centerPoint.y - _r * cos(i * radPerV));
        CGContextStrokePath(context);
        
    }
    //end of base except axis label
    
    
    CGContextSetLineWidth(context, 2.0);
    
    //draw lines
    for (int serie = 0; serie < [_dataSeries count]; serie++) {
        if (self.fillArea) {
            //内部线条填充颜色
            [colors[serie] setFill];
            
        }
        else {
            [colors[serie] setStroke];
        }
        for (int i = 0; i < _numOfV; ++i) {
            CGFloat value = [_dataSeries[serie][i] floatValue];
            if (i == 0) {
                CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
            }
            else {
                CGContextAddLineToPoint(context, _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV),
                                        _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV));
            }
        }
        CGFloat value = [_dataSeries[serie][0] floatValue];
        CGContextAddLineToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
        
        if (self.fillArea) {
            CGContextFillPath(context);
        }
        else {
            CGContextStrokePath(context);
        }
        
        
        //draw data points
        if (_drawPoints) {
            for (int i = 0; i < _numOfV; i++) {
                CGFloat value = [_dataSeries[serie][i] floatValue];
                CGFloat xVal = _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV);
                CGFloat yVal = _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV);
                
                [colors[serie] setFill];
                CGContextFillEllipseInRect(context, CGRectMake(xVal - 4, yVal - 4, 8, 8));
//                [self.backgroundColor setFill];
                [[UIColor colorWithWhite:0 alpha:0.1] setFill];
                CGContextFillEllipseInRect(context, CGRectMake(xVal - 2, yVal - 2, 4, 4));
            }
        }
    }
    
    if (self.showStepText) {
        //draw step label text, alone y axis
        //TODO: make this color a variable
        [[UIColor blackColor] setFill];
        for (int step = 0; step <= _steps; step++) {
            CGFloat value = _minValue + (_maxValue - _minValue) * step / _steps;
            NSString *currentLabel = [NSString stringWithFormat:@"%.0f", value];
            JY_DRAW_TEXT_IN_RECT(currentLabel,
                                 CGRectMake(_centerPoint.x + 3,
                                            _centerPoint.y - _r * step / _steps - 3,
                                            20,
                                            10),
                                 self.scaleFont);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
