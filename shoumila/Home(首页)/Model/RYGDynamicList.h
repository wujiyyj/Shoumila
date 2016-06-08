//
//  RYGDynamicList.h
//  shoumila
//
//  Created by 贾磊 on 15/9/3.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGDynamicList : NSObject
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,copy)NSString *page_is_last;
@property(nonatomic,copy)NSString *next;
@property(nonatomic,copy)NSString *prev;
@end
