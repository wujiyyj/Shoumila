//
//  RYGBlackListTableViewCell.h
//  shoumila
//
//  Created by 阴～ on 15/9/1.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGBlackPersonModel.h"

@protocol RYGBlackListTableViewCellDelegate <NSObject>

- (void)clickOtherPerson:(NSString *)userId;

- (void)clickcancelShieldButton:(NSString *)userId;

@end

@interface RYGBlackListTableViewCell : UITableViewCell

@property(nonatomic,weak)id<RYGBlackListTableViewCellDelegate>delegate;

@property(nonatomic,strong)RYGBlackPersonModel *blackPersonModel;

@end
