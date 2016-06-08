//
//  RYGPackageBoughtModel.h
//  shoumila
//
//  Created by 阴～ on 15/9/22.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGPackageBoughtModel : NSObject

@property(nonatomic,copy) NSDictionary *user;
@property(nonatomic,copy) NSDictionary *package;
@property(nonatomic,copy) NSString *win_num;    //获胜场次
@property(nonatomic,copy) NSString *recommended_num; //已推荐场次
@property(nonatomic,copy) NSString *winrate;    //胜率
@property(nonatomic,copy) NSString *ctime;      //下单时间
@property(nonatomic,copy) NSString *fee;        //套餐价格
@property(nonatomic,copy) NSString *order_no;   //订单号
@property(nonatomic,copy) NSString *run_days;        //运行天数
@property(nonatomic,copy) NSString *status;   //状态(int 1:运行中 2:成功 3:未成功)

@end
