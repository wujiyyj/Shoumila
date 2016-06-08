//
//  RYGPackageEditViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPackageEditViewController.h"
#import "RYGPackageEditParam.h"
#import "RYGHttpRequest.h"
#import "MBProgressHUD+MJ.h"

@interface RYGPackageEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView* mainTableView;
    UIButton* weekButon;
    UIButton* monthButon;
    UITextField* matchNumTextField;
    UITextField* packagePriceTextField;
    
    NSString* service_term;
    UISlider *mySlider;
    UILabel* winRateLabel;
    UILabel* winNumLabel;
}
@end

@implementation RYGPackageEditViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ColorRankMyRankBackground;
    if (_package_id) {
        self.navigationItem.title = @"套餐编辑";
    }
    else {
        self.navigationItem.title = @"套餐创建";
        service_term = @"7";
    }
    
    
    UIButton* saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(SCREEN_WIDTH-35, 26, 40, 20)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self createMainView];
    
}

- (void)saveButton:(UIBarButtonItem*)button {
    [self sendData];
}

- (void)sendData{
    RYGPackageEditParam *packageEditParam = [RYGPackageEditParam param];
    packageEditParam.package_id = _package_id;
    packageEditParam.service_term = service_term;
    packageEditParam.matches = matchNumTextField.text;
    packageEditParam.target_win = [NSString stringWithFormat:@"%d",(int)mySlider.value];
    packageEditParam.fee = packagePriceTextField.text;
    [RYGHttpRequest postWithURL:Package_Add_edit params:packageEditParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
//        NSString* package_id = [dic valueForKey:@"package_id"];
        if ([[json valueForKey:@"code"] intValue] == 0) {
            //  成功
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createMainView {
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    mainTableView.backgroundColor = ColorRankMyRankBackground;
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
    if (indexPath.section == 2) {
        return 73;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
        return 5;
    }
    else if (section == 1) {
        return 2;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //修改UITableview服用重叠的问题
    for(UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray* titleArray = [NSArray arrayWithObjects:@"数据设置",@"服务期限",@"限定场次",@"目标净胜",@"目标胜率", nil];
    
    if (indexPath.section == 0) {
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 85, 20)];
        titleLabel.text = titleArray[indexPath.row];
        if (indexPath.row == 0) {
            titleLabel.textColor = ColorSecondTitle;
            titleLabel.font = [UIFont systemFontOfSize:13];
        }
        else {
            titleLabel.textColor = ColorName;
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row == 4) {
            UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
        }
        else {
            UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.contentView.size.height-0.5, SCREEN_WIDTH-30, 0.5)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
        }
        
        //内容
        if (indexPath.row == 1) {
            weekButon = [UIButton buttonWithType:UIButtonTypeCustom];
            weekButon.frame = CGRectMake(110, 10, 44, 23);
            [weekButon setBackgroundColor:ColorRateTitle];
            [weekButon setTitle:@"7天" forState:UIControlStateNormal];
            [weekButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [weekButon addTarget:self action:@selector(selectWeekBtn) forControlEvents:UIControlEventTouchUpInside];
            weekButon.layer.cornerRadius = 2;
            weekButon.layer.borderWidth = 0.5;
            weekButon.layer.borderColor = ColorRateTitle.CGColor;
            weekButon.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:weekButon];
            
            monthButon = [UIButton buttonWithType:UIButtonTypeCustom];
            monthButon.frame = CGRectMake(174, 10, 44, 23);
            [monthButon setBackgroundColor:[UIColor whiteColor]];
            [monthButon setTitle:@"30天" forState:UIControlStateNormal];
            [monthButon setTitleColor:ColorRateTitle forState:UIControlStateNormal];
            [monthButon addTarget:self action:@selector(selectMonthBtn) forControlEvents:UIControlEventTouchUpInside];
            monthButon.layer.cornerRadius = 2;
            monthButon.layer.borderWidth = 0.5;
            monthButon.layer.borderColor = ColorRateTitle.CGColor;
            monthButon.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:monthButon];
            
            if ([NSString stringWithFormat:@"%@",_service_term] == [NSString stringWithFormat:@"7"]) {
                service_term = @"7";
                
                [weekButon setBackgroundColor:ColorRateTitle];
                [weekButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [monthButon setBackgroundColor:[UIColor whiteColor]];
                [monthButon setTitleColor:ColorRateTitle forState:UIControlStateNormal];
            }
            else if ([NSString stringWithFormat:@"%@",_service_term] == [NSString stringWithFormat:@"30"]) {
                service_term = @"30";
                
                [weekButon setBackgroundColor:[UIColor whiteColor]];
                [weekButon setTitleColor:ColorRateTitle forState:UIControlStateNormal];
                
                [monthButon setBackgroundColor:ColorRateTitle];
                [monthButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }
        else if (indexPath.row == 2) {
            
            matchNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 12, 45, 20)];
            matchNumTextField.textAlignment = NSTextAlignmentCenter;
            matchNumTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            matchNumTextField.font=[UIFont systemFontOfSize:14];
            matchNumTextField.delegate=self;
            matchNumTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            matchNumTextField.borderStyle = UITextBorderStyleLine;
            matchNumTextField.keyboardType = UIKeyboardTypeNumberPad;
            if ([_matches  isEqual: @""] || _matches == nil) {
                
            }
            else {
                matchNumTextField.text = [NSString stringWithFormat:@"%@",_matches];
            }
            [cell.contentView addSubview:matchNumTextField];
            
            UILabel* changLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 12, 85, 20)];
            changLabel.text = @"场";
            changLabel.textColor = ColorName;
            changLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:changLabel];
        }
        else if (indexPath.row == 3) {
            
            winNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 40, 20)];
            if ([_target_win  isEqual: @""] || _target_win == nil) {
                winNumLabel.text = @"0场";
            }
            else {
                winNumLabel.text = [NSString stringWithFormat:@"%@场",_target_win];
            }
            winNumLabel.textAlignment = NSTextAlignmentLeft;
            winNumLabel.textColor = ColorRateTitle;
            winNumLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:winNumLabel];
            
            mySlider = [[UISlider alloc]initWithFrame:CGRectMake(160, 12, SCREEN_WIDTH-175, 20)];
            mySlider.minimumValue = 0.0;//下限
