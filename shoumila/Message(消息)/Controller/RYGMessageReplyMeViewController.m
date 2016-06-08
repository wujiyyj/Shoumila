//
//  RYGMessageReplyMeViewController.m
//  回复我的消息
//
//  Created by jiaocx on 15/8/20.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageReplyMeViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "RYGHttpRequest.h"
#import "RYGReplyMeTableViewCell.h"
#import "RYGUserCenterViewController.h"
#import "RYGMessageRequestParam.h"
#import "RYGHttpRequest.h"
#import "RYGMessageReplyInfosModel.h"
#import "RYGLoginViewController.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGFeedThreadsViewController.h"
#import "RYGDynamicDetailViewController.h"

@interface RYGMessageReplyMeViewController ()<UITableViewDataSource,UITableViewDelegate>

// 回复我的消息列表
@property(nonatomic,strong)UITableView *replyMessageTableView;
// 下一页的标识
@property(nonatomic,strong)NSString *next;
// 回复我的消息的数据
@property(nonatomic,strong)NSMutableArray *replyMessageList;
// 是否有更多数据
@property(nonatomic,assign) BOOL isMoreData;
// 行高
@property(nonatomic,strong)NSMutableArray *rowHeights;
// 消息
@property(nonatomic,strong)RYGMessageReplyInfosModel *messageReplyInfosModel;

@end

