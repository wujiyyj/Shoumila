//
//  RYGSlideMenuView.h
//  滑动切换页面的按钮

//
//  Created by jiaocx on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MenuFont     @"font"
#define MenuColor    @"color"

typedef void(^SelectMenuABlock)(NSInteger index);
typedef void (^SliderLeftBlock)();
typedef void (^SearchBlock)();
typedef void (^PublishBlock) ();

@interface RYGHomeSlideMenuView : UIView

@property (nonatomic, strong)   NSDictionary *textAttributes;
@property (nonatomic, strong)   NSDictionary *selectedTextAttributes;
@property (nonatomic, strong)   NSDictionary *transitionTextAttributes;
@property (nonatomic,copy)      SelectMenuABlock selectBlock;
@property (nonatomic,copy)      SliderLeftBlock sliderLeftBlock;
@property (nonatomic,copy)      SearchBlock searchBlock;
@property (nonatomic,copy)      PublishBlock publishBlock;
@property (nonatomic,assign) NSUInteger currentSelectedIndex;

- (id)initWithFrame:(CGRect)frame menuTitles:(NSArray *)menuTitles;

@end
