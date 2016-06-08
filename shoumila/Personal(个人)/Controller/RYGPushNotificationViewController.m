//
//  RYGPushNotificationViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/2.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPushNotificationViewController.h"
#import "RYGAllListParam.h"
#import "RYGHttpRequest.h"
#import "RYGPushSettingListModel.h"
#import "RYGPushSettingParam.h"
#import "MBProgressHUD+MJ.h"

@interface RYGPushNotificationViewController ()
{
    UITableView* mainTableView;
    
    UIButton* finishButton;
    UIDatePicker *datePicker1;
    UIDatePicker *datePicker2;
    
    NSString* push_Str;
    NSString* push_at_Str;
    NSString* push_attention_Str;
    NSString* push_comment_Str;
    NSString* push_praise_Str;
    NSString* push_subscribe_Str;
    NSString* push_system__Str;
    NSString* push_stime_Str;
    NSString* push_etime_Str;
}

@property(nonatomic,strong) RYGPushSettingListModel* pushSettingListModel;

@end

@implementation RYGPushNotificationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"推送设置"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"推送设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"设置推送通知";
    push_Str = @"1";
    push_at_Str = @"1";
    push_attention_Str = @"1";
    push_comment_Str = @"1";
    push_praise_Str = @"1";
    push_subscribe_Str = @"1";
    push_system__Str = @"1";
    push_stime_Str = @"0";
    push_etime_Str = @"24";
    
    [self loadNewData];
}

- (void)loadNewData{
    RYGAllListParam *allListParam = [RYGAllListParam param];
    [RYGHttpRequest postWithURL:User_PushSettingList params:allListParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        _pushSettingListModel = [RYGPushSettingListModel objectWithKeyValues:dic];
        
        push_Str = _pushSettingListModel.push;
        push_at_Str = _pushSettingListModel.push_at;
        push_attention_Str = _pushSettingListModel.push_attention;
        push_comment_Str = _pushSettingListModel.push_comment;
        push_etime_Str = _pushSettingListModel.push_etime;
        push_praise_Str = _pushSettingListModel.push_praise;
        push_stime_Str = _pushSettingListModel.push_stime;
        push_subscribe_Str = _pushSettingListModel.push_subscribe;
        push_system__Str = _pushSettingListModel.push_system;
        
        [self reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData{
    [self createMainView];
}

- (void)createMainView {
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*2+44*8) style:UITableViewStylePlain];
    mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 10*2+44*8);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = YES;
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 4;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = ColorRankBackground;
    
    //修改UITableview服用重叠的问题
    for(UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray* titleArray = [NSArray arrayWithObjects:@"推送开关",@"接收推送时段",@"我关注的",@"我订阅的",@"系统通知",@"点赞",@"回复我的",@"@我的", nil];
    
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 20)];
    titleLabel.text = titleArray[indexPath.section*2+indexPath.row];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = ColorName;
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.section != 2 && indexPath.row != 1) {
        UIView* top_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        top_lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:top_lineView];
        
        UIView* middle_lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.contentView.size.height-0.5, SCREEN_WIDTH-30, 0.5)];
        middle_lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:middle_lineView];
    }
    else if (indexPath.section != 2 && indexPath.row == 1){
        UIView* bottom_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
        bottom_lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:bottom_lineView];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIView* top_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        top_lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:top_lineView];
    }
    if (indexPath.section == 2 && indexPath.row != 3) {
        UIView* middle_lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.contentView.size.height-0.5, SCREEN_WIDTH-30, 0.5)];
        middle_lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:middle_lineView];
    }
    else if (indexPath.row == 3) {
        UIView* bottom_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
        bottom_lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:bottom_lineView];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-238, 12, 200, 20)];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.text = [NSString stringWithFormat:@"%@:00-%@:00",_pushSettingListModel.push_stime,_pushSettingListModel.push_etime];
        contentLabel.textColor = ColorRankMenuBackground;
        contentLabel.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:contentLabel];
        
        UIImageView* arr_icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-23, 14, 8, 14)];
        arr_icon.image = [UIImage imageNamed:@"user_arrow"];
        [cell.contentView addSubview:arr_icon];
    }
    else {
        NSInteger tagNum = indexPath.section*2+indexPath.row;
        BOOL switchbool = YES;      //设置初始为ON的一边
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 6, 50, 24)];
        if (tagNum == 0 && _pushSettingListModel.push.intValue == 1) {
            switchbool = YES;
        }
        else if (tagNum == 2 && _pushSettingListModel.push_attention.intValue == 1) {
            switchbool = YES;
        }
        else if (tagNum == 3 && _pushSettingListModel.push_subscribe.intValue == 1) {
            switchbool = YES;
        }
        else if (tagNum == 4 && _pushSettingListModel.push_system.intValue == 1) {
            switchbool = YES;
        }
        else if (tagNum == 5 && _pushSettingListModel.push_praise.intValue == 1) {
            switchbool = YES;
        }
        else if (tagNum == 6 && _pushSettingListModel.push_comment.intValue == 1) {
            switchbool = YES;
        }
        else if (tagNum == 7 && _pushSettingListModel.push_at.intValue == 1) {
            switchbool = YES;
        }
        else {
            switchbool = NO;
        }
        
        switchView.on = switchbool;
        switchView.tag = tagNum;
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchView];
    }
    
    return cell;
}

