//
//  RYGCommentParam.h
//  shoumila
//
//  Created by 贾磊 on 15/9/26.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGCommentParam : RYGBaseParam
@property(nonatomic,copy) NSString *feed_id;
@property(nonatomic,copy) NSString *del;
@property(nonatomic,copy) NSString *comment;
@property(nonatomic,copy) NSString *comment_id;
@property(nonatomic,copy) NSString *reply_uid;
@property(nonatomic,copy) NSString *thread_id;
@end
