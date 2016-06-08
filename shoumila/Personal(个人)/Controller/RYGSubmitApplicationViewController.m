//
//  RYGSubmitApplicationViewController.m
//  shoumila
//
//  Created by 阴～ on 15/9/29.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import "RYGSubmitApplicationViewController.h"
#import "RYGUserRefundParam.h"
#import "RYGHttpRequest.h"
#import "MBProgressHUD+MJ.h"

@interface RYGSubmitApplicationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView* mainTableView;
    
    NSString* cashText;
    NSString* idCardText;
    NSString* bankCardText;
    NSString* bankNameText;
    
    NSString* nameText;
    NSString* teleText;
}
@end

@implementation RYGSubmitApplicationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"提交申请";
    
    [self createMainView];
}

- (void)createMainView {
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    mainTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 10*7+44*8+100);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.bounces = YES;
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = ColorRankMyRankBackground;
    [self.view addSubview:mainTableView];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 107;
    }
    else if (indexPath.section == 3) {
        return 100;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 0;
    }
    else if (section == 1) {
        return 10;
    }
    else if (section == 2) {
        return 35;
    }
    return 0;
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 5;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        //当前可提现
        UILabel* nameLabel = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/2-40, 24, 80, 16) withAlignment:NSTextAlignmentRight withFont:[UIFont boldSystemFontOfSize:14] withColor:ColorName withText:@"当前可提现"];
        [cell addSubview:nameLabel];
        
        UILabel* integerPriceLabel = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/2-90, 50, 100, 30) withAlignment:NSTextAlignmentRight withFont:[UIFont boldSystemFontOfSize:30] withColor:ColorName withText:[NSString stringWithFormat:@"%@",_cashMoney]];
        [cell addSubview:integerPriceLabel];
        
        UILabel* decimalPriceLabel = [self createLabelFrame:CGRectMake(SCREEN_WIDTH/2+10, 55, 50, 25) withAlignment:NSTextAlignmentLeft withFont:[UIFont boldSystemFontOfSize:16] withColor:ColorName withText:@".00元"];
        [cell addSubview:decimalPriceLabel];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 106.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell addSubview:lineView];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        UIView* top_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        top_lineView.backgroundColor = ColorLine;
        [cell addSubview:top_lineView];
        
        cell.textLabel.text = @"提现金额";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = ColorName;
        
        UITextField* applyCashTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 7, SCREEN_WIDTH-120, 30)];
        applyCashTextField.tag = 0;
        applyCashTextField.keyboardType = UIKeyboardTypeNumberPad;
        applyCashTextField.placeholder = @"请输入提现金额";
        applyCashTextField.font = [UIFont boldSystemFontOfSize:14];
        [applyCashTextField setValue:ColorLine forKeyPath:@"_placeholderLabel.textColor"];
        [applyCashTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        applyCashTextField.delegate = self;
        [cell addSubview:applyCashTextField];
        
        UIView* bottom_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        bottom_lineView.backgroundColor = ColorLine;
        [cell addSubview:bottom_lineView];
        
        return cell;
        
        
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor = ColorLine;
            [cell addSubview:lineView];
            
            UITextField* nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 7, SCREEN_WIDTH-120, 30)];
            nameTextField.text = [RYGUtility getUserInfo].user_name;
            nameText = [RYGUtility getUserInfo].user_name;
            nameTextField.tag = indexPath.row+10;
            nameTextField.font = [UIFont boldSystemFontOfSize:14];
            nameTextField.textColor = ColorName;
            [cell addSubview:nameTextField];
            
//            UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH-120, 44)];
//            nameLabel.text = @"郭小爽";
//            nameLabel.font = [UIFont boldSystemFontOfSize:14];
//            nameLabel.textColor = ColorName;
//            [cell addSubview:nameLabel];
        }
        else if (indexPath.row == 4) {
            
            UITextField* teleTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 7, SCREEN_WIDTH-120, 30)];
            teleTextField.tag = indexPath.row+10;
            teleTextField.text = [RYGUtility getUserInfo].mobile;
            teleText = [RYGUtility getUserInfo].mobile;
            teleTextField.font = [UIFont boldSystemFontOfSize:14];
            teleTextField.textColor = ColorName;
            [cell addSubview:teleTextField];
            
