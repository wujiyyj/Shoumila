//
//  RYGDynamicFrame.m
//  shoumila
//
//  Created by 贾磊 on 15/9/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicFrame.h"
#import "RYGDynamicUserModel.h"
#import "RYGPhotosView.h"
#import "RYGCommentModel.h"

@implementation RYGDynamicFrame
-(void)setDynamicModel:(RYGDynamicModel *)dynamicModel{
    _dynamicModel = dynamicModel;
    
    
    // **** 普通Cell
    NSDictionary *attributes;
    _avatarF = CGRectMake(15, 15, 32, 32);
    
    NSString *name = dynamicModel.publish_user.name;
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize nameLabelSize = [name sizeWithAttributes:attributes];
    _nameF = CGRectMake(CGRectGetMaxX(_avatarF)+10, 15, nameLabelSize.width, nameLabelSize.height);
    
    NSString *pubsh_time = dynamicModel.publish_time;
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10]};
    CGSize pubsh_timeSize = [pubsh_time sizeWithAttributes:attributes];
    _publish_timeF = CGRectMake(_nameF.origin.x, CGRectGetMaxY(_nameF)+7, pubsh_timeSize.width, pubsh_timeSize.height);
    
    NSString *content = dynamicModel.content;
    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];

//       CGSize size1 = [content sizeWithAttributes:attributes];
        contentSize.height = contentSize.height + 16.702*(contentSize.height/167.02);
    if (self.isDetail) {
        _contentF = CGRectMake(15, CGRectGetMaxY(_avatarF)+15, SCREEN_WIDTH - 30, contentSize.height);
    }else{
        double height = contentSize.height<220?contentSize.height:220;
        _contentF = CGRectMake(15, CGRectGetMaxY(_avatarF)+15, SCREEN_WIDTH - 30, height);
    }
    
    
    CGFloat photosViewX = 15;
    CGFloat photosViewY = CGRectGetMaxY(_contentF) + 10;
    if (dynamicModel.pics) {
        CGSize photosViewSize = [RYGPhotosView photosViewSizeWithPhotosCount:dynamicModel.pics.count];
        if (self.isDetail) {
            _photosViewF = CGRectMake(photosViewX, photosViewY, photosViewSize.width, photosViewSize.height);
        }else{
            photosViewY = contentSize.height<220?photosViewY:photosViewY+15;
            _photosViewF = CGRectMake(photosViewX, photosViewY, photosViewSize.width, photosViewSize.height);
        }
    }else{
        _photosViewF = CGRectMake(photosViewX, photosViewY, 0, 0);
    }
    if ([dynamicModel.cat isEqualToString:@"1"]) {
        _barViewF = CGRectMake(SCREEN_WIDTH - 190, CGRectGetMaxY(_photosViewF)+10, 190, 20);
        
    }else if([dynamicModel.cat isEqualToString:@"5"]){
        _barViewF = CGRectMake(SCREEN_WIDTH - 190, 83, 190, 20);
    }else{
        _barViewF = CGRectMake(SCREEN_WIDTH - 190, 142, 190, 20);
    }
    
    _contentViewF = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_barViewF)+10);
    
    _line1F = CGRectMake(0, 0, SCREEN_WIDTH, 1);
//    _moreMsgBtnF = CGRectMake(0, CGRectGetMaxY(_lineF), SCREEN_WIDTH, 0);
    NSArray *comments = dynamicModel.comment_list;
    if (comments) {
        [comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RYGCommentModel *commentModel = obj;
            NSString *report = commentModel.reply_name?@"回复:":@"";
            NSString *content = [NSString stringWithFormat:@"%@%@%@%@",commentModel.name,commentModel.comment,commentModel.reply_name,report];
            CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 53, MAXFLOAT)];
            if (idx==0) {
                _avatar1F = CGRectMake(15, 10, 18, 18);
                _label1F = CGRectMake(CGRectGetMaxX(_avatar1F)+5, 10, contentSize.width, contentSize.height);
                _lineF = CGRectMake(15, CGRectGetMaxY(_label1F)+10, SCREEN_WIDTH-30, 1);
            }else if(idx ==1){
                _avatar2F = CGRectMake(15, CGRectGetMaxY(_label1F)+8, 18, 18);
                _label2F = CGRectMake(CGRectGetMaxX(_avatar1F)+5, _avatar2F.origin.y, contentSize.width, contentSize.height);
                _lineF = CGRectMake(15, CGRectGetMaxY(_label2F)+10, SCREEN_WIDTH-30, 1);
            }else if(idx == 2){
                _avatar3F = CGRectMake(15, CGRectGetMaxY(_label2F)+8, 18, 18);
                _label3F = CGRectMake(CGRectGetMaxX(_avatar2F)+5, _avatar3F.origin.y, contentSize.width, contentSize.height);
                _lineF = CGRectMake(15, CGRectGetMaxY(_label3F)+10, SCREEN_WIDTH-30, 0.5);

            }
        }];
        if ([dynamicModel.comment_num intValue] >3) {
            _moreMsgBtnF = CGRectMake(0, CGRectGetMaxY(_lineF), SCREEN_WIDTH, 30);
        }
        _moreMsgBtnF = CGRectMake(0, CGRectGetMaxY(_lineF), _moreMsgBtnF.size.width, _moreMsgBtnF.size.height);
//        _moreMsgBtnF = CGRectMake(0, CGRectGetMaxY(_lineF), SCREEN_WIDTH, 30);
        _commentViewF = CGRectMake(0, CGRectGetMaxY(_contentViewF), SCREEN_WIDTH, CGRectGetMaxY(_moreMsgBtnF));
    }else{
        _avatar1F = CGRectMake(15, 10, 0, 0);
        _label1F = CGRectMake(CGRectGetMaxX(_avatar1F)+5, 10, 0, 0);

        _avatar2F = CGRectMake(15, 10, 0, 0);
        _label2F = CGRectMake(CGRectGetMaxX(_avatar1F)+5, 10, 0, 0);
        _commentViewF = CGRectMake(0, CGRectGetMaxY(_contentViewF), SCREEN_WIDTH, 0);
    }
    _line2F = CGRectMake(0, CGRectGetMaxY(_commentViewF), SCREEN_WIDTH, 10);
    _cellHeight = CGRectGetMaxY(_commentViewF)+10;
}
@end
