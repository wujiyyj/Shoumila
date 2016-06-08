//
//  RYGFeedDetailCommentFrame.m
//  shoumila
//
//  Created by 贾磊 on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGFeedDetailCommentFrame.h"
#import "RYGThreadModel.h"

@implementation RYGFeedDetailCommentFrame
-(instancetype)init{
    self = [super init];
    if (self) {
        _threadCellF = [NSMutableArray array];
    }
    return self;
}
-(void)setCommentModel:(RYGCommentModel *)commentModel{
    _commentModel = commentModel;
    NSString *comment = commentModel.comment;
    CGSize commentSize = [comment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 59, MAXFLOAT)];
    _commentF = CGRectMake(44, 35, commentSize.width, commentSize.height);
    _timeF = CGRectMake(44, CGRectGetMaxY(_commentF)+5, 120, 11);
    _praiseF = CGRectMake(SCREEN_WIDTH - 85, _timeF.origin.y, 40, 15);
    _messageF = CGRectMake(CGRectGetMaxX(_praiseF), _praiseF.origin.y, 40, 15);
    _cellHeight = CGRectGetMaxY(_praiseF)+30;
    NSArray *comments = commentModel.thread;
    if (comments) {
        CGFloat __block tableViewHiegth = 0.0f;
        [comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGThreadModel *threadModel = obj;
            NSString *report = threadModel.reply_name?@"回复:":@"";
            NSString *content = [NSString stringWithFormat:@"%@%@%@%@",threadModel.name,threadModel.comment,threadModel.reply_name,report];
            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 80, MAXFLOAT)];
            CGFloat height= contentSize.height+10;
            [_threadCellF addObject:[NSNumber numberWithFloat:height]];
            _cellHeight +=height;
            tableViewHiegth +=height;
        }];
        CGFloat footerHeight = _isNeedFooter?20:0;
        _threadTableViewF = CGRectMake(44, CGRectGetMaxY(_timeF)+10, SCREEN_WIDTH - 59, tableViewHiegth+footerHeight+10);
    }
    
}
@end
