//
//  RYGMessagePraiseMeViewController.m
//  shoumila
//
//  Created by jiaocx on 15/8/21.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessagePraiseMeViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "RYGHttpRequest.h"
#import "RYGMessagePraiseMeTableViewCell.h"
#import "RYGMessageRequestParam.h"
#import "RYGHttpRequest.h"
#import "RYGMessagePraiseInfosModel.h"
#import "RYGUserCenterViewController.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGFeedThreadsViewController.h"

@interface RYGMessagePraiseMeViewController ()<UITableViewDataSource,UITableViewDelegate>

// 赞过我的消息列表
@property(nonatomic,strong)UITableView *praiseMessageTableView;
// 下一页的标识
@property(nonatomic,strong)NSString *next;
// 赞过我的数据
@property(nonatomic,strong)NSMutableArray *praiseMessageList;
// 是否有更多数据
@property(nonatomic,assign) BOOL isMoreData;
// 行高
@property(nonatomic,strong)NSMutableArray *rowHeights;

@property(nonatomic,strong)RYGMessagePraiseInfosModel *messagePraiseInfosModel;

@end

@implementation RYGMessagePraiseMeViewController

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"赞过我的";
    _praiseMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    _praiseMessageTableView.delegate = self;
    _praiseMessageTableView.dataSource = self;
    _praiseMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _praiseMessageTableView.backgroundColor = ColorRankBackground;
    [self.view addSubview:_praiseMessageTableView];
    
    __weak __typeof(&*self)weakself = self;
    [self.praiseMessageTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [self.praiseMessageTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _rowHeights = [[NSMutableArray alloc]init];
    [self aRefresh];
    
    [MobClick beginLogPageView:@"赞过我的"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"赞过我的"];
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
    _praiseMessageList = [NSMutableArray array];
    _next = 0;
    _isMoreData = YES;
    [self loadData];
}

- (void)loadData {
    RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
    messageRequestParam.next = _next;
    [RYGHttpRequest postWithURL:Message_Praise_Me params:messageRequestParam.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.messagePraiseInfosModel = [RYGMessagePraiseInfosModel objectWithKeyValues:dic];
        [self.praiseMessageList addObjectsFromArray:self.messagePraiseInfosModel.datas];
        _next = self.messagePraiseInfosModel.next;
        // 没有加载更多
        if (self.messagePraiseInfosModel.page_is_last || [self.messagePraiseInfosModel.page_is_last isEqualToString:@"0"]) {
            _isMoreData = NO;
        }
        [self.praiseMessageTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 更新排行榜的列表

- (void)reloadRankingTable {
    // 是否登录
    [self.praiseMessageTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.praiseMessageTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.praiseMessageTableView reloadData];
}

#pragma mark-
#pragma mark UITableViewDataSource UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.praiseMessageList && self.praiseMessageList.count>0) {
        return self.praiseMessageList.count;
    }
    return 0;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYGMessagePraiseModel *model = [self.praiseMessageList objectAtIndex:indexPath.row];
    
    CGFloat rowHeight = 15 + 32 + 15;
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
    static NSString *messagePraiseMeTableViewCell = @"messagePraiseMeTableViewCell";
    RYGMessagePraiseMeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:messagePraiseMeTableViewCell];
    if (!cell) {
        cell=[[RYGMessagePraiseMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messagePraiseMeTableViewCell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    __weak __typeof(&*self)weakSelf = self;
    cell.switchOtherPersonBlock = ^(NSString *userID) {
        [weakSelf clickOtherPerson:userID];
    };
    
    if (self.praiseMessageList.count > 0) {
        cell.messagePraiseModel = [self.praiseMessageList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGMessagePraiseModel *model = [self.praiseMessageList objectAtIndex:indexPath.row];
    
    [self switchDetailOrCommentView:model.original];
}

#pragma mark-
#pragma mark block
- (void)clickOtherPerson:(NSString *)userId {
    RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
    otherPersonViewController.userId = userId;
    [self.navigationController pushViewController:otherPersonViewController animated:YES];
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
