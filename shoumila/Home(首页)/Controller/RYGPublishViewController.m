//
//  ViewController.m
//  test
//
//  Created by  on 15/4/23.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "RYGPublishViewController.h"
#import "QBImagePickerController.h"
#import "MBProgressHUD+MJ.h"
#import "RYGCommentCollecitonCell.h"
#import "FacialView.h"
#import "QDUploadImageHandler.h"
#import <AVFoundation/AVFoundation.h>
#import "RYGHttpRequest.h"
#import "RYGPublishParam.h"
#import "RYGSubscribeViewController.h"
#import "RYGAttentionPersonModel.h"
#import "RYGScoreViewController.h"
#import "RYGNavigationController.h"

#define Time  0.25
#define  keyboardHeight 272

@interface RYGPublishViewController () <UITextViewDelegate,QBImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,facialViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITextView *txtSuggestContent;
@property (nonatomic,strong) UILabel *lblPlaceHolder;
@property (strong, nonatomic)  UIView *popView;
@property (nonatomic ,strong) UIView *testview;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy)   NSString *accept;
@property (nonatomic, assign) BOOL publishSuccess;
@property (nonatomic, strong) NSString *has_package;
@property (nonatomic, strong) NSString *residue_recommend;
@property (nonatomic, strong) UILabel  *recommendNumLabel;
@end

@implementation RYGPublishViewController
{
    UILabel *lblConentLengthTint;
    // 图片试图数组
    NSMutableArray  *imgArray;
    NSMutableArray  *thumbnailArray;
    UIScrollView    *scrollView;
    UIPageControl   *pageControl;
    BOOL            keyboardIsShow;
    BOOL            emojboardNeedShow;
    UIToolbar       *toolBar;
    UIBarButtonItem *item;
    UIBarButtonItem *atItem;
    UIBarButtonItem *betItem;
    UIBarButtonItem *imageItem;
    NSString        *imgUrls;
    int             imageCount;
    QDUploadImageHandler *imageHandler;
    UIButton *comboShareBtn;

}

