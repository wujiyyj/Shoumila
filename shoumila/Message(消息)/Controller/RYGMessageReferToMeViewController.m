//
//  RYGReferToMeViewController.m
//  提到我的消息
//
//  Created by jiaocx on 15/8/21.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGMessageReferToMeViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "RYGHttpRequest.h"
#import "RYGUserCenterViewController.h"
#import "RYGReferToMeTableViewCell.h"
#import "RYGMessageRequestParam.h"
#import "RYGHttpRequest.h"
#import "RYGMessageReferToMeInfosModel.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGFeedThreadsViewController.h"

@interface RYGMessageReferToMeViewController ()<UITableViewDataSource,UITableViewDelegate>

// 提到我的消息列表
@property(nonatomic,strong)UITableView *referMessageTableView;
// 下一页的标识
@property(nonatomic,strong)NSString *next;
// 提到我的数据
@property(nonatomic,strong)NSMutableArray *referMessageList;
// 是否有更多数据
@property(nonatomic,assign) BOOL isMoreData;
// 行高
@property(nonatomic,strong)NSMutableArray *rowHeights;

@property(nonatomic,strong)RYGMessageReferToMeInfosModel *messageReferToMeInfosModel;

@end

@implementation RYGMessageReferToMeViewController

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提到我的";
    _referMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    _referMessageTableView.delegate = self;
    _referMessageTableView.dataSource = self;
    _referMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _referMessageTableView.backgroundColor = ColorRankBackground;
    [self.view addSubview:_referMessageTableView];
    
    __weak __typeof(&*self)weakself = self;
    [self.referMessageTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [self.referMessageTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _rowHeights = [[NSMutableArray alloc]init];
    [self aRefresh];
    
    [MobClick beginLogPageView:@"提到我的"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"提到我的"];
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
    _referMessageList = [NSMutableArray array];
    _next = 0;
    _isMoreData = YES;
    [self loadData];
}

- (void)loadData {
    
    RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
    messageRequestParam.next = _next;
    [RYGHttpRequest postWithURL:Message_Refer_To_Me params:messageRequestParam.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.messageReferToMeInfosModel = [RYGMessageReferToMeInfosModel objectWithKeyValues:dic];
        [self.referMessageList addObjectsFromArray:self.messageReferToMeInfosModel.datas];
        _next = self.messageReferToMeInfosModel.next;
        // 没有加载更多
        if (self.messageReferToMeInfosModel.page_is_last || [self.messageReferToMeInfosModel.page_is_last isEqualToString:@"0"]) {
            _isMoreData = NO;
        }
        [self.referMessageTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 更新排行榜的列表

- (void)reloadRankingTable {
    // 是否登录
    [self.referMessageTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.referMessageTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.referMessageTableView reloadData];
}

#pragma mark-
#pragma mark UITableViewDataSource UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.referMessageList && self.referMessageList.count>0) {
        return self.referMessageList.count;
    }
    return 0;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYGMessageReferToMeModel *model = [self.referMessageList objectAtIndex:indexPath.row];
    
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
    static NSString *referToMeTableViewCell=@"referToMeTableViewCell";
    RYGReferToMeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:referToMeTableViewCell];
    if (!cell) {
        cell=[[RYGReferToMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:referToMeTableViewCell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    __weak __typeof(&*self)weakSelf = self;
    cell.switchOtherPersonBlock = ^(NSString *userID) {
        [weakSelf clickOtherPerson:userID];
    };
    if (self.referMessageList.count > 0) {
        cell.messageReferToMeModel = [self.referMessageList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGMessageReferToMeModel *model = [self.referMessageList objectAtIndex:indexPath.row];
    
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
