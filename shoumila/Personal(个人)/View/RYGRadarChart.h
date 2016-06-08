//
//  RYGRadarChart.h
//  shoumila
//
//  Created by Xmj on 15/9/7.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYGRadarChart : UIView

@property (nonatomic, assign) CGFloat r;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) BOOL fillArea;
@property (nonatomic, assign) BOOL showLegend;
@property (nonatomic, assign) BOOL showStepText;
@property (nonatomic, assign) CGFloat colorOpacity;
@property (nonatomic, copy) UIColor *backgroundLineColor;
@property (nonatomic, strong) NSArray *dataSeries;
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, assign) NSUInteger steps;
@property (nonatomic, assign) CGPoint centerPoint;

- (void)setTitles:(NSArray *)titles;
- (void)setColors:(NSArray *)colors;

@end
