//
//  RYGLegendView.h
//  shoumila
//
//  Created by Xmj on 15/9/7.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYGLegendView : UIView

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *colors;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define JY_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithAttributes : @{ NSFontAttributeName : font }] : CGSizeZero;
#define JY_DRAW_TEXT_AT_POINT(text, point, font) [text drawAtPoint : point withAttributes : @{ NSFontAttributeName:font }];
#define JY_DRAW_TEXT_IN_RECT(text, rect, font) [text drawInRect : rect withAttributes : @{ NSFontAttributeName:font }];
#else
#define JY_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithFont : font] : CGSizeZero;
#define JY_DRAW_TEXT_AT_POINT(text, point, font) [text drawAtPoint : point withFont : font];
#define JY_DRAW_TEXT_IN_RECT(text, rect, font) [text drawInRect : rect withFont : font];

#endif

@end
