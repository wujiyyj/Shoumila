//
//  RYGBindTeleViewController.h
//  shoumila
//
//  Created by yinyujie on 15/8/10.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGBaseViewController.h"

@interface RYGBindTeleViewController : RYGBaseViewController<UITextFieldDelegate>
{
    NSThread *thread;
    int counttime;
}

@property (retain,nonatomic)    NSString* third_type;

@property (retain,nonatomic)    NSString* third_Uid;
@property (retain,nonatomic)    NSString* third_Token;
@property (retain,nonatomic)    NSString* third_Name;
@property (retain,nonatomic)    NSString* third_profileImage;

@end