-(void)loadView{
    [super loadView];
    imageCount = 9;
    imageHandler = [[QDUploadImageHandler alloc]init];
     imgArray=[[NSMutableArray alloc] init];
    thumbnailArray = [[NSMutableArray alloc]init];
    _txtSuggestContent = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, 300*SCREEN_SCALE, 140)];
    _txtSuggestContent.font=[UIFont systemFontOfSize:14];
    _txtSuggestContent.textColor = [UIColor blackColor];
    _txtSuggestContent.delegate=self;
    _txtSuggestContent.scrollEnabled = YES;
    [self.view addSubview:_txtSuggestContent];
    
    _lblPlaceHolder = [[UILabel alloc] init];
    _lblPlaceHolder.text=@"随便说点啥...";
    _lblPlaceHolder.backgroundColor=[UIColor clearColor];
    _lblPlaceHolder.textColor = ColorRankMedal;
    _lblPlaceHolder.font=[UIFont systemFontOfSize:14];
    _lblPlaceHolder.frame = CGRectMake(5, 0, 300, 30);
    [_txtSuggestContent addSubview:_lblPlaceHolder];
    
    //位置动态变化
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.itemSize = CGSizeMake(95*SCREEN_SCALE, 95*SCREEN_SCALE);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 180, 300*SCREEN_SCALE, 300*SCREEN_SCALE) collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[RYGCommentCollecitonImgCell class] forCellWithReuseIdentifier:kQDCommentCollecitonImgCellID];
    [self.collectionView registerClass:[RYGCommentCollecitonAddCell class] forCellWithReuseIdentifier:kQDCommentCollecitonAddCellID];
    [self.view addSubview:self.collectionView];
    
    self.recommendNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 165, 115, 15)];
    self.recommendNumLabel.textColor = ColorRankMedal;
    self.recommendNumLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.recommendNumLabel];


}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpKeyBoard];
    self.navigationItem.title = @"发动态";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 23)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"publishbtn"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    RYGBaseParam *param = [RYGBaseParam param];
    [RYGHttpRequest getWithURL:Feed_can_recommend params:[param keyValues] success:^(id json) {
        self.has_package = [json valueForKeyPath:@"data.has_package"];
        self.residue_recommend = [json valueForKeyPath:@"data.residue_recommend"];
//        comboShareBtn.enabled = [self.has_package boolValue];
        self.recommendNumLabel.text = [NSString stringWithFormat:@""];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:@"还可以推荐"];
        NSRange range = NSMakeRange(0, attrString.length);
        [attrString addAttribute:NSForegroundColorAttributeName value:ColorRankMedal range:range];
        range = NSMakeRange(5, [NSString stringWithFormat:@"%@",self.residue_recommend].length);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.residue_recommend]];
        [attrString appendAttributedString:str];
        [attrString addAttribute:NSForegroundColorAttributeName value:ColorRateTitle range:range];
        range = NSMakeRange(attrString.length, 1);
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"场"];
        [attrString appendAttributedString:str1];
        
        self.recommendNumLabel.attributedText = attrString;
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [_txtSuggestContent becomeFirstResponder];
    for (int i=0; i<9; i++) {
        FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, 300, 170)];
        [fview setBackgroundColor:[UIColor clearColor]];
        [fview loadFacialView:i size:CGSizeMake(SCREEN_SCALE*33, 43)];
        fview.delegate=self;
        [scrollView addSubview:fview];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAddPhoto];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_txtSuggestContent resignFirstResponder];
}
-(void)setUpKeyBoard{
    if (scrollView==nil) {
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT + 216, SCREEN_WIDTH, 216)];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, 0);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    scrollView.backgroundColor = [UIColor whiteColor];
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, SCREEN_HEIGHT - 30, 150, 30)];
    [pageControl setCurrentPage:0];
    pageControl.numberOfPages = 9;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    //    pageControl.hidden=YES;
    pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor grayColor];
    //    pageControl.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 106, SCREEN_WIDTH, 44)];
    
    imageItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"camera"]
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(addPhoto)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
    item = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"imoj"]
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(disFaceKeyboard)];
    atItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"at"]
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(atAction)];
    betItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"bet"]
            style:UIBarButtonItemStyleDone
            target:self
            action:@selector(betAction)];
    imageItem.tintColor = ColorRankMedal;
    item.tintColor = ColorRankMedal;
    atItem.tintColor = ColorRankMedal;
    betItem.tintColor = ColorRankMedal;
    
    UIBarButtonItem * sflexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    comboShareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 23)];
    [comboShareBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [comboShareBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [comboShareBtn setTitle:@"套餐分享" forState:UIControlStateNormal];
    [comboShareBtn setTitleColor:ColorRankMenuBackground forState:UIControlStateNormal];
    comboShareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    comboShareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [comboShareBtn addTarget:self action:@selector(comboShareAction:) forControlEvents:UIControlEventTouchUpInside];
    comboShareBtn.width = 80;
    UIBarButtonItem *comboShareItem = [[UIBarButtonItem alloc]initWithCustomView:comboShareBtn];
    NSMutableArray *buttons = [[NSMutableArray alloc]initWithObjects:imageItem,spaceItem,item,spaceItem,atItem,spaceItem,betItem,sflexibleItem,comboShareItem, nil];
    [toolBar setItems:buttons];
    [self.view addSubview:toolBar];

}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_publishSuccess) {
            [MBProgressHUD showSuccess:@"发布成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:HOMEVIEW_NOTIFICATION object:nil];
        }
    }];
}

