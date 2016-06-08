//
//  RYGSelectorView.h
//  shoumila
//
//  Created by 贾磊 on 15/8/29.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYGSelectorView : UIView

@property(nonatomic,strong) void(^cancelBlock)();
@property(nonatomic,strong) void(^confirmBlock)(NSString *items);

-(instancetype)initWithData:(NSArray *)data;

@end
