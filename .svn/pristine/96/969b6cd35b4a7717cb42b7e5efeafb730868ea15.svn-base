//
//  RYGActiveSectionView.h
//  活跃榜
//
//  Created by jiaocx on 15/8/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ActiveRankSectionHeight 63

@class RYGActivePersonModel;

@protocol RYGActiveSectionViewDelegate <NSObject>

- (void)clickOtherPerson:(NSString *)userId;

- (void)onClickHeadView:(NSInteger)section;

@end


@interface RYGActiveSectionView : UIView

@property(nonatomic,strong)RYGActivePersonModel *personRankingModel;
@property(nonatomic,weak)id<RYGActiveSectionViewDelegate>delegate;
@property(nonatomic,assign)NSInteger section;


@end
