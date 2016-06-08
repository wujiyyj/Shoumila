//
//  RYGUserMoneyModel.h
//  shoumila
//
//  Created by 阴～ on 15/10/10.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGUserMoneyModel : NSObject

@property(nonatomic,strong) NSMutableArray *datas;

@property(nonatomic,copy)  NSString *page_is_last;

@property(nonatomic,copy)  NSString *next;

@property(nonatomic,copy)  NSString *count;

@end
