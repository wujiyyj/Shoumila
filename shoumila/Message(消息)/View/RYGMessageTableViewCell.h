//
//  RYGMessageTableViewCell.h
//  消息画面
//
//  Created by jiaocx on 15/8/18.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGMessageBaseModel.h"

#define MessageTableViewCellHeight 70

@interface RYGMessageTableViewCell : UITableViewCell

@property(nonatomic,strong) RYGMessageBaseModel *messageModel;

@end