//            mySlider.maximumValue = 20.0;//上限
            if ([_target_win  isEqual: @""] || _target_win == nil) {
                mySlider.value = 0.0;
                mySlider.userInteractionEnabled = NO;
            }
            else {
                mySlider.userInteractionEnabled = YES;
                mySlider.maximumValue = _matches.intValue;
                mySlider.value = _target_win.intValue;
            }
            
            
            [mySlider setThumbImage:[UIImage imageNamed:@"user_red_circle"] forState:UIControlStateNormal];
            [mySlider setThumbImage:[UIImage imageNamed:@"user_red_circle"] forState:UIControlStateHighlighted];
            [mySlider setMinimumTrackImage:[UIImage imageNamed:@"user_red_slider"] forState:UIControlStateNormal];
//            [mySlider setMaximumTrackImage:[UIImage imageNamed:@"user_empty_slider"] forState:UIControlStateNormal];
//            mySlider.minimumTrackTintColor = ColorWin; //滑轮左边颜色如果设置了左边的图片就不会显示
            mySlider.maximumTrackTintColor = [UIColor colorWithWhite:0 alpha:0.3]; //滑轮右边颜色如果设置了右边的图片就不会显示
            [mySlider addTarget:self action:@selector(pressSlider) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:mySlider];
            
        }
        else if (indexPath.row == 4) {
            winRateLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 12, 85, 20)];
            if ([_target_win  isEqual: @""] || _target_win == nil) {
                winRateLabel.text = @"0%";
            }
            else {
                winRateLabel.text = [NSString stringWithFormat:@"%d％",(int)([_target_win floatValue]/[_matches floatValue]*100)];
            }
            
            winRateLabel.textAlignment = NSTextAlignmentLeft;
            winRateLabel.textColor = ColorName;
            winRateLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:winRateLabel];
        }
    }
    else if (indexPath.section == 1) {
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 20)];
        if (indexPath.row == 0) {
            titleLabel.text = @"费用设置";
            titleLabel.textColor = ColorSecondTitle;
            titleLabel.font = [UIFont systemFontOfSize:13];
        }
        else {
            titleLabel.text = @"套餐设置";
            titleLabel.textColor = ColorName;
            titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row == 0) {
            UIView* toplineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            toplineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:toplineView];
            
            UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.contentView.size.height-0.5, SCREEN_WIDTH-30, 0.5)];
            lineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:lineView];
        }
        else {
            
            packagePriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 12, 45, 20)];
            packagePriceTextField.textAlignment = NSTextAlignmentCenter;
            packagePriceTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            packagePriceTextField.font=[UIFont systemFontOfSize:14];
            packagePriceTextField.delegate=self;
            packagePriceTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            packagePriceTextField.borderStyle = UITextBorderStyleLine;
            packagePriceTextField.keyboardType = UIKeyboardTypeNumberPad;
            if ([_fee  isEqual: @""] || _fee == nil) {
                
            }
            else {
                packagePriceTextField.text = [NSString stringWithFormat:@"%@",_fee];
            }
            [cell.contentView addSubview:packagePriceTextField];
            
            UILabel* changLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 12, 85, 20)];
            changLabel.text = @"元";
            changLabel.textColor = ColorName;
            changLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:changLabel];
            
            UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
            bottomlineView.backgroundColor = ColorLine;
            [cell.contentView addSubview:bottomlineView];
        }
    }
    else {
        UIView* toplineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        toplineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:toplineView];
        
        UIImageView* warmImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 14, 14)];
        warmImageView.image = [UIImage imageNamed:@"user_warmInfo"];
        [cell.contentView addSubview:warmImageView];
        
        UILabel* tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, SCREEN_WIDTH-30, 47)];
        tipsLabel.text = @"      温馨提示:当前套餐已在运行，请谨慎修改，修改后，直到最后一个服务人员完成套餐约定后，方可生效。";
        tipsLabel.numberOfLines = 0;
        tipsLabel.textColor = ColorRankMedal;
        tipsLabel.font = [UIFont boldSystemFontOfSize:13];
        [cell.contentView addSubview:tipsLabel];
        
        UIView* bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
        bottomlineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:bottomlineView];
    }
    
    return cell;
}

