//
//  RYGSubscribeViewController.h
//  shoumila
//
//  Created by yinyujie on 15/7/30.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"
#import "RYGSubscribeTableViewCell.h"

@interface RYGSubscribeViewController : RYGBaseViewController<UITableViewDelegate,UITableViewDataSource,RYGSubscribeTableViewCellDelegate>

@property (nonatomic,strong) NSString* userid;
@property (nonatomic,copy) void (^selectedCell)(RYGAttentionPersonModel *);

@end
