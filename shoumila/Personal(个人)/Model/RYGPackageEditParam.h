//
//  RYGPackageEditParam.h
//  shoumila
//
//  Created by 阴～ on 15/9/26.
//  Copyright © 2015年 如意谷. All rights reserved.
//

#import "RYGBaseParam.h"

@interface RYGPackageEditParam : RYGBaseParam

@property(nonatomic,copy) NSString *package_id;
@property(nonatomic,copy) NSString *package_name;
@property(nonatomic,copy) NSString *service_term;
@property(nonatomic,copy) NSString *matches;
@property(nonatomic,copy) NSString *target_win;
@property(nonatomic,copy) NSString *fee;

@end
