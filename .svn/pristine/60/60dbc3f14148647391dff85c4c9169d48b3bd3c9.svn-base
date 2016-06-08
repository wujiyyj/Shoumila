//
//  RYGPieChartView.h
//  shoumila
//
//  Created by jiaocx on 15/8/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYGPieChartView : UIView

// 线的数据
@property(nonatomic,strong)NSArray *linesData;

// 曲线颜色
@property(nonatomic,strong)UIColor *pieLineColor;

// 经线Title显示的内容
@property(nonatomic,strong)NSMutableArray *longitudeTitles;
// 纬线Title显示的内容
@property(nonatomic,strong)NSMutableArray *latitudeTitles;

// 经线颜色
@property(nonatomic,strong)UIColor *longitudeColor;
// 纬线颜色
@property(nonatomic,strong)UIColor *latitudeColor;

// 经线字体颜色
@property(nonatomic,strong)UIColor *longitudeFontColor;
// 纬线字体颜色
@property(nonatomic,strong)UIColor *latitudeFontColor;

// 经线字体
@property(nonatomic,strong)UIFont *longitudeFont;
// 纬线字体
@property(nonatomic,strong)UIFont *latitudeFont;

// 经线Title显示数目
@property(nonatomic,assign)NSInteger longitudeNum;
// 纬线Title显示数目
@property(nonatomic,assign)NSInteger latitudeNum;

// 显示起源
@property(nonatomic,assign) NSInteger displayFrom;

// k线的宽度 用来计算可存放K线实体的个数，也可以由此计算出起始日期和结束日期的时间段
@property (nonatomic,assign) CGFloat kLineWidth;

// 经线,纬线宽度
@property (nonatomic,assign) CGFloat xyLineWidth;

@end