- (void)atAction{
    RYGSubscribeViewController *subscribeVC = [[RYGSubscribeViewController alloc]init];
    subscribeVC.selectedCell = ^(RYGAttentionPersonModel *person){
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:_txtSuggestContent.attributedText];
        NSString *atName = [NSString stringWithFormat:@"@%@ ",person.user_name];
        NSMutableAttributedString *username = [[NSMutableAttributedString alloc]initWithString:atName];
        NSRange name = NSMakeRange(0,person.user_name.length+1);
        [username addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:name];
        [attrStr appendAttributedString:username];
        _txtSuggestContent.attributedText = attrStr;
        _lblPlaceHolder.text = @"";
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:subscribeVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)betAction{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:_txtSuggestContent.attributedText];
    if(attrStr.length > 1000)
    {
        [MBProgressHUD showError:@"不能超过1000字"];
        return;
    }
    if (_scoreParam) {
        [MBProgressHUD showError:@"只能推荐一场比赛"];
        return;
    }
    RYGScoreViewController *scoreVC = [[RYGScoreViewController alloc]init];
    scoreVC.needCancel = YES;
    scoreVC.scoreCleckBlock = ^(RYGScoreParam *entity){
        _scoreParam = entity;
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:_txtSuggestContent.attributedText];
        NSString *strName = [self getParamStr:_scoreParam];
        NSString *commendStr = [NSString stringWithFormat:@"#%@# ",strName];
        NSMutableAttributedString *attrCommend = [[NSMutableAttributedString alloc]initWithString:commendStr];
        NSRange range = NSMakeRange(0, commendStr.length-1);
        [attrCommend addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:range];
        [attrStr appendAttributedString:attrCommend];
        _txtSuggestContent.attributedText = attrStr;
        _lblPlaceHolder.text = @"";
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:scoreVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (NSString *) getParamStr:(RYGScoreParam *)entity{
    NSString *strName = @"";
    NSString *teamName = @"";
    if (!entity.odds) {
        return @"";
    }
    if ([entity.forecasts isEqualToString:@"1"]) {
        teamName = entity.ht;
    }else if ([entity.forecasts isEqualToString:@"2"]){
        teamName = entity.vt;
    }else{
        teamName = @"和局";
    }
    if (![entity.type isEqualToString:@"1"]) {
        if ([entity.rules isEqualToString:@"1"]) {
            if ([entity.forecasts isEqualToString:@"3"]) {
                strName = [NSString stringWithFormat:@"走地推荐:(胜平负) %@ %@:%@ %@ 平局 @%@",entity.ht,entity.hs,entity.vs,entity.vt,entity.odds];
            }else{
                strName = [NSString stringWithFormat:@"走地推荐:(胜平负) %@ 胜 @%@",teamName,entity.odds];
            }
            
        }else if ([entity.rules isEqualToString:@"2"]){
//            strName = [NSString stringWithFormat:@"(%@) %@%@ @%@",entity.rulesName,teamName,entity.handicap,entity.odds];
            strName = [NSString stringWithFormat:@"走地推荐:(让球) %@  %@ @%@",teamName,entity.handicap,entity.odds];
        }else{
//            strName = [NSString stringWithFormat:@"(%@)%@vs%@ 全场 %@ %@ @%@",entity.rulesName,entity.ht,entity.vt,entity.handicap,entity.rulesHigh,entity.odds];
            strName = [NSString stringWithFormat:@"走地推荐:(大小) %@ %@:%@ %@ 全场 %@ %@ @%@",entity.ht,entity.hs,entity.vs,entity.vt,entity.dx,entity.rulesHigh,entity.odds];
        }
    }else{
        if ([entity.rules isEqualToString:@"1"]) {
//            NSString *sheng = [entity.forecasts isEqualToString:@"3"]?@"":@"胜";
//            strName = [NSString stringWithFormat:@"(%@ %@-%@ %@) %@ %@ @%@",entity.ht,entity.hs,entity.vs,entity.vt,teamName,sheng,entity.odds];
            if ([entity.forecasts isEqualToString:@"3"]) {
                strName = [NSString stringWithFormat:@"(胜平负) %@vs%@ 平局 @%@",entity.ht,entity.vt,entity.odds];
            }else{
                strName = [NSString stringWithFormat:@"(胜平负) %@ 胜 @%@",teamName,entity.odds];
            }
        }else if ([entity.rules isEqualToString:@"2"]){
//            strName = [NSString stringWithFormat:@"(%@ %@-%@ %@) %@ %@ @%@",entity.ht,entity.hs,entity.vs,entity.vt,teamName,entity.handicap,entity.odds];
            strName = [NSString stringWithFormat:@"(让球) %@ %@ @%@",teamName,entity.handicap,entity.odds];
        }else{
//            strName = [NSString stringWithFormat:@"(%@ %@-%@ %@) %@ %@ @%@",entity.ht,entity.hs,entity.vs,entity.vt,entity.rulesHigh,entity.dx,entity.odds];
            strName = [NSString stringWithFormat:@"(大小) %@vs%@ 全场 %@ %@ @%@",entity.ht,entity.vt,entity.dx,entity.rulesHigh,entity.odds];
        }
    }

    return strName;
}

