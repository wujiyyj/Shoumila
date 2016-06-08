//
//  RYGPersonInfoViewController.m
//  shoumila
//
//  Created by yinyujie on 15/8/11.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGPersonInfoViewController.h"
#import "UIImageView+RYGWebCache.h"
#import "QBImagePickerController.h"
#import "QDUploadImageHandler.h"
#import "RYGModifyPasswordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RYGUserDetailParam.h"
#import "RYGUserModifyParam.h"
#import "RYGHttpRequest.h"
#import "RYGUserDetailModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CaptureViewController.h"
#import "MBProgressHUD+MJ.h"

@interface RYGPersonInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView* headerView;
    UIView* infoView;
    UIView *backView;
    UITextField* nameField;
    UITextField* mailField;
    UITableView* mainTableView;
    NSInteger isManOrWomen;
    
    BOOL isCamera;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (strong, nonatomic)  UIView *popView;
@property (nonatomic, strong) RYGUserDetailModel *userDetailModel;

- (IBAction)setUpCamera:(id)sender;
- (IBAction)setUpPhoto:(id)sender;
- (IBAction)setUpCancel:(id)sender;

- (IBAction)chooseMan:(id)sender;
- (IBAction)chooseWomen:(id)sender;


@end

@implementation RYGPersonInfoViewController
{
    NSMutableArray  *imgArray;
    UIImage         *localImage;
    QDUploadImageHandler *upload;
}

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
    
    isManOrWomen = 1;
    isCamera = YES;
    self.view.backgroundColor = ColorRankMyRankBackground;
    self.navigationItem.title = @"个人信息";
    imgArray = [[NSMutableArray alloc]init];
    upload = [[QDUploadImageHandler alloc]init];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinish)];
    
    [self loadNewData];
}

- (void)pressFinish
{
    
}

- (void)loadNewData{
    RYGUserDetailParam *userDetailParam = [RYGUserDetailParam param];
    userDetailParam.userid = _userId;
    [RYGHttpRequest postWithURL:User_Detail params:userDetailParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        _userDetailModel = [RYGUserDetailModel objectWithKeyValues:dic];
//        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"user.data"];
//        [NSKeyedArchiver archiveRootObject:_personalCenterModel.user toFile:path];
        
        [self reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData
{
    [self createHeaderView];
    [self createMainView];
}

- (void)createHeaderView {
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 108)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = ColorRankMenuBackground;
    [self.view addSubview:headerView];
    
    UIImageView* photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 6, 76, 76)];
    [photoImageView setImageURLStr:_userDetailModel.avatar placeholder:[UIImage imageNamed:@"user_head"]];
    photoImageView.center = CGPointMake(SCREEN_WIDTH/2, 44);
    photoImageView.layer.masksToBounds = YES;
    photoImageView.layer.cornerRadius = 38;
    photoImageView.layer.borderWidth = 3;
    photoImageView.layer.borderColor = ColorGreen.CGColor;
    [headerView addSubview:photoImageView];
    
    UIButton* photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(65, 6, 76, 76);
    photoButton.center = CGPointMake(SCREEN_WIDTH/2, 44);
    [photoButton addTarget:self action:@selector(editPhoto) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:photoButton];
    
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    infoView.backgroundColor = ColorRankMyRankBackground;
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    titleLabel.text = @"基本资料";
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    titleLabel.textColor = ColorSecondTitle;
    [infoView addSubview:titleLabel];
    
    UILabel* warmLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, 20)];
    warmLabel.text = @"完善更多资料可以调高关注度哦";
    warmLabel.textColor = ColorRankMenuBackground;
    warmLabel.font = [UIFont boldSystemFontOfSize:10];
    [infoView addSubview:warmLabel];
}

-(void)editPhoto{
    
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    UITapGestureRecognizer *removeAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAddPhoto)];
    [_backgroundView addGestureRecognizer:removeAdd];
    [self.view addSubview:_backgroundView];
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AddPhotoView" owner:self options:nil];
    _popView = views[0];
    _popView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, _popView.frame.size.height);
    [self.view addSubview:_popView];
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.3;
        _popView.frame = CGRectMake(0, SCREEN_HEIGHT - 64 -_popView.frame.size.height ,SCREEN_WIDTH, _popView.frame.size.height);
    }];
}

