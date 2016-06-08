//
//  CaptureViewController.m
//  ImagePickerDemo
//
//  Created by Ryan Tang on 13-1-5.
//  Copyright (c) 2013年 Ericsson Labs. All rights reserved.
//

#import "CaptureViewController.h"

@interface CaptureViewController ()
{
    AGSimpleImageEditorView *editorView;
}
@end

@implementation CaptureViewController
@synthesize delegate;
@synthesize image;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"图片裁剪";
    self.view.backgroundColor = [UIColor blackColor];
    
    //image为上一个界面传过来的图片资源
    editorView = [[AGSimpleImageEditorView alloc] initWithImage:self.image];
    editorView.frame = CGRectMake(0, 0, self.view.frame.size.width ,  self.view.frame.size.width);
    editorView.center = self.view.center;
    
    //外边框的宽度及颜色
    editorView.borderWidth = 1.f;
    editorView.borderColor = [UIColor blackColor];
    
    //截取框的宽度及颜色
    editorView.ratioViewBorderWidth = 5.f;
    editorView.ratioViewBorderColor = [UIColor orangeColor];
    
    //截取比例，我这里按正方形1:1截取（可以写成 3./2. 16./9. 4./3.）
    editorView.ratio = 1;
    
    [self.view addSubview:editorView];
    
    if (_isFromCamera) {
        
        self.navigationController.navigationBarHidden = NO;
        
        //返回按钮
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButton)];
        self.navigationItem.leftBarButtonItem = backItem;
        
        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pressFinish)];
        
        //保存按钮
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
        self.navigationItem.rightBarButtonItem = doneItem;
        
        editorView.center = CGPointMake(self.view.centerX, self.view.centerY - 50);
        
    }
    else {
        //添加导航栏和完成按钮
        UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        [self.view addSubview:naviBar];
        
        UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@"图片裁剪"];
        [naviBar pushNavigationItem:naviItem animated:YES];
        
        //返回按钮
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButton)];
        backItem.tintColor = [UIColor blackColor];
        naviItem.leftBarButtonItem = backItem;
        
        //保存按钮
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
        doneItem.tintColor = [UIColor blackColor];
        naviItem.rightBarButtonItem = doneItem;
    }
}

//完成截取
-(void)saveButton
{
    //output为截取后的图片，UIImage类型
    UIImage *resultImage = editorView.output;
    
    //通过代理回传给上一个界面显示
    [self.delegate passImage:resultImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)backButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
