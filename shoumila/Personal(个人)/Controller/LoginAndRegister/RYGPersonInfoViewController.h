//
//  RYGPersonInfoViewController.h
//  shoumila
//
//  Created by yinyujie on 15/8/11.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"
#import "CaptureViewController.h"
#import "PassImageDelegate.h"

@interface RYGPersonInfoViewController : RYGBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDelegate>

@property (nonatomic,strong)    NSString* userId;

@end