-(void)editSex{
    
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    UITapGestureRecognizer *removeAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAddPhoto)];
    [_backgroundView addGestureRecognizer:removeAdd];
    [self.view addSubview:_backgroundView];
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AddPhotoView" owner:self options:nil];
    _popView = views[1];
    _popView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, _popView.frame.size.height);
    [self.view addSubview:_popView];
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.3;
        _popView.frame = CGRectMake(0, SCREEN_HEIGHT - 64 -_popView.frame.size.height ,SCREEN_WIDTH, _popView.frame.size.height);
    }];
}

-(void) removeAddPhoto{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
        _popView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, _popView.frame.size.width, _popView.frame.size.height);
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        [_popView removeFromSuperview];
    }];
    
}

- (void)createMainView {
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, 40+44*5) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tableHeaderView = infoView;
    mainTableView.bounces = NO;
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

//UITableView delegate和datasource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//以下两个方法必实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray* titleArray = [NSArray arrayWithObjects:@"昵称",@"性别",@"邮箱",@"手机号",@"修改密码", nil];
//    NSArray* contentArray = [NSArray arrayWithObjects:@"黑井",@"男",@"77632756543@qq.com",@"13377776666",@"", nil];
    
    
    NSMutableArray* contentArray = [NSMutableArray arrayWithObjects:_userDetailModel.user_name,_userDetailModel.gender.intValue == 1 ? @"男":@"女",_userDetailModel.email,_userDetailModel.mobile,@"", nil];
    NSMutableArray* contentArrays = [NSMutableArray arrayWithCapacity:5];
    [contentArrays addObject:_userDetailModel.user_name];
    [contentArrays addObject:_userDetailModel.gender.intValue == 1 ? @"男":@"女"];
    [contentArrays addObject:_userDetailModel.email];
    [contentArrays addObject:_userDetailModel.mobile];
    [contentArrays addObject:@""];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 20)];
    titleLabel.text = titleArray[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = ColorName;
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.row != 4) {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(15, cell.contentView.size.height-0.5, SCREEN_WIDTH-30, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    else {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.size.height-0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    if (indexPath.row == 0) {
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = ColorLine;
        [cell.contentView addSubview:lineView];
    }
    
    
    UIImageView* arr_icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-23, 14, 8, 14)];
    arr_icon.image = [UIImage imageNamed:@"user_arrow"];
    [cell.contentView addSubview:arr_icon];
    
    UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-238, 12, 200, 20)];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.text = contentArray[indexPath.row];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = ColorRankMedal;
    [cell.contentView addSubview:contentLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"row = %ld",indexPath.row);
    if (indexPath.row == 0) {
        
        [self createNameInfoView];
    }
    else if (indexPath.row == 1) {
        [self editSex];
    }
    else if (indexPath.row == 2) {
        
        [self createMailInfoView];
    }
    else if (indexPath.row == 4) {
        RYGModifyPasswordViewController* modifyPasswordVC = [[RYGModifyPasswordViewController alloc]init];
        [self.navigationController pushViewController:modifyPasswordVC animated:YES];
    }
}

-(void)createNameInfoView
{
    //iOS7及之后，UIAlertView不能再自定义
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view.window addSubview:backView];
    
    UIControl* backControl = [[UIControl alloc]init];
    backControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [backControl addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backControl];
    
    UIView* alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-270)/2, 0, 270, 143)];
    alertView.userInteractionEnabled = YES;
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 4;
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.centerY = backView.frame.size.height/2;
    [backView addSubview:alertView];
    
    UILabel* title_label = [self createLabelFrame:CGRectMake(80, 18, 160, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont boldSystemFontOfSize:15] withCenterX:alertView.frame.size.width/2.0f withColor:ColorName withText:@"设置昵称"];
    [alertView addSubview:title_label];
    
    UIButton* cancelBtn = [self createButtonFrame:CGRectMake(5, 18, 50, 22) withTitle:@"取消" withTitleColor:ColorRankMedal withBackgroundColor:[UIColor clearColor]];
    [cancelBtn addTarget:self action:@selector(CancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelBtn];
    
    UIButton* saveBtn = [self createButtonFrame:CGRectMake(270-55, 18, 50, 22) withTitle:@"完成" withTitleColor:ColorRankMenuBackground withBackgroundColor:[UIColor clearColor]];
    [saveBtn addTarget:self action:@selector(SaveNameBtn) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:saveBtn];
    
    UILabel* warm_label = [[UILabel alloc]initWithFrame:CGRectMake(15, 55, 270-30, 18)];
    warm_label.textAlignment = NSTextAlignmentLeft;
    warm_label.font = [UIFont systemFontOfSize:11];
    warm_label.textColor = ColorRankMedal;
    warm_label.text = @"请输入6个汉字或者12个英文字母以内的昵称";
    [alertView addSubview:warm_label];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 78, 270-30, 40)];
    nameField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    nameField.keyboardType = UIKeyboardTypeDefault;
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.delegate = self;
    [alertView addSubview:nameField];