@implementation RYGMessageReplyMeViewController

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"回复我的";
    _replyMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    _replyMessageTableView.delegate = self;
    _replyMessageTableView.dataSource = self;
    _replyMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _replyMessageTableView.backgroundColor = ColorRankBackground;
    [self.view addSubview:_replyMessageTableView];
    
    __weak __typeof(&*self)weakself = self;
    [self.replyMessageTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [self.replyMessageTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _rowHeights = [[NSMutableArray alloc]init];
    
//    if ([[SFReachability sharedInstance] networkStatus] == NotReachable)
//    {
//    }
//    else {
    [self aRefresh];
//    }
    
    [MobClick beginLogPageView:@"回复我的"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"回复我的"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"RYGWeekRankingViewController");
}

#pragma mark- private method

#pragma mark 初期刷新，下拉刷新
- (void)aRefresh {
    _replyMessageList = [NSMutableArray array];
    _next = 0;
    _isMoreData = YES;
    [self loadData];
}
- (void)loadData {
    [self.replyMessageTableView reloadData];
        RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
        messageRequestParam.next = _next;
        [RYGHttpRequest postWithURL:Message_Reply_Me params:messageRequestParam.keyValues success:^(id json) {
            NSMutableDictionary *dic = [json valueForKey:@"data"];
            self.messageReplyInfosModel = [RYGMessageReplyInfosModel objectWithKeyValues:dic];
            [self.replyMessageList addObjectsFromArray:self.messageReplyInfosModel.datas];
            _next = self.messageReplyInfosModel.next;
            // 没有加载更多
            if (self.messageReplyInfosModel.page_is_last || [self.messageReplyInfosModel.page_is_last isEqualToString:@"0"]) {
                _isMoreData = NO;
            }
            [self.replyMessageTableView.header setState:MJRefreshHeaderStateIdle];
            [self reloadRankingTable];
        } failure:^(NSError *error) {
            
        }];
    
}

#pragma mark 更新排行榜的列表
- (void)reloadRankingTable {
    // 是否登录
    [self.replyMessageTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.replyMessageTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.replyMessageTableView reloadData];
}

#pragma mark-
#pragma mark UITableViewDataSource UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.replyMessageList && self.replyMessageList.count>0) {
        return self.replyMessageList.count;
    }
    return 0;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYGMessageReplyModel *model = [self.replyMessageList objectAtIndex:indexPath.row];
    
    CGFloat rowHeight = 15 + 32 + 15;
    CGSize replyTitleSize = RYG_TEXTSIZE(model.content, [UIFont systemFontOfSize:14]);
    rowHeight += replyTitleSize.height;
    rowHeight += 10;
    if (indexPath.row >= [self.rowHeights count]) {
        CGFloat height = RYGMessageTableViewCellCommentPhotoHeight;
        // 评论内容+图片
        if (model.original.pic || (model.original.content && [model.original.content isEqualToString:@""])) {
            CGFloat magin = 7;
            CGSize commentSize = RYG_MULTILINE_TEXTSIZE(model.original.content, [UIFont systemFontOfSize:10], CGSizeMake(self.view.width - 30 - RYGMessageTableViewCellCommentPhotoHeight - RYGMessageTableViewCellCommentMagin - 10, FLT_MAX), 0);
            CGSize commentTitleSize = RYG_TEXTSIZE(model.original.publish_user_name, [UIFont systemFontOfSize:13]);
            if (commentTitleSize.height + commentSize.height + magin + 4 > RYGMessageTableViewCellCommentPhotoHeight) {
                height = commentTitleSize.height + commentSize.height + magin + 4;
            }
            if (!model.original.pic) {
                height = commentTitleSize.height + commentSize.height + magin + 4;
            }
        }
        else {
            
            CGSize commentSize = RYG_MULTILINE_TEXTSIZE(model.original.content, [UIFont systemFontOfSize:12], CGSizeMake(self.view.width - 30 - RYGMessageTableViewCellCommentPhotoHeight - RYGMessageTableViewCellCommentMagin - 10, FLT_MAX), 0);
            height = commentSize.height + RYGMessageTableViewCellCommentMagin * 2;
        }
        rowHeight += height;
        rowHeight += 15;
        [self.rowHeights addObject:[NSNumber numberWithFloat:rowHeight]];
        return rowHeight;
    }
    
    return [[self.rowHeights objectAtIndex:indexPath.row] floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *replyMeTableViewCell=@"replyMeTableViewCell";
    RYGReplyMeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:replyMeTableViewCell];
    if (!cell) {
        cell=[[RYGReplyMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyMeTableViewCell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    __weak __typeof(&*self)weakSelf = self;
    cell.switchOtherPersonBlock = ^(NSString *userID) {
        [weakSelf clickOtherPerson:userID];
    };
    cell.replyBlock = ^(RYGMessageReplyModel *messageReplyModel) {
        [weakSelf clickReplyButton:messageReplyModel];
    };
    if (self.replyMessageList.count > 0) {
        cell.messageReplyModel = [self.replyMessageList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGMessageReplyModel *model = [self.replyMessageList objectAtIndex:indexPath.row];
    
    [self switchDetailOrCommentView:model.original];
}

#pragma mark-
#pragma mark block
- (void)clickOtherPerson:(NSString *)userId {
    RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
    otherPersonViewController.userId = userId;
    [self.navigationController pushViewController:otherPersonViewController animated:YES];
}

- (void)clickReplyButton:(RYGMessageReplyModel *)messageReplyModel {
    // 是否登录
    if ([RYGUtility isLogin])
    {
        RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
        detailViewController.feed_id = messageReplyModel.original.feed_id;
        detailViewController.cat = messageReplyModel.original.cat;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNSNotification object:nil];
    }
}

// 跳转到帖子详情或者评论
- (void)switchDetailOrCommentView:(RYGOriginalnvitationModel *)original{
    // 类型(int 1:跳帖子详情页 2:跳评论页)
    if ([original.type isEqualToString:@"1"]) {
        RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
        detailViewController.feed_id = original.feed_id;
        detailViewController.cat = original.cat;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        RYGFeedThreadsViewController *feedThreadsViewController = [[RYGFeedThreadsViewController alloc]init];
        feedThreadsViewController.comment_id = original.comment_id;
        feedThreadsViewController.feed_id = original.feed_id;
        [self.navigationController pushViewController:feedThreadsViewController animated:YES];
        
    }
}

@end
