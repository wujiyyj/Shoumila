//
//  RYGMessageCenterTableViewCell.h
//  消息中心单元格
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGMessageCenterModel.h"

@interface RYGMessageCenterTableViewCell : UITableViewCell

@property(nonatomic,strong)RYGMessageCenterModel *messageCenterModel;

- (void)updateCell:(RYGMessageCenterModel *)messageCenterModel showTime:(NSString *)showTime;

@end