//    UITapGestureRecognizer* tapBackView = [[UITapGestureRecognizer alloc]init];
//    [tapBackView addTarget:self action:@selector(CancelBtn)];
//    [backView addGestureRecognizer:tapBackView];
}

-(void)createMailInfoView
{
    //iOS7及之后，UIAlertView不能再自定义
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view.window addSubview:backView];
    
    UIControl* backControl = [[UIControl alloc]init];
    backControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [backControl addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backControl];
    
    UIView* alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-270)/2, 0, 270, 143)];
    alertView.userInteractionEnabled = YES;
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 4;
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.centerY = backView.frame.size.height/2;
    [backView addSubview:alertView];
    
    UILabel* title_label = [self createLabelFrame:CGRectMake(80, 18, 160, 20) withAlignment:NSTextAlignmentCenter withFont:[UIFont boldSystemFontOfSize:15] withCenterX:alertView.frame.size.width/2.0f withColor:ColorName withText:@"设置邮箱"];
    [alertView addSubview:title_label];
    
    UIButton* cancelBtn = [self createButtonFrame:CGRectMake(5, 18, 50, 22) withTitle:@"取消" withTitleColor:ColorRankMedal withBackgroundColor:[UIColor clearColor]];
    [cancelBtn addTarget:self action:@selector(CancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelBtn];
    
    UIButton* saveBtn = [self createButtonFrame:CGRectMake(270-55, 18, 50, 22) withTitle:@"完成" withTitleColor:ColorRankMenuBackground withBackgroundColor:[UIColor clearColor]];
    [saveBtn addTarget:self action:@selector(SaveMailBtn) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:saveBtn];
    
    UILabel* warm_label = [[UILabel alloc]initWithFrame:CGRectMake(15, 55, 270-30, 18)];
    warm_label.textAlignment = NSTextAlignmentLeft;
    warm_label.font = [UIFont systemFontOfSize:11];
    warm_label.textColor = ColorRankMedal;
    warm_label.text = @"请输入正确邮箱地址";
    [alertView addSubview:warm_label];
    
    mailField = [[UITextField alloc]initWithFrame:CGRectMake(15, 78, 270-30, 40)];
    mailField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    mailField.keyboardType = UIKeyboardTypeDefault;
    mailField.borderStyle = UITextBorderStyleRoundedRect;
    mailField.delegate = self;
    [alertView addSubview:mailField];
    
    //    UITapGestureRecognizer* tapBackView = [[UITapGestureRecognizer alloc]init];
    //    [tapBackView addTarget:self action:@selector(CancelBtn)];
    //    [backView addGestureRecognizer:tapBackView];
}

-(void)CancelBtn
{
    [UIView animateWithDuration:.35 animations:^{
        backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [backView removeFromSuperview];
        }
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textField - %@",textField.text);
}

-(void)SaveNameBtn
{
    NSLog(@"text = %@",nameField.text);
    [UIView animateWithDuration:.35 animations:^{
        backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [backView removeFromSuperview];
            [self sendUpLoadData];
        }
    }];
}

-(void)SaveMailBtn
{
    NSLog(@"text = %@",mailField.text);
    [UIView animateWithDuration:.35 animations:^{
        backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [backView removeFromSuperview];
            [self sendUpLoadData];
        }
    }];
}

