//
//  RYGReportViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/10/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGReportViewController.h"
#import "MBProgressHUD+MJ.h"
#import "RYGHttpRequest.h"
#import "RYGReportParam.h"

@interface RYGReportViewController ()
@property(nonatomic,strong) NSArray *reportArray;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,assign) BOOL reportSuccess;
@end

@implementation RYGReportViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        _reportArray = [NSArray arrayWithObjects:@"广告，恶意灌水",@"带有攻击性不友善内容",@"色情，侵犯个人隐私",@"违法，不易公开内容", nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"举报"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"举报"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    
    [_reportArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self setUpitemWithTitle:obj tag:idx+1 top:idx*62];
    }];

}

- (void)setUpitemWithTitle:(NSString *)title tag:(NSInteger)tag top:(float)top{
    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 62)];
    itemView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 280, 62)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = ColorName;
    [itemView addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 36, 20, 21, 21)];
    [btn setBackgroundImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"report_sel"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(selectReport:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    [itemView addSubview:btn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 61, SCREEN_WIDTH, 1)];
    line.backgroundColor = ColorLine;
    [itemView addSubview:line];
    
    [self.view addSubview:itemView];
    
}

- (void)selectReport:(UIButton *)selectBtn{
    _selectBtn.selected = NO;
    selectBtn.selected = YES;
    _selectBtn = selectBtn;
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_reportSuccess) {
            [MBProgressHUD showSuccess:@"举报成功"];
        }
    }];
}

- (void)submit{
    if (_selectBtn) {
        NSInteger index = _selectBtn.tag - 1;
        NSString *reportContent = _reportArray[index];
        RYGReportParam *param = [RYGReportParam param];
        param.reason = reportContent;
        param.feed_id = _feed_id;
        param.userid = _user_id;
        [RYGHttpRequest getWithURL:User_report params:[param keyValues] success:^(id json) {
            _reportSuccess = YES;
        } failure:^(NSError *error) {
            
        }];
    }else{
        [MBProgressHUD showError:@"举报不能为空"];
        return;
    }
    [self cancel];
}
@end