- (void)scoreCallBack{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:_txtSuggestContent.attributedText];
    NSString *paramStr = [self getParamStr:_scoreParam];
    NSString *commendStr = [NSString stringWithFormat:@"#%@# ",paramStr];
    NSMutableAttributedString *attrCommend = [[NSMutableAttributedString alloc]initWithString:commendStr];
    NSRange range = NSMakeRange(0, commendStr.length-1);
    [attrCommend addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:range];
    [attrStr appendAttributedString:attrCommend];
    _txtSuggestContent.attributedText = attrStr;
    _lblPlaceHolder.text = @"";

}

//点击发布
-(void)publish{
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    RYGPublishParam *param = [RYGPublishParam param];
    param.content = _txtSuggestContent.text;
    param.accept = _accept;
    param.is_package = [NSString stringWithFormat:@"%d", comboShareBtn.isSelected];
    RYGPublishViewController *weakSelf = self;
    if (_scoreParam) {
        param.matchid = _scoreParam.matchid;
        param.type = _scoreParam.type;
        param.rules = _scoreParam.rules;
        param.forecasts = _scoreParam.forecasts;
        param.handicap = _scoreParam.handicap;
        param.odds = _scoreParam.odds;
        param.hs = _scoreParam.hs;
        param.vs = _scoreParam.vs;
        param.date = _scoreParam.date;
        param.stime = _scoreParam.stime;
        param.hc = _scoreParam.hc;
        param.t = _scoreParam.t;
    }
    if (![self validate]) {
        return;
    }
    if (imgArray.count>0) {
        [imageHandler uploadImage:imgArray];
        [_txtSuggestContent resignFirstResponder];
        imageHandler.imageUploadComplate = ^(NSString *images){
            param.pics = images;
            [RYGHttpRequest postWithURL:Feed_publish params:[param keyValues] success:^(id json) {
                
                NSString *code = [json valueForKey:@"code"];
                if ([@"502" isEqualToString:code]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"推荐过期" message:@"推荐已过期，是否继续" delegate:weakSelf cancelButtonTitle:@"重新推荐" otherButtonTitles:@"继续推荐", nil];
                    [alertView show];
                    return;
                }
                _publishSuccess = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeNotification object:nil];
                [weakSelf cancel];
            } failure:^(NSError *error) {
                
            }];
        };
    }else{
        if ([_txtSuggestContent.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"发布内容不能为空!"];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            return;
        }
        [RYGHttpRequest postWithURL:Feed_publish params:[param keyValues] success:^(id json) {
            NSString *code = [json valueForKey:@"code"];
            [_txtSuggestContent resignFirstResponder];
            if ([code isEqual:@502]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"推荐过期" message:@"推荐已过期，是否继续" delegate:weakSelf cancelButtonTitle:@"重新推荐" otherButtonTitles:@"继续推荐", nil];
                [alertView show];
                return;
            }
            _publishSuccess = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeNotification object:nil];
            [weakSelf cancel];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (BOOL) validate {
    NSString *text = _txtSuggestContent.text;
    if ([text componentsSeparatedByString:@"#"].count > 3) {
        [MBProgressHUD showError:@"只能推荐一场比赛!"];
        return NO;
    }
    return YES;
}

-(void)comboShareAction:(UIButton *)btn{
//    btn.selected = !btn.selected;
    [MBProgressHUD showError:@"该功能暂未开放,敬请期待"];
}
-(void)p_resignFirstResponder{
    [_txtSuggestContent resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / SCREEN_WIDTH;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}

-(void)addPhoto{
    [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    [_txtSuggestContent resignFirstResponder];
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    UITapGestureRecognizer *removeAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAddPhoto)];
    [_backgroundView addGestureRecognizer:removeAdd];
    [[UIApplication sharedApplication].keyWindow addSubview:_backgroundView];
   
    _popView = [[UIView alloc]init];
    _popView.backgroundColor = ColorSecondTitle;
    _popView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,SCREEN_WIDTH, 136);
    [[UIApplication sharedApplication].keyWindow addSubview:_popView];
    UIButton *phtotBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [phtotBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [phtotBtn addTarget:self action:@selector(tapCamera) forControlEvents:UIControlEventTouchUpInside];
    phtotBtn.backgroundColor = [UIColor whiteColor];
    [phtotBtn setTitleColor:ColorName forState:UIControlStateNormal];
    [_popView addSubview:phtotBtn];
    
    UIButton *camBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 44)];
    [camBtn setTitle:@"从相册中选取" forState:UIControlStateNormal];
        camBtn.backgroundColor = [UIColor whiteColor];
        [camBtn setTitleColor:ColorName forState:UIControlStateNormal];
    [camBtn addTarget:self action:@selector(tapPhoto) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:camBtn];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 92, SCREEN_WIDTH, 44)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.backgroundColor = [UIColor whiteColor];
    [cancel addTarget:self action:@selector(removeAddPhoto) forControlEvents:UIControlEventTouchUpInside];
        [cancel setTitleColor:ColorName forState:UIControlStateNormal];
    [_popView addSubview:cancel];

    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.3;
        _popView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -_popView.frame.size.height ,SCREEN_WIDTH, _popView.frame.size.height);
    }];
}
-(void) removeAddPhoto{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
        _popView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, _popView.frame.size.width, _popView.frame.size.height);
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        [_popView removeFromSuperview];
        self.navigationController.navigationBarHidden = NO;
    }];
    
}
#pragma mark - UICollectionViewDataSource
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self p_resignFirstResponder];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
//        if (indexPath.row == imgArray.count&&imgArray.count<9)
//        {
//            RYGCommentCollecitonAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:kQDCommentCollecitonAddCellID forIndexPath:indexPath];
//            [addCell.addButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
//            cell = addCell;
//        }
//        else
//        {
            RYGCommentCollecitonImgCell *imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:kQDCommentCollecitonImgCellID forIndexPath:indexPath];
            imgCell.imageView.image = [imgArray objectAtIndex:indexPath.item];
            imgCell.imageView.clipsToBounds = YES;
            imgCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            [imgCell.deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            cell = imgCell;
//        }
        return cell;

}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@""]) {
        if ([textView.text hasSuffix:@"#"]) {
            NSRange range = [textView.text rangeOfString:@"#"];
            textView.text = [textView.text substringToIndex:range.location];
            textView.textColor = [UIColor blackColor];
            textView.font = [UIFont systemFontOfSize:14];
            _scoreParam = nil;
        }
        return YES;
    }

    if (textView.text.length >= 1000) {
        [MBProgressHUD showError:@"不能超过1000字"];
        return NO;
    }
    if(textView.text.length + text.length >= 1000)
    {
        [MBProgressHUD showError:@"不能超过1000字"];
        NSUInteger length = text.length < (1000 - textView.text.length)?text.length:1000 - textView.text.length;
        
        text = [text substringToIndex:length];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:_txtSuggestContent.attributedText];
        [attrStr appendAttributedString:[[NSAttributedString alloc]initWithString:text]];
        _txtSuggestContent.attributedText = attrStr;
        return NO;
    }
    if ([text isEqualToString:@"@"]) {
        [self atAction];
        return NO;
    }
    if ([text isEqualToString:@"#"]) {
        [self betAction];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
    if (!textView.text.length)
    {
        textView.text = @"";
        self.lblPlaceHolder.text = @"随便说点啥...";
    }
    else
    {
        self.lblPlaceHolder.text = @"";
    }


}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

