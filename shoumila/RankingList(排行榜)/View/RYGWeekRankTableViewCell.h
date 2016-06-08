//
//  RYGWeekRankTableViewCell.h
//  周榜单的cell单元格
//
//  Created by jiaocx on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYGWeekPersonModel;

@protocol RYGWeekRankTableViewCellDelegate <NSObject>

- (void)clickOtherPerson:(NSString *)userId;

- (void)clickAttentionButton:(NSString *)userId op:(NSString *)op index:(NSInteger)index;

@end

#define WeekRankCellHeight 135

@interface RYGWeekRankTableViewCell : UITableViewCell

@property(nonatomic,weak)id<RYGWeekRankTableViewCellDelegate>delegate;

@property(nonatomic,strong)RYGWeekPersonModel *personRankingModel;

@property(nonatomic,assign)NSInteger cellIndex;

- (void)updateAttentionStatus:(NSString *)isAttention;


@end
