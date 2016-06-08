//
//  RYGReplyMeTableViewCell.h
//  回复我的消息单元格
//
//  Created by jiaocx on 15/8/20.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGMessageReplyModel.h"

typedef void(^ReplyBlock) (RYGMessageReplyModel *messageReplyModel);
typedef void(^SwitchOtherPersonBlock) (NSString *userId);
typedef void(^SwitchDetailOrCommentBlock) (RYGOriginalnvitationModel *original);

@interface RYGReplyMeTableViewCell : UITableViewCell

@property(nonatomic,copy)ReplyBlock replyBlock;
@property(nonatomic,copy)SwitchOtherPersonBlock switchOtherPersonBlock;
@property(nonatomic,copy)SwitchDetailOrCommentBlock switchDetailOrCommentBlock;
@property(nonatomic,strong)RYGMessageReplyModel *messageReplyModel;

@end
