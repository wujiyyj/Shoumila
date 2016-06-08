//
//  RYGAttendedPersonDynamicMessageTableViewCell.h
//  被关注的人的动态消息单元格
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RYGAttendedPersonDynamicMessageModel.h"

@interface RYGAttendedPersonDynamicMessageCollectionViewCell:UICollectionViewCell
@property(nonatomic,copy)NSString *photo;
@end

typedef void(^SwitchOtherPersonBlock) (NSString *userId);
typedef void(^SwitchDetailOrCommentBlock) (RYGAttendedPersonDynamicMessageModel *original);

@interface RYGAttendedPersonDynamicMessageTableViewCell : UITableViewCell

@property(nonatomic,strong)RYGAttendedPersonDynamicMessageModel *attendedPersonDynamicMessageModel;
@property(nonatomic,copy)SwitchOtherPersonBlock switchOtherPersonBlock;
@property(nonatomic,copy)SwitchDetailOrCommentBlock switchDetailOrCommentBlock;

@end
