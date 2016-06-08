//
//  RYGBarChart.m
//  shoumila
//
//  Created by Xmj on 15/9/7.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBarChart.h"

@implementation RYGBarChart

@synthesize color, numberOfBars, maxLen, refs, vals;

-(RYGBarChart *)initWithFrame:(CGRect)frame
                       color:(UIColor *)theColor
                  references:(NSArray *)references
                   andValues:(NSArray *)values
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = theColor;
        self.vals = values;
        self.refs = references;
    }
    return self;
}

-(void)calculate{
    self.numberOfBars = [self.vals count];
    for (NSNumber *val in vals) {
        float iLen = [val floatValue];
        if (iLen > self.maxLen) {
            self.maxLen = iLen;
            self.maxLen = 59;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    /// Drawing code
    [self calculate];
    float rectWidth = (float)(rect.size.width-(self.numberOfBars)) / (float)self.numberOfBars;
    CGContextRef context = UIGraphicsGetCurrentContext();
    float LBL_HEIGHT = 20.0f, iLen, x, heightRatio, height, y;
    UIColor *iColor ;
    
    NSMutableArray* colorArray = [NSMutableArray arrayWithCapacity:self.numberOfBars];
    for (int i=0; i<self.numberOfBars; i++) {
//        colorArray = [NSArray arrayWithObjects:[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor greenColor],[UIColor greenColor],[UIColor redColor],[UIColor redColor],[UIColor grayColor],[UIColor greenColor],[UIColor redColor], nil];
        if ([self.vals[i] intValue] == 59) {
            colorArray[i] = ColorRateTitle;
        }
        else if ([self.vals[i] intValue] == 34) {
            colorArray[i] = [UIColor greenColor];
        }
        else if ([self.vals[i] intValue] == 20) {
            colorArray[i] = [UIColor grayColor];
        }
        else {
            colorArray[i] = [UIColor clearColor];
        }
        
    }
    
//    NSArray* colorArray = [NSArray arrayWithObjects:[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor greenColor],[UIColor greenColor],[UIColor redColor],[UIColor redColor],[UIColor grayColor],[UIColor greenColor],[UIColor redColor], nil];
    /// Draw Bars
    for (int barCount = 0; barCount < self.numberOfBars; barCount++) {
        
        /// Calculate dimensions
        iLen = [[vals objectAtIndex:barCount] floatValue];
        x = barCount * (rectWidth);
        heightRatio = iLen / self.maxLen;
        height = heightRatio * rect.size.height;
        if (height < 0.1f) height = 1.0f;
        y = rect.size.height - height - LBL_HEIGHT;
        
        /// Reference Label.
//        UILabel *lblRef = [[UILabel alloc] initWithFrame:CGRectMake(barCount + x, rect.size.height - LBL_HEIGHT, rectWidth, LBL_HEIGHT)];
//        lblRef.text = [refs objectAtIndex:barCount];
//        lblRef.adjustsFontSizeToFitWidth = TRUE;
//        lblRef.adjustsLetterSpacingToFitWidth = TRUE;
//        lblRef.textColor = self.color;
//        [lblRef setTextAlignment:NSTextAlignmentCenter];
//        lblRef.backgroundColor = [UIColor clearColor];
//        [self addSubview:lblRef];
        
        /// Set color and draw the bar
//        iColor = [UIColor colorWithRed:(1 - heightRatio) green:(heightRatio) blue:(0) alpha:1.0];
        iColor = colorArray[barCount];
        CGContextSetFillColorWithColor(context, iColor.CGColor);
        CGRect barRect = CGRectMake(barCount + x, y, rectWidth, height);
        CGContextFillRect(context, barRect);
    }
    
    /// pivot
//    CGRect frame = CGRectZero;
//    frame.origin.x = rect.origin.x;
//    frame.origin.y = rect.origin.y - LBL_HEIGHT;
//    frame.size.height = LBL_HEIGHT;
//    frame.size.width = rect.size.width;
//    UILabel *pivotLabel = [[UILabel alloc] initWithFrame:frame];
//    pivotLabel.text = [NSString stringWithFormat:@"%d", (int)self.maxLen];
//    pivotLabel.backgroundColor = [UIColor clearColor];
//    pivotLabel.textColor = self.color;
//    [self addSubview:pivotLabel];
    
    /// A line
//    frame = rect;
//    frame.size.height = 1.0;
//    CGContextSetFillColorWithColor(context, self.color.CGColor);
//    CGContextFillRect(context, frame);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
