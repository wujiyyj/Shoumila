//
//  RYGSubscribeTableViewCell.h
//  shoumila
//
//  Created by yinyujie on 15/8/6.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGAttentionPersonModel.h"

//@class RYGAttentionPersonModel;
@protocol RYGSubscribeTableViewCellDelegate <NSObject>

- (void)clickOtherPerson:(NSString *)userId;

- (void)clickCancelAttentionButton:(NSString *)userId;

@end

@interface RYGSubscribeTableViewCell : UITableViewCell

@property(nonatomic,weak)id<RYGSubscribeTableViewCellDelegate>delegate;

@property(nonatomic,strong)RYGAttentionPersonModel *attentionPersonModel;

@end
