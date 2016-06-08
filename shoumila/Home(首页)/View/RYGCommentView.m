//
//  RYGCommentView.m
//  shoumila
//
//  Created by 贾磊 on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGCommentView.h"
#import "RYGPraiseParam.h"
#import "RYGHttpRequest.h"
#import "RYGThreadModel.h"
#import "UIImageView+WebCache.h"
#import "RYGFeedThreadsViewController.h"
#import "RYGUserCenterViewController.h"
#import "RYGCommentParam.h"
#import "MBProgressHUD+MJ.h"

@interface RYGCommentView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UIImageView *avatar;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *commentLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIButton *praiseBtn;
@property(nonatomic,strong) UIButton *msgBtn;
@property(nonatomic,strong) UIView *threadBgView;
@property(nonatomic,strong) UIButton *moreBtn;
@property(nonatomic,strong) UITableView *threadTableView;
@end
@implementation RYGCommentView{
    UIButton *moreBtn;
    RYGThreadModel *selectModel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:view];
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 24, 24)];
        [self addSubview:_avatar];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 4;
        _avatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userAction)];
        [_avatar addGestureRecognizer:gesture];

        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 15, 120, 13)];
        _nameLabel.textColor = ColorRankMenuBackground;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];

        _commentLabel = [[UILabel alloc]init];
        _commentLabel.textColor = ColorName;
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.numberOfLines = 0;
        [self addSubview:_commentLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = ColorSecondTitle;
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_timeLabel];
        
        _praiseBtn = [[UIButton alloc]init];
        [_praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_sel"] forState:UIControlStateSelected];
        [_praiseBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_praiseBtn addTarget:self action:@selector(praiseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_praiseBtn];
        
        _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_praiseBtn.frame)+20, 0, 35, 20)];
        [self addSubview:_msgBtn];
        [_msgBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        _msgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_msgBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//        [_msgBtn addTarget:self action:@selector(msgBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _msgBtn.userInteractionEnabled = NO;
        
        moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        moreBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [moreBtn setTitle:@"更多..." forState:UIControlStateNormal];
        [moreBtn setTitleColor:ColorRankMenuBackground forState:UIControlStateNormal];
        //        _threadTableView.tableFooterView = moreBtn;
        moreBtn.backgroundColor = ColorThreadBackground;
        [moreBtn addTarget:self action:@selector(moreThread) forControlEvents:UIControlEventTouchUpInside];
        _threadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) style:UITableViewStylePlain];
        _threadTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _threadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _threadTableView.layer.cornerRadius = 2;
        _threadTableView.delegate = self;
        _threadTableView.dataSource = self;
        _threadTableView.scrollEnabled = NO;
        _threadTableView.backgroundColor = ColorThreadBackground;
        [self addSubview:_threadTableView];
        
        
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"threadCell"];
    }

    RYGThreadModel *comment = _commentFrame.commentModel.thread[indexPath.row];
    NSString *reply = comment.reply_name?[NSString stringWithFormat:@"回复%@",comment.reply_name]:@"";
    NSString *commentStr = [NSString stringWithFormat:@"%@%@:%@",comment.name,reply,comment.comment];
    NSMutableAttributedString *attrComment = [[NSMutableAttributedString alloc]initWithString:commentStr];
    NSRange name = NSMakeRange(0, comment.name.length);
    [attrComment addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:name];
    NSRange replyRange = NSMakeRange(comment.name.length+2, comment.reply_name.length);
    [attrComment addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:replyRange];
    
    cell.textLabel.attributedText = attrComment;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = ColorThreadBackground;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_commentFrame.commentModel.thread.count == 3) {
//        _threadTableView.tableFooterView = [UIView new];
//    }
    return _commentFrame.commentModel.thread.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *height = _commentFrame.threadCellF[indexPath.row];
    return [height floatValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectModel = _commentFrame.commentModel.thread[indexPath.row];
    if (_tableViewSelectedBlock) {
        if ([RYGUtility getUserInfo].userid == selectModel.uid) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"删除回复" message:@"确定删除回复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        _tableViewSelectedBlock(_commentFrame.commentModel.thread[indexPath.row]);
    }else{
        [self moreThread];
    }
}



-(void)setCommentFrame:(RYGFeedDetailCommentFrame *)commentFrame{
    _commentFrame = commentFrame;
    if (_commentFrame.commentModel.thread.count == 3) {
        _threadTableView.tableFooterView = moreBtn;
    }
    RYGCommentModel *commentModel = commentFrame.commentModel;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] placeholderImage:[UIImage imageNamed:@"user_head"]];
    _nameLabel.text = commentModel.name;
    _timeLabel.frame = commentFrame.timeF;
    _timeLabel.text = commentModel.ctime;
    _praiseBtn.frame = commentFrame.praiseF;
    if ([commentModel.praise_num integerValue]) {
        [_praiseBtn setTitle:commentModel.praise_num forState:UIControlStateNormal];
    }
    if ([commentModel.self_is_praised integerValue]) {
        _praiseBtn.selected = YES;
    }
    _msgBtn.frame = commentFrame.messageF;
