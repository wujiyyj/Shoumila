//
//  RYGLineChart.h
//  shoumila
//
//  Created by Xmj on 15/9/8.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYGLineChart : UIView

// Block definition for getting a label for a set index (use case: date, units,...)
typedef NSString *(^FSLabelForIndexGetter)(NSUInteger index);

// Same as above, but for the value (for adding a currency, or a unit symbol for example)
typedef NSString *(^FSLabelForValueGetter)(CGFloat value);

// Number of visible step in the chart
@property (nonatomic, readwrite) int gridStep;

@property (nonatomic,assign)    int dataType;

@property (nonatomic,strong)    NSString* maxLine;

@property (nonatomic, retain)   NSMutableArray* dataArray;

// Margin of the chart
@property (nonatomic, readwrite) CGFloat margin;

@property (nonatomic, readonly) CGFloat axisWidth;
@property (nonatomic, readonly) CGFloat axisHeight;

// Decoration parameters, let you pick the color of the line as well as the color of the axis
@property (nonatomic, readwrite) UIColor* axisColor;
@property (nonatomic, readwrite) UIColor* color;

@property (copy) FSLabelForIndexGetter labelForIndex;
@property (copy) FSLabelForValueGetter labelForValue;

// Set the actual data for the chart, and then render it to the view.
- (void)setChartData:(NSArray *)chartData;

@end
