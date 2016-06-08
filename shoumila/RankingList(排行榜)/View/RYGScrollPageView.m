//
//  RYGScrollPageView.m
//  shoumila
//
//  Created by jiaocx on 15/7/27.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGScrollPageView.h"

@interface RYGScrollPageView ()<UIScrollViewDelegate>

@property (nonatomic,assign) NSInteger pageNums;
@property (nonatomic,assign) BOOL mNeedUseDelegate;

@end

@implementation RYGScrollPageView

- (id)initWithFrame:(CGRect)frame withPageNums:(NSInteger)pageNums
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pageNums = pageNums;
        self.mNeedUseDelegate = YES;
//        self.pagingEnabled = YES;
        self.delegate = self;
        [self setContentSize:CGSizeMake(self.width * self.pageNums, self.frame.size.height)];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.mNeedUseDelegate = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x+self.width/2.0) / self.width;
    if (self.currentPage == page) {
        return;
    }
    self.currentPage= page;
    if (self.scrollBlock && self.mNeedUseDelegate) {
        self.scrollBlock(self.currentPage);
    }
}

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex{
    self.mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [self scrollRectToVisible:vMoveRect animated:YES];
    self.currentPage= aIndex;
    if (self.scrollBlock && self.mNeedUseDelegate) {
        self.scrollBlock(self.currentPage);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"111");
}

@end
