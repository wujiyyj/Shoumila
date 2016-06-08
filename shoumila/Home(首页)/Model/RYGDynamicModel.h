//
//  RYGDynamicModel.h
//  shoumila
//
//  Created by 贾磊 on 15/9/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGExtendCommentModel.h"
#import "RYGDynamicUserModel.h"
#import "RYGArticleModel.h"
 
@interface RYGDynamicModel : NSObject
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *cat;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *praise_num;
@property(nonatomic,copy) NSString *comment_num;
@property(nonatomic,copy) NSString *share_num;
@property(nonatomic,copy) NSString *self_is_praised;
@property(nonatomic,copy) NSString *self_is_commented;
@property(nonatomic,copy) NSString *self_is_shared;
@property(nonatomic,copy) NSString *is_favorite;
@property(nonatomic,copy) NSString *is_lock;
@property(nonatomic,copy) NSString *is_hide;
@property(nonatomic,copy) NSString *is_closure;
@property(nonatomic,copy) NSString *publish_time;
@property(nonatomic,copy) NSString *stamp;
@property(nonatomic,copy) NSString *share_url;
@property(nonatomic,copy) NSString *popup_a;
@property(nonatomic,copy) NSString *popup_b;
@property(nonatomic,copy) NSString *popup_c;
@property(nonatomic,copy) NSArray *comment_list;
@property(nonatomic,copy) NSArray *pics;
@property(nonatomic,copy) NSString *max_continuous_tag; //连红
@property(nonatomic,copy) NSString *win_tag;            //60中30
@property(nonatomic,copy) NSString *today_publish;
@property(nonatomic,strong) RYGExtendCommentModel *extended_content;
@property(nonatomic,strong) RYGDynamicUserModel *publish_user;
@property(nonatomic,strong) RYGArticleModel *article;

@end