- (void)switchAction:(id)sender
{
    UISwitch *swithch = (UISwitch *)sender;
    BOOL setting = swithch.isOn;
    if (swithch.tag == 0 && setting == YES) {
        push_Str = @"1";
    }
    else if (swithch.tag == 2 && setting == YES) {
        push_attention_Str = @"1";
    }
    else if (swithch.tag == 3 && setting == YES) {
        push_subscribe_Str = @"1";
    }
    else if (swithch.tag == 4 && setting == YES) {
        push_system__Str = @"1";
    }
    else if (swithch.tag == 5 && setting == YES) {
        push_praise_Str = @"1";
    }
    else if (swithch.tag == 6 && setting == YES) {
        push_comment_Str = @"1";
    }
    else if (swithch.tag == 7 && setting == YES) {
        push_at_Str = @"1";
    }
    
    if (swithch.tag == 0 && setting == NO) {
        push_Str = @"0";
        push_attention_Str = @"0";
        push_subscribe_Str = @"0";
        push_system__Str = @"0";
        push_praise_Str = @"0";
        push_comment_Str = @"0";
        push_at_Str = @"0";
        
    }
    else if (swithch.tag == 2 && setting == NO) {
        push_attention_Str = @"0";
    }
    else if (swithch.tag == 3 && setting == NO) {
        push_subscribe_Str = @"0";
    }
    else if (swithch.tag == 4 && setting == NO) {
        push_system__Str = @"0";
    }
    else if (swithch.tag == 5 && setting == NO) {
        push_praise_Str = @"0";
    }
    else if (swithch.tag == 6 && setting == NO) {
        push_comment_Str = @"0";
    }
    else if (swithch.tag == 7 && setting == NO) {
        push_at_Str = @"0";
    }
    
    RYGPushSettingParam *pushSettingParam = [RYGPushSettingParam param];
    pushSettingParam.push = push_Str;
    pushSettingParam.push_praise = push_praise_Str;
    pushSettingParam.push_comment = push_comment_Str;
    pushSettingParam.push_at = push_at_Str;
    pushSettingParam.push_system = push_system__Str;
    pushSettingParam.push_attention = push_attention_Str;
    pushSettingParam.push_subscribe = push_subscribe_Str;
    pushSettingParam.push_stime = push_stime_Str;
    pushSettingParam.push_etime = push_etime_Str;
    [RYGHttpRequest postWithURL:User_PushSetting params:pushSettingParam.keyValues success:^(id json) {
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            [swithch setOn:setting animated:YES];
            
            [self loadNewData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        //修改接收时段推送
        
        datePicker1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-216,SCREEN_WIDTH/2,216)];
        datePicker1.frame = CGRectMake(0,SCREEN_HEIGHT-216,SCREEN_WIDTH/2,216);
        datePicker1.backgroundColor = [UIColor whiteColor];
        datePicker1.datePickerMode = UIDatePickerModeTime;
        
        //创建时间格式化实例对象
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        //设置时间格式
        [dateFormatter1 setDateFormat:@"HH"];
        NSDate *tempDate1 = [dateFormatter1 dateFromString:[NSString stringWithFormat:@"%@",_pushSettingListModel.push_stime]];
        [datePicker1 setDate:tempDate1];
        
        datePicker1.minuteInterval = 30;
        datePicker1.tag = 1;
        datePicker1.hidden = NO;
        [datePicker1 addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [self.view addSubview:datePicker1];
        
        datePicker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-216,SCREEN_WIDTH/2,216)];
        datePicker2.frame = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-216,SCREEN_WIDTH/2,216);
        datePicker2.backgroundColor = [UIColor whiteColor];
        datePicker2.datePickerMode = UIDatePickerModeTime;
        
        //创建时间格式化实例对象
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        //设置时间格式
        [dateFormatter2 setDateFormat:@"HH"];
        if (_pushSettingListModel.push_etime.intValue >= 24) {
            NSDate *tempDate2 = [dateFormatter2 dateFromString:@"0"];
            [datePicker2 setDate:tempDate2];
        }
        else {
            NSDate *tempDate2 = [dateFormatter2 dateFromString:[NSString stringWithFormat:@"%@",_pushSettingListModel.push_etime]];
            [datePicker2 setDate:tempDate2];
        }
        
        datePicker2.minuteInterval = 30;
        datePicker2.tag = 2;
        datePicker2.hidden = NO;
        [datePicker2 addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [self.view addSubview:datePicker2];
        
        finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-246, 60, 30);
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(pressFinish) forControlEvents:UIControlEventTouchUpInside];
        finishButton.hidden = NO;
        [self.view addSubview:finishButton];
    }
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* myDate = control.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    
    /*添加你自己响应代码*/
    if (control.tag == 1) {
        NSLog(@"-- %@",prettyVersion);
        push_stime_Str = prettyVersion;
    }
    else if (control.tag == 2) {
        NSLog(@"== %@",prettyVersion);
        push_etime_Str = prettyVersion;
    }
}

- (void)pressFinish {
    
    finishButton.hidden = YES;
    datePicker1.hidden = YES;
    datePicker2.hidden = YES;
    
    if (push_stime_Str.intValue!= 0 && push_etime_Str.intValue != 0 && push_stime_Str.intValue == push_etime_Str.intValue) {
        [MBProgressHUD showError:@"起始时间不能与结束时间相同"];
    }
    else {
        
        RYGPushSettingParam *pushSettingParam = [RYGPushSettingParam param];
        pushSettingParam.push_stime = push_stime_Str;
        pushSettingParam.push_etime = push_etime_Str;
        [RYGHttpRequest postWithURL:User_PushSetting params:pushSettingParam.keyValues success:^(id json) {
            
            if ([[json valueForKey:@"code"] intValue] == 0) {            
                [self loadNewData];
            }
            
        } failure:^(NSError *error) {
            
        }];
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
