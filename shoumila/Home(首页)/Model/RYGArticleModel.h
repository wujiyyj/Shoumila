//
//  RYGArticleModel.h
//  shoumila
//
//  Created by 贾磊 on 16/4/6.
//  Copyright © 2016年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYGArticleModel : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *header_pic;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *article_content;
@property(nonatomic,copy) NSString *read_num;
@end
