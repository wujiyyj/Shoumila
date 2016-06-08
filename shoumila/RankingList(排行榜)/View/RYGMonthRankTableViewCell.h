//
//  RYGMonthRankTableViewCell.h
//  月度榜的cell单元格
//
//  Created by jiaocx on 15/8/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RYGMonthPersonModel;

@protocol RYGMonthRankTableViewCellDelegate <NSObject>

- (void)clickOtherPerson:(NSString *)userId;

- (void)clickAttentionButton:(NSString *)userId op:(NSString *)op index:(NSInteger)index;

@end

#define MonthRankCellHeight 135

@interface RYGMonthRankTableViewCell : UITableViewCell

@property(nonatomic,weak)id<RYGMonthRankTableViewCellDelegate>delegate;

@property(nonatomic,strong)RYGMonthPersonModel *personRankingModel;

@property(nonatomic,assign)NSInteger cellIndex;

- (void)updateAttentionStatus:(NSString *)isAttention;

@end