#pragma mark - private method

- (void)tapCamera
{
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusDenied)
        {
            [MBProgressHUD showError:@"请在隐私设置中开启相机权限"];
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
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == AVAuthorizationStatusDenied){
        [MBProgressHUD showError:@"请在隐私设置中开启相册权限"];
    }
    else
        
    {
        @try {
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.fullScreenLayoutEnabled = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.limitsMaximumNumberOfSelection=YES;
        imagePickerController.maximumNumberOfSelection=imageCount;
        RYGNavigationController *navi = [[RYGNavigationController alloc] initWithRootViewController:imagePickerController];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"STHeitiK-Medium" size:20],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
        navi.navigationBar.titleTextAttributes = dict;
        navi.navigationBar.translucent = NO;
        navi.navigationBar.barTintColor = ColorRankMenuBackground;
        navi.navigationBar.tintColor = [UIColor blackColor];
        [self presentViewController:navi animated:YES completion:NULL];
        return ;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
}

// 删除掉选择的图片
-(void)deleteImage:(id)sender
{
    UIButton *btnDelete=(UIButton*)sender;
    NSInteger indexImage=btnDelete.tag;
    NSLog(@"%ld",(long)indexImage);
    [imgArray removeObjectAtIndex:indexImage];
    [self.collectionView reloadData];
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        _accept = @"1";
        [self publish];
    }
}

