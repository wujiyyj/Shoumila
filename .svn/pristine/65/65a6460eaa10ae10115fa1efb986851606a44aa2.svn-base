//
//  RYGAttendedPersonDynamicMessageViewController.m
//  被关注的人的动态消息界面
//
//  Created by jiaocx on 15/8/24.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGAttendedPersonDynamicMessageViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "RYGHttpRequest.h"
#import "RYGAttendedPersonDynamicMessageTableViewCell.h"
#import "RYGUserCenterViewController.h"
#import "RYGMessageRequestParam.h"
#import "RYGHttpRequest.h"
#import "RYGAttendedPersonDynamicMessageInfosModel.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGFeedThreadsViewController.h"

@interface RYGAttendedPersonDynamicMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

// 回复我的消息列表
@property(nonatomic,strong)UITableView *dynamicMessageTableView;
// 下一页的标识
@property(nonatomic,strong)NSString *next;
// 关注的人的动态消息的数据
@property(nonatomic,strong)NSMutableArray *dynamicMessageList;
// 是否有更多数据
@property(nonatomic,assign) BOOL isMoreData;
// 行高
@property(nonatomic,strong)NSMutableArray *rowHeights;

@property(nonatomic,strong)RYGAttendedPersonDynamicMessageInfosModel *attendedPersonDynamicMessageInfosModel;

@end

@implementation RYGAttendedPersonDynamicMessageViewController

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.messageTitle;
    _dynamicMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    _dynamicMessageTableView.delegate = self;
    _dynamicMessageTableView.dataSource = self;
    _dynamicMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dynamicMessageTableView.backgroundColor = ColorRankBackground;
    [self.view addSubview:_dynamicMessageTableView];
    
    __weak __typeof(&*self)weakself = self;
    [self.dynamicMessageTableView addLegendHeaderWithRefreshingBlock:^{
        [weakself aRefresh];
    }];
    __weak __typeof(&*self)weakself1 = self;
    [self.dynamicMessageTableView addLegendFooterWithRefreshingBlock:^{
        [weakself1 loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _rowHeights = [[NSMutableArray alloc]init];
    [self aRefresh];
    
    [self.tabBarController.tabBar setHidden:YES];
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
    _dynamicMessageList = [NSMutableArray array];
    _next = 0;
    _isMoreData = YES;
    [self loadData];
}

- (void)loadData {
    _dynamicMessageList = [[NSMutableArray alloc]init];
    
    RYGMessageRequestParam *messageRequestParam = [RYGMessageRequestParam param];
    messageRequestParam.next = _next;
    messageRequestParam.from_id = self.from_id;
    [RYGHttpRequest postWithURL:Message_Atteded_Person_Dynamic params:messageRequestParam.keyValues success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        self.attendedPersonDynamicMessageInfosModel = [RYGAttendedPersonDynamicMessageInfosModel objectWithKeyValues:dic];
        [self.dynamicMessageList addObjectsFromArray:self.attendedPersonDynamicMessageInfosModel.datas];
        _next = self.attendedPersonDynamicMessageInfosModel.next;
        // 没有加载更多
        if (self.attendedPersonDynamicMessageInfosModel.page_is_last || [self.attendedPersonDynamicMessageInfosModel.page_is_last isEqualToString:@"0"]) {
            _isMoreData = NO;
        }
        [self.dynamicMessageTableView.header setState:MJRefreshHeaderStateIdle];
        [self reloadRankingTable];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 更新排行榜的列表

- (void)reloadRankingTable {
    // 是否登录
    [self.dynamicMessageTableView.footer endRefreshing];
    if (!_isMoreData) {
        [self.dynamicMessageTableView.footer setState:MJRefreshFooterStateNoMoreData];
    }
    [self.dynamicMessageTableView reloadData];
}

#pragma mark-
#pragma mark UITableViewDataSource UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dynamicMessageList && self.dynamicMessageList.count>0) {
        return self.dynamicMessageList.count;
    }
    return 0;
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYGAttendedPersonDynamicMessageModel *model = [self.dynamicMessageList objectAtIndex:indexPath.row];
    
    CGFloat rowHeight = 15 + 32 + 15;
    
    if (indexPath.row >= [self.rowHeights count]) {
        CGFloat commentMagin = 0;
        // 0:普通帖子 1:赛前 2:滚球
        if ([model.data.type isEqualToString:@"1"]) {
            commentMagin = 32 + 8;
        }
        
        NSMutableString *content = [[NSMutableString alloc]init];
        // 普通动态,赛事动态 评论内容+图片
        if ([model.type isEqualToString:@"14"]) {
            for (int i = 0; i < model.data.text_content.count; i++) {
                RYGDynamicConetentModel *conentModel = [model.data.text_content objectAtIndex:i];
                [content appendString:conentModel.text];
            }
        }
        else {
            content =  (NSMutableString *)model.data.content;
        }
        CGFloat maxWidth = self.view.width - 30 - commentMagin - 15;
        CGSize commentSize = RYG_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:14], CGSizeMake(maxWidth, FLT_MAX), NSLineBreakByWordWrapping);

        CGFloat picHeight = commentSize.height;
        // 普通动态,赛事动态 评论内容+图片
        if ([model.type isEqualToString:@"13"] && model.data.pics && model.data.pics.count > 0) {
            picHeight += 54 + 10;
        }
        rowHeight += picHeight;
        rowHeight += 40;
        [self.rowHeights addObject:[NSNumber numberWithFloat:rowHeight]];
        return rowHeight;
    }
    
    return [[self.rowHeights objectAtIndex:indexPath.row] floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *attendedPersonDynamicMessageViewCell=@"attendedPersonDynamicMessageViewCell";
    RYGAttendedPersonDynamicMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:attendedPersonDynamicMessageViewCell];
    if (!cell) {
        cell=[[RYGAttendedPersonDynamicMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attendedPersonDynamicMessageViewCell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    __weak __typeof(&*self)weakSelf = self;
    cell.switchOtherPersonBlock = ^(NSString *userID) {
        [weakSelf clickOtherPerson:userID];
    };
    if (self.dynamicMessageList.count > 0) {
        cell.attendedPersonDynamicMessageModel = [self.dynamicMessageList objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RYGAttendedPersonDynamicMessageModel *model = [self.dynamicMessageList objectAtIndex:indexPath.row];

    [self switchDetailOrCommentView:model];
}

#pragma mark-
#pragma mark block
- (void)clickOtherPerson:(NSString *)userId {
    RYGUserCenterViewController *otherPersonViewController = [[RYGUserCenterViewController alloc]init];
    otherPersonViewController.userId = userId;
    [self.navigationController pushViewController:otherPersonViewController animated:YES];
}

// 跳转到帖子详情或者评论
// 跳转到帖子详情或者评论
- (void)switchDetailOrCommentView:(RYGAttendedPersonDynamicMessageModel *)original{
    // 类型(int 1:跳帖子详情页 2:跳评论页)
    //TODOBUG  收到的type 是13
    if ([original.type isEqualToString:@"13"]) {
        RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
        detailViewController.feed_id = original.data.feed_id;
        detailViewController.cat = original.data.cat;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        RYGFeedThreadsViewController *feedThreadsViewController = [[RYGFeedThreadsViewController alloc]init];
        feedThreadsViewController.comment_id = original.message_id;
        feedThreadsViewController.feed_id = original.feed_id;
        [self.navigationController pushViewController:feedThreadsViewController animated:YES];
    }
}

@end
