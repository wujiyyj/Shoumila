//
//  UIImageView+RYGWebCache.m
//  shoumila
//
//  Created by 贾磊 on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "UIImageView+RYGWebCache.h"

@implementation UIImageView (RYGWebCache)
- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder
{
    [self setImageURL:[NSURL URLWithString:urlStr] placeholder:placeholder];
}
@end
