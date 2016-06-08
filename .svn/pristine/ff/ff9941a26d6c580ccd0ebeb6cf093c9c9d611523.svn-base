//
//  RYGMessagePraiseMeTableViewCell.h
//  赞过我的消息单元格
//
//  Created by jiaocx on 15/8/21.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGMessagePraiseModel.h"

@interface RYGMessagePraiseMeCollectionViewCell:UICollectionViewCell

@property(nonatomic,copy)NSString *user_logo;
@property(nonatomic,strong)UIImageView *portraitImageView;

@end

typedef void(^SwitchOtherPersonBlock) (NSString *userId);
typedef void(^SwitchDetailOrCommentBlock) (RYGOriginalnvitationModel *original);

@interface RYGMessagePraiseMeTableViewCell : UITableViewCell

@property(nonatomic,copy)SwitchOtherPersonBlock switchOtherPersonBlock;
@property(nonatomic,copy)SwitchDetailOrCommentBlock switchDetailOrCommentBlock;
@property(nonatomic,strong)RYGMessagePraiseModel *messagePraiseModel;

@end