//    [_msgBtn setTitle:commentModel.m forState:UIControlStateNormal];
    _commentLabel.text = commentModel.comment;
    _commentLabel.frame = commentFrame.commentF;
    [_praiseBtn setTitle:commentModel.praise_num forState:UIControlStateNormal];
    _threadTableView.frame = commentFrame.threadTableViewF;
    [_threadTableView reloadData];
    self.height = commentFrame.cellHeight;
}
- (void)praiseBtnAction{
    RYGPraiseParam *param = [RYGPraiseParam param];
    RYGCommentModel *model = _commentFrame.commentModel;
    param.feed_id = _feed_id;
    param.comment_id = model.comment_id;
    param.cancel = model.self_is_praised;
    [RYGHttpRequest getWithURL:Feed_praise params:[param keyValues] success:^(id json) {
        if (![model.self_is_praised intValue]) {
            _praiseBtn.selected = YES;
            model.self_is_praised = @"1";
            int praiseNum = [model.praise_num intValue] +1;
            NSString *numStr = [NSString stringWithFormat:@"%d",praiseNum];
            model.praise_num = numStr;
            [_praiseBtn setTitle:numStr forState:UIControlStateNormal];
        }else{
            _praiseBtn.selected = NO;
            model.self_is_praised = @"0";
            int praiseNum = [model.praise_num intValue] - 1;
            NSString *numStr = [NSString stringWithFormat:@"%d",praiseNum];
            model.praise_num = numStr;
            [_praiseBtn setTitle:numStr forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)moreThread{
    RYGFeedThreadsViewController *feedThread = [[RYGFeedThreadsViewController alloc]init];
    feedThread.comment_id = _commentFrame.commentModel.comment_id;
    feedThread.feed_id = _feed_id;
    [[RYGUtility getCurrentVC] pushViewController:feedThread animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (_msgBtnBlock) {
        _msgBtnBlock();
    }
}
//TODO
- (void)userAction{
    RYGUserCenterViewController *userCenterVC = [[RYGUserCenterViewController alloc]init];
    NSString *name = _commentFrame.commentModel.name;
    userCenterVC.user_name = name;
    [[RYGUtility getCurrentVC] pushViewController:userCenterVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        RYGCommentParam *param = [RYGCommentParam param];
        param.feed_id = self.feed_id;
        param.del = @"1";
        param.thread_id = selectModel.comment_id;
        
        [RYGHttpRequest getWithURL:Feed_comment params:[param keyValues] success:^(id json) {
            if (self.reloadBlock) {
                self.reloadBlock();
            }
            [MBProgressHUD showSuccess:@"删除成功!"];
            
        } failure:^(NSError *error) {
            
        }];
    }
}
@end
