//
//  RYGPhotoView.m
//  ItcastWeibo
//
//  Created by apple on 14-5-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "RYGPhotoView.h"
//#import "RYGPhoto.h"
#import "UIImageView+WebCache.h"

@interface RYGPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@end

@implementation RYGPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    
    // 下载图片
    [self setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"user_head"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
}

@end
