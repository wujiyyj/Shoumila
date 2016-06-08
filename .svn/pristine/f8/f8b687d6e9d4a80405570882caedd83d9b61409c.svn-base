//
//  RYGMenuItemView.h
//  shoumila
//
//  Created by yinyujie on 15/8/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MenuFont     @"font"
#define MenuColor    @"color"

typedef void(^SelectMenuABlock)(NSInteger index);

@interface RYGMenuItemView : UIView

@property (nonatomic, strong) NSDictionary *textAttributes;
@property (nonatomic, strong) NSDictionary *selectedTextAttributes;
@property (nonatomic, strong) NSDictionary *transitionTextAttributes;
@property(nonatomic,copy)SelectMenuABlock selectBlock;
@property (nonatomic,assign) NSUInteger currentSelectedIndex;

- (id)initWithFrame:(CGRect)frame menuTitles:(NSArray *)menuTitles;

@end
