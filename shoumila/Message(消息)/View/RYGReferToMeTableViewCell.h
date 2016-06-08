//
//  RYGReferToMeTableViewCell.h
//  提到我的消息的单元格
//
//  Created by jiaocx on 15/8/21.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGMessageReferToMeModel.h"

typedef void(^SwitchOtherPersonBlock) (NSString *userId);
typedef void(^SwitchDetailOrCommentBlock) (RYGOriginalnvitationModel *original);

@interface RYGReferToMeTableViewCell : UITableViewCell

@property(nonatomic,copy)SwitchOtherPersonBlock switchOtherPersonBlock;
@property(nonatomic,copy)SwitchDetailOrCommentBlock switchDetailOrCommentBlock;
@property(nonatomic,strong)RYGMessageReferToMeModel *messageReferToMeModel;


@end
