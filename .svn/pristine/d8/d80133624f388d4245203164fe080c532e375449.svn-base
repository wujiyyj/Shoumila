//
//  RYGScrollPageView.h
//  shoumila
//
//  Created by jiaocx on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidScrollBlock) (NSInteger);

@interface RYGScrollPageView : UIScrollView

@property(nonatomic,copy)NSArray *viewControllers;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,copy)DidScrollBlock scrollBlock;

- (id)initWithFrame:(CGRect)frame withPageNums:(NSInteger)pageNums;

#pragma mark 滑动到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex;

@end