#pragma mark -
#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishQBPickingMediaWithInfo:(id)info
{
    if(imagePickerController.allowsMultipleSelection)
    {
        NSArray *mediaInfoArray = (NSArray *)info;
        
        if (mediaInfoArray &&  mediaInfoArray.count > 0)
        {
            imageCount = imageCount - mediaInfoArray.count;
            NSString *result = [NSString stringWithFormat:@"%d/9",9 - imageCount];
            [MBProgressHUD showSuccess:result];
            for (NSInteger i=0; i<mediaInfoArray.count; i++)
            {
                if (imgArray.count >= 9)
                {
                    [MBProgressHUD showError:@"最多9张照片"];
                    break;
                }
                NSDictionary *mediaInfo = (NSDictionary *)mediaInfoArray[i];
                UIImage *image = [mediaInfo objectForKey:UIImagePickerControllerOriginalImage];
                [imgArray addObject:image];
                UIImage *thumbnail = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(200, 200)];
                [thumbnailArray addObject:thumbnail];
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self removeAddPhoto];
        
        [_txtSuggestContent resignFirstResponder];
        [self.collectionView reloadData];
    }];
}

- (void)imageQBPickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    imageCount--;
    NSString *result = [NSString stringWithFormat:@"%d/9",9 - imageCount];
    [MBProgressHUD showSuccess:result];
    if (imgArray.count>=9)
    {
        [MBProgressHUD showError:@"最多9张照片"];
        return;
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imgArray addObject:image];
    UIImage *thumbnail = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(100, 100)];
    [thumbnailArray addObject:thumbnail];
    [self.collectionView reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

/**
 *  生成缩略图
 *
 *  @param image 原图片
 *  @param asize 缩略尺寸
 *
 *  @return 缩略图
 */
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        if (image.size.height>image.size.width) {
            rect.size.width = 200;
            
            rect.size.height = 200;
            
            rect.origin.x = 0;
            
            rect.origin.y = 0;
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, oldsize.width, oldsize.width));
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (_txtSuggestContent.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[_txtSuggestContent.text substringFromIndex:_txtSuggestContent.text.length-2]]) {
                NSLog(@"删除emoji %@",[_txtSuggestContent.text substringFromIndex:_txtSuggestContent.text.length-2]);
                newStr=[_txtSuggestContent.text substringToIndex:_txtSuggestContent.text.length-2];
            }else{
                newStr=[_txtSuggestContent.text substringToIndex:_txtSuggestContent.text.length-1];
            }
            _txtSuggestContent.text=newStr;
        }
    }else{
        self.lblPlaceHolder.text = @"";
        NSString *newStr=[NSString stringWithFormat:@"%@%@",_txtSuggestContent.text,str];
        [_txtSuggestContent setText:newStr];
        NSLog(@"点击其他后更新%lu,%@",(unsigned long)str.length,_txtSuggestContent.text);
    }
}

-(void)inputKeyboardWillShow:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"键盘即将出现：%@", NSStringFromCGRect(keyBoardFrame));
        
        toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-106,  SCREEN_WIDTH,44);
    }];
    [item setImage:[UIImage imageNamed:@"imoj"]];
    keyboardIsShow=YES;
    [pageControl setHidden:YES];
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    //    [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:@"imoj"]];
    if (pageControl.isHidden) {
        toolBar.frame = CGRectMake(0, SCREEN_HEIGHT-44-62,  SCREEN_WIDTH,toolBar.frame.size.height);
    }
    keyboardIsShow=NO;
    if (!emojboardNeedShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
        }];
    }
    emojboardNeedShow = NO;
}

-(void)disFaceKeyboard{
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
        }];
        [_txtSuggestContent becomeFirstResponder];
        [pageControl setHidden:YES];
        
    }else{
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        emojboardNeedShow = YES;
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, SCREEN_HEIGHT-keyboardHeight-toolBar.frame.size.height,  SCREEN_WIDTH,toolBar.frame.size.height);
        }];
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT-keyboardHeight,SCREEN_WIDTH, keyboardHeight)];
        }];
        [pageControl setHidden:NO];
        [_txtSuggestContent resignFirstResponder];
    }
    
}



@end
