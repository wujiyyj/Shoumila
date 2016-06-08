//
//  UIImageView+RYGWebCache.h
//  shoumila
//
//  Created by 贾磊 on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (RYGWebCache)
- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder;
- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder;
@end
