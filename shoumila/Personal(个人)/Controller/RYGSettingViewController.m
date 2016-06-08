//
//  RYGSettingViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/1.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSettingViewController.h"
#import "UIImageView+RYGWebCache.h"
#import "RYGPersonInfoViewController.h"
#import "RYGAboutUsViewController.h"
#import "RYGBlackListViewController.h"
#import "RYGLoginViewController.h"
#import "RYGPushNotificationViewController.h"
#import "RYGVirtualAccountViewController.h"
#import "RYGHttpRequest.h"
#import "RYGAllListParam.h"
#import "RYGDynamicShareHandler.h"
#import "RYGShareContentModel.h"
#import "UMFeedbackViewController.h"
#import "RYGDynamicDetailViewController.h"
#import "RYGUtility.h"

@interface RYGSettingViewController ()<UIAlertViewDelegate>
{
    UITableView* mainTableView;
    NSString* money;
    NSString* share_url;
    NSString* user_name;
    NSString* user_logo;
}
@end

@implementation RYGSettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置"];
    
    if (![RYGUtility validateUserLogin]) {
        return;
    }
    
    [self loadNewData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"设置";
    
}

- (void)loadNewData{
    RYGAllListParam *listParam = [RYGAllListParam param];
//    listParam.userid = @"";
    [RYGHttpRequest postWithURL:User_UserMoney params:listParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        money = [dic valueForKey:@"money"];
        share_url = [dic valueForKey:@"share_url"];
        user_name = [dic valueForKey:@"user_name"];
        user_logo = [dic valueForKey:@"avatar"];
        
        [self createMainView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createMainView {
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 10*7+44*8+100);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = YES;
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

- (void)goLogout
{
    RYGAllListParam *listParam = [RYGAllListParam param];
    [RYGHttpRequest postWithURL:User_Logout params:listParam.keyValues success:^(id json) {
                
        if ([[json valueForKey:@"code"] intValue] == 0) {
            RYGUserInfoModel *userInfoModel = [RYGUtility getUserInfo];
            userInfoModel.token = @"";
            NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
            [NSKeyedArchiver archiveRootObject:userInfoModel toFile:path];
            
            
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
            [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
            [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
            //退出成功
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    else if (indexPath.section == 8) {
        return 65;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5) {
        return 2;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section != 8) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.contentView.backgroundColor = ColorRankMyRankBackground;
    }
    
    //修改UITableview服用重叠的问题
    for(UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray* titleArray = [NSArray arrayWithObjects:@"我的帐户",@"设置推送通知",@"邀请好友",@"管理黑名单",@"意见反馈",@"关于我们",@"清除缓存",@"联系客服", nil];
    NSArray* contentArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@元",money],@"",@"",@"",@"",@"",@"",@"", nil];
    
    if (indexPath.section == 0) {
        UIImageView* photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 70, 70)];
        [photoImageView setImageURLStr:user_logo placeholder:[UIImage imageNamed:@"user_head"]];
        photoImageView.layer.masksToBounds = YES;
        photoImageView.layer.cornerRadius = 35;
        photoImageView.layer.borderWidth = 3;
        photoImageView.layer.borderColor = ColorGreen.CGColor;
        [cell.contentView addSubview:photoImageView];
        
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 120, 20)];
        nameLabel.text = [NSString stringWithFormat:@"%@",user_name];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = ColorName;
        [cell.contentView addSubview:nameLabel];
        
        UIImageView* arr_icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-23, 14, 8, 14)];
        arr_icon.centerY = 50;
        arr_icon.image = [UIImage imageNamed:@"user_arrow"];
        [cell.contentView addSubview:arr_icon];
    }
    
    if (indexPath.section != 0 && indexPath.section != 8) {
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 20)];
        if (indexPath.section >= 6) {
            titleLabel.text = titleArray[indexPath.section];
        }
        else {
            titleLabel.text = titleArray[indexPath.section-1+indexPath.row];
        }
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = ColorName;
        [cell.contentView addSubview:titleLabel];
    }
    if (indexPath.section == 8) {
        cell.backgroundColor = ColorRankMyRankBackground;
        
        UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        exitBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 10, 290*SCREEN_SCALE, 40);
        exitBtn.layer.cornerRadius = 5;
        [exitBtn setBackgroundColor:ColorRateTitle];
        [exitBtn setTitle:@"登出" forState:UIControlStateNormal];
        [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        exitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [exitBtn addTarget:self action:@selector(goLogout) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:exitBtn];
    }
    
    if (indexPath.section == 5 && indexPath.row != 1) {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.contentView.size.height-0.5, SCREEN_WIDTH-30, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    else if (indexPath.section != 8){
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    if (indexPath.section != 8 && indexPath.row == 0) {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    
    if (indexPath.section != 0 && indexPath.section != 8) {
        UIImageView* arr_icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-23, 14, 8, 14)];
        arr_icon.image = [UIImage imageNamed:@"user_arrow"];
        [cell.contentView addSubview:arr_icon];
    }
    
    if (indexPath.section != 0) {
        UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-238, 12, 200, 20)];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.text = contentArray[indexPath.section-1+indexPath.row];
        if (indexPath.section == 1) {
            contentLabel.textColor = ColorRankMenuBackground;
            contentLabel.font = [UIFont systemFontOfSize:14];
        }
        else if (indexPath.section == 3) {
            contentLabel.textColor = ColorRateTitle;
            contentLabel.font = [UIFont boldSystemFontOfSize:12];
        }
        [cell.contentView addSubview:contentLabel];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"row = %ld",indexPath.row);
    if (indexPath.section == 0) {
        //我的小球王
        RYGPersonInfoViewController* personInfo = [[RYGPersonInfoViewController alloc]init];
        [self.navigationController pushViewController:personInfo animated:YES];
        
    }
    else if (indexPath.section == 1) {
        //我的帐户
        RYGVirtualAccountViewController* virtualAccountVC = [[RYGVirtualAccountViewController alloc]init];
        virtualAccountVC.money = money;
        [self.navigationController pushViewController:virtualAccountVC animated:YES];
        
    }
    else if (indexPath.section == 2) {
        //设置推送通知
        RYGPushNotificationViewController* pushNotification = [[RYGPushNotificationViewController alloc]init];
        [self.navigationController pushViewController:pushNotification animated:YES];
    }
    else if (indexPath.section == 3) {
        //邀请好友
        
        RYGShareContentModel *model = [[RYGShareContentModel alloc]init];
        model.shareUrl = share_url;
        model.mediaType = SSPublishContentMediaTypeNews;
        RYGDynamicShareHandler *handler = [[RYGDynamicShareHandler alloc]init];
        handler.contentModel = model;
//        [RYGDynamicShareHandler shareViewModel:model];
        [handler showShareView];
        
    }
    else if (indexPath.section == 4) {
        //管理黑名单
        //跳转黑名单
        RYGBlackListViewController* blackListController = [[RYGBlackListViewController alloc]init];
        [self.navigationController pushViewController:blackListController animated:YES];
    }
    else if (indexPath.section == 5 && indexPath.row == 0) {
        //意见反馈
        RYGDynamicDetailViewController *detailViewController = [[RYGDynamicDetailViewController alloc]init];
        detailViewController.feed_id = @"1";
        detailViewController.cat = @"1";
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if (indexPath.section == 5 && indexPath.row == 1) {
        //关于我们
        RYGAboutUsViewController* aboutUs = [[RYGAboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }
    else if (indexPath.section == 6) {
        //清除缓存
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清除当前缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
    else if (indexPath.section == 7) {
        //联系客服
        [self.navigationController pushViewController:[UMFeedbackViewController new]
                                             animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] cleanDisk];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