//修改用户信息，发送请求
- (void)sendUpLoadData{
    RYGUserModifyParam *userModifyParam = [RYGUserModifyParam param];
    userModifyParam.user_name = nameField.text;
    userModifyParam.email = mailField.text;
    userModifyParam.gender = isManOrWomen;
    [RYGHttpRequest postWithURL:User_Modify params:userModifyParam.keyValues success:^(id json) {
        
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        _userDetailModel = [RYGUserDetailModel objectWithKeyValues:dic];
        //        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"user.data"];
        //        [NSKeyedArchiver archiveRootObject:_personalCenterModel.user toFile:path];
        
        [self reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(UILabel*)createLabelFrame:(CGRect)frame withAlignment:(NSTextAlignment)alignment withFont:(UIFont*)font withCenterX:(CGFloat)x withColor:(UIColor*)color withText:(NSString*)text
{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.centerX = x;
    label.textAlignment = alignment;
    label.font = font;
    label.numberOfLines = 0;
    label.textColor = color;
    label.text = text;
    return label;
}

-(UIButton*)createButtonFrame:(CGRect)frame withTitle:(NSString*)title withTitleColor:(UIColor*)color withBackgroundColor:(UIColor*)backColor
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setBackgroundColor:backColor];
    return button;
}

#pragma mark - Textfield Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)backgroundTapped
{
    [nameField resignFirstResponder];
    [mailField resignFirstResponder];
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

- (IBAction)setUpCamera:(id)sender {
    [self tapCamera];
}

- (IBAction)setUpPhoto:(id)sender {
    [self tapPhoto];
}

- (IBAction)setUpCancel:(id)sender {
    [self removeAddPhoto];
}

- (IBAction)chooseMan:(id)sender {
    isManOrWomen = 1;
    [self removeAddPhoto];
    [self sendUpLoadData];
}

- (IBAction)chooseWomen:(id)sender {
    isManOrWomen = 2;
    [self removeAddPhoto];
    [self sendUpLoadData];
    
}

- (void)tapCamera
{
    isCamera = YES;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusDenied)
        {
//            [MBProgressHUD showError:@"请在隐私设置中开启相机权限"];
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在隐私设置中开启相机权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        // 相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [imagePickerController takePicture];
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (void)tapPhoto
{
    isCamera = NO;
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusDenied)
    {
//        [MBProgressHUD showError:@"请在隐私设置中开启相册权限"];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在隐私设置中开启相机权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
}

#pragma 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        if (isCamera) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            [self passImage:image];
        }
        else {
            //将图片传递给截取界面进行截取并设置回调方法（协议）
            CaptureViewController *captureView = [[CaptureViewController alloc] init];
            captureView.delegate = self;
            captureView.image = image;
            //隐藏UIImagePickerController本身的导航栏
            picker.navigationBar.hidden = YES;
            [picker pushViewController:captureView animated:YES];
        }
        
        
    }
}

#pragma mark - 图片回传协议方法
-(void)passImage:(UIImage *)image
{
    [imgArray removeAllObjects];
    [mainTableView reloadData];
    [imgArray addObject:image];
    [upload uploadImage:[QDUploadImageHandler compressImage:imgArray prx:300]];
    [self removeAddPhoto];
    __block RYGPersonInfoViewController *blockSelf = self;
    upload.imageUploadComplate = ^(NSString *images){
        
        RYGUserModifyParam *userModifyParam = [RYGUserModifyParam param];
        userModifyParam.avatar = images;
        [RYGHttpRequest postWithURL:User_Modify params:userModifyParam.keyValues success:^(id json) {
            
            NSMutableDictionary *dic = [json valueForKey:@"data"];
            _userDetailModel = [RYGUserDetailModel objectWithKeyValues:dic];
            
            if ([[json valueForKey:@"code"] intValue] == 0) {
                //修改成功
                [blockSelf reloadData];
                [MBProgressHUD showSuccess:@"修改成功"];
            }
            else {
                //修改失败
                [MBProgressHUD showError:@"修改失败"];
            }
            
        } failure:^(NSError *error) {
            
        }];
    };
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
