//
//  RYGCommentModel.h
//  shoumila
//
//  Created by 贾磊 on 15/9/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGCommentModel : NSObject
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *comment;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *avatar;
@property(nonatomic,copy) NSString *reply_uid;
@property(nonatomic,copy) NSString *reply_name;
@property(nonatomic,copy) NSString *reply_avatar;
@property(nonatomic,copy) NSString *ctime;

@property(nonatomic,copy) NSString *praise_num;
@property(nonatomic,copy) NSString *comment_num;
@property(nonatomic,copy) NSString *comment_id;
@property(nonatomic,copy) NSString *self_is_praised;
@property(nonatomic,strong) NSArray *thread;
@end
