//
//  RYGDynamicContentView.h
//  shoumila
//
//  Created by 贾磊 on 15/9/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYGDynamicFrame.h"
@interface RYGDynamicContentView : UIView

@property(nonatomic,strong)RYGDynamicFrame *dynamicFrame;
@property(nonatomic,assign) BOOL isDeatil;
- (void)arrowAction;
@end
