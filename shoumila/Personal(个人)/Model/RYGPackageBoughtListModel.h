//
//  RYGPackageBoughtListModel.h
//  shoumila
//
//  Created by 阴～ on 15/9/22.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGPackageBoughtListModel : NSObject

@property(nonatomic,strong) NSMutableArray *datas;

@property(nonatomic,copy)  NSString *page_is_last;

@property(nonatomic,copy)  NSString *next;

@property(nonatomic,copy)  NSString *count;

@end
