//
//  QDCommentCollecitonCell.m
//  QDBestiPad
//
//  Created by lijianjie on 14-11-20.
//  Copyright (c) 2014年 QDbest. All rights reserved.
//

#import "RYGCommentCollecitonCell.h"
#import "UIImageView+WebCache.h"

@interface RYGCommentCollecitonImgCell()



@end


@implementation RYGCommentCollecitonImgCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:_imageView];
        [self addSubview:_deleteButton];
    }
    return self;
}

@end

@implementation RYGCommentCollecitonAddCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.frame = self.bounds;
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"addPhoth"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.addButton];
    }
    return self;
}

@end

@implementation RYGCommentCollecitonFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor blackColor];
        [self addSubview:self.textLabel];
    }
    
    return self;
}

@end