//            UILabel* teleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH-120, 44)];
//            teleLabel.text = @"18877776666";
//            teleLabel.font = [UIFont boldSystemFontOfSize:14];
//            teleLabel.textColor = ColorName;
//            [cell addSubview:teleLabel];
        }
        else {
            UITextField* idCardTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 7, SCREEN_WIDTH-120, 30)];
            idCardTextField.tag = indexPath.row;
            if (indexPath.row == 1) {
                idCardTextField.placeholder = @"请输入身份证号";
                idCardTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
            else if (indexPath.row == 2) {
                idCardTextField.placeholder = @"请输入银行卡号";
                idCardTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            else if (indexPath.row == 3) {
                idCardTextField.placeholder = @"请输入提现银行";
                idCardTextField.keyboardType = UIKeyboardTypeDefault;
            }
            idCardTextField.tag = indexPath.row;
            idCardTextField.font = [UIFont boldSystemFontOfSize:14];
            [idCardTextField setValue:ColorLine forKeyPath:@"_placeholderLabel.textColor"];
            [idCardTextField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
            idCardTextField.delegate = self;
            [cell addSubview:idCardTextField];
        }
        NSArray* titleArray = [NSArray arrayWithObjects:@"姓名",@"身份证",@"银行卡号",@"提现银行",@"联系电话", nil];
        cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = ColorName;
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell addSubview:lineView];
        
        return cell;
    }
    else if (indexPath.section == 3) {
        cell.backgroundColor = ColorRankMyRankBackground;
        
        UIButton* applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        applyBtn.frame = CGRectMake((SCREEN_WIDTH-290*SCREEN_SCALE)/2, 30, 290*SCREEN_SCALE, 40);
        applyBtn.layer.cornerRadius = 5;
        [applyBtn setBackgroundColor:ColorRateTitle];
        [applyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        applyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [applyBtn addTarget:self action:@selector(applyCash) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:applyBtn];
    }
    
//    //修改UITableview服用重叠的问题
//    for(UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    
    return cell;
}

-(UILabel*)createLabelFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment withFont:(UIFont*)font withColor:(UIColor*)color withText:(NSString*)text
{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = alignment;
    label.font = font;
    label.numberOfLines = 1;
    label.textColor = color;
    label.text = text;
    return label;
}

#pragma mark - Textfield Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3) {
        mainTableView.contentOffset = CGPointMake(0, 100);
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        NSLog(@"text0 = %@",textField.text);
        cashText = textField.text;
    }
    else if (textField.tag == 1) {
        NSLog(@"text1 = %@",textField.text);
        idCardText = textField.text;
    }
    else if (textField.tag == 2) {
        NSLog(@"text2 = %@",textField.text);
        bankCardText = textField.text;
    }
    else if (textField.tag == 3) {
        NSLog(@"text3 = %@",textField.text);
        bankNameText = textField.text;
    }
    else if (textField.tag == 10) {
        NSLog(@"text4 = %@",textField.text);
        nameText = textField.text;
    }
    else if (textField.tag == 14) {
        NSLog(@"text5 = %@",textField.text);
        teleText = textField.text;
    }
    mainTableView.contentOffset = CGPointMake(0, 0);
    return YES;
}

- (void)applyCash {
    RYGUserRefundParam *refundParam = [RYGUserRefundParam param];
    refundParam.money = cashText;
    refundParam.name = nameText;//[RYGUtility getUserInfo].user_name;//[RYGSingleton sharedSingleton].userInfo.user_name;
    refundParam.mobile = teleText;//[RYGUtility getUserInfo].mobile;//[RYGSingleton sharedSingleton].userInfo.mobile;
    refundParam.id_number = idCardText;
    refundParam.bank = bankNameText;
    refundParam.account = bankCardText;
    [RYGHttpRequest postWithURL:User_Refund params:refundParam.keyValues success:^(id json) {
        
        if ([[json valueForKey:@"code"] intValue] == 0) {
            //提现成功
            [MBProgressHUD showSuccess:@"提现成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([[json valueForKey:@"code"] intValue] == 403) {
            //余额不足
            [MBProgressHUD showError:@"余额不足"];
        }
        else {
            [MBProgressHUD showError:@"提现失败"];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
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
