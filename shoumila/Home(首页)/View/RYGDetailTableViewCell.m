//
//  RYGDetailTableViewCell.m
//  shoumila
//
//  Created by 贾磊 on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDetailTableViewCell.h"
#import "RYGCommentView.h"
#import "RYGRecommendContentView1.h"

@interface RYGDetailTableViewCell ()
@property(nonatomic,strong) RYGCommentView *commentView;
@property(nonatomic,strong) RYGRecommendContentView1 *recommendContentView;
@end
@implementation RYGDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ColorRankMyRankBackground;
        [self setUpCommentView];
    }
    return self;
}
-(void)setUpCommentView{
    _commentView = [[RYGCommentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self addSubview:_commentView];
}

- (void)setCommentFrame:(RYGFeedDetailCommentFrame *)commentFrame{
    _commentFrame = commentFrame;
    _commentView.commentFrame = commentFrame;
    _commentView.feed_id = _feed_id;

}


@end