- (void)selectWeekBtn
{
    service_term = @"7";
    
    [weekButon setBackgroundColor:ColorRateTitle];
    [weekButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [monthButon setBackgroundColor:[UIColor whiteColor]];
    [monthButon setTitleColor:ColorRateTitle forState:UIControlStateNormal];
}

- (void)selectMonthBtn
{
    service_term = @"30";
    
    [weekButon setBackgroundColor:[UIColor whiteColor]];
    [weekButon setTitleColor:ColorRateTitle forState:UIControlStateNormal];
    
    [monthButon setBackgroundColor:ColorRateTitle];
    [monthButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)pressSlider
{
    NSLog(@"count = %f",mySlider.value);
    int count = (int)mySlider.value;
    int mainCount = matchNumTextField.text.intValue;
    
    mySlider.maximumValue = mainCount;
    
    if (mainCount>99) {
        [MBProgressHUD showError:@"最大限定场次为99"];
        mySlider.userInteractionEnabled = NO;
    }
    else {
        mySlider.userInteractionEnabled = YES;
    }
    
    winNumLabel.text = [NSString stringWithFormat:@"%d场",count];
    winRateLabel.text = [NSString stringWithFormat:@"%d％",(int)((float)count/(float)mainCount*100)];
//    [mainTableView reloadData];
}

#pragma mark - Textfield Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (SCREEN_HEIGHT<=568) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"text = %@",matchNumTextField.text);
    NSInteger count = matchNumTextField.text.integerValue;
    NSInteger successCount = (int)mySlider.value;
    
    if (count>99) {
        [MBProgressHUD showError:@"最大限定场次为99"];
        mySlider.userInteractionEnabled = NO;
        return NO;
    }
    
    winRateLabel.text = [NSString stringWithFormat:@"%d％",(int)((float)successCount/(float)count*100)];
    
    mySlider.maximumValue = count;
    mySlider.userInteractionEnabled = YES;
    [mainTableView reloadData];
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    NSInteger count = matchNumTextField.text.integerValue;
    if (count>99) {
        [MBProgressHUD showError:@"最大限定场次为99"];
        mySlider.userInteractionEnabled = NO;
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
