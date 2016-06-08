//
//  RYGDistributeStickView.m
//  活跃棒的各项指数的分布棒
//
//  Created by jiaocx on 15/8/11.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDistributeStickView.h"

@implementation RYGDistributeModel


@end

@interface RYGDistributeStickView ()
@property(nonatomic,strong) NSMutableArray *stickArray;
@property(nonatomic,assign) float segmentValueSum;

@end

@implementation RYGDistributeStickView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _stickArray = [[NSMutableArray alloc]init];
        // 圆弧
        [[self layer]setCornerRadius:CGRectGetHeight([self bounds])/2];
        [[self layer]setMasksToBounds:TRUE];
    }
    return self;
}

- (void)setActivePersonModel:(RYGActivePersonModel *)activePersonModel {
    _activePersonModel = activePersonModel;
    [self calculateWidth];
    [self setNeedsDisplay];
}

// 计算各项值的比例宽度
- (void)calculateWidth {
    if (self.activePersonModel) {
        if (self.activePersonModel.publish_num) {
            RYGDistributeModel *model = [[RYGDistributeModel alloc]init];
            model.color = ColorActivePublishNum;
            model.segmentValue = [self.activePersonModel.publish_num integerValue];
            [_stickArray addObject:model];
            self.segmentValueSum += [self.activePersonModel.publish_num integerValue];
        }
        if (self.activePersonModel.comment_num) {
            RYGDistributeModel *model = [[RYGDistributeModel alloc]init];
            model.color = ColorActiveCommentNum;
            model.segmentValue = [self.activePersonModel.comment_num integerValue];
            [_stickArray addObject:model];
            self.segmentValueSum += [self.activePersonModel.comment_num integerValue];
        }
        if (self.activePersonModel.share_num) {
            RYGDistributeModel *model = [[RYGDistributeModel alloc]init];
            model.color = ColorActiveShareNum;
            model.segmentValue = [self.activePersonModel.share_num integerValue];
            [_stickArray addObject:model];
            self.segmentValueSum += [self.activePersonModel.share_num integerValue];
        }
        if (self.activePersonModel.praise_num) {
            RYGDistributeModel *model = [[RYGDistributeModel alloc]init];
            model.color = ColorActivePraiseNum;
            model.segmentValue = [self.activePersonModel.praise_num integerValue];
            [_stickArray addObject:model];
            self.segmentValueSum += [self.activePersonModel.praise_num integerValue];
        }
        if (self.activePersonModel.active_num) {
            RYGDistributeModel *model = [[RYGDistributeModel alloc]init];
            model.color = ColorActiveActiveNum;
            model.segmentValue = [self.activePersonModel.active_num integerValue];
            [_stickArray addObject:model];
            self.segmentValueSum += [self.activePersonModel.active_num integerValue];
        }
        if (self.activePersonModel.invite_num) {
            RYGDistributeModel *model = [[RYGDistributeModel alloc]init];
            model.color = ColorActiveInviteNum;
            model.segmentValue = [self.activePersonModel.invite_num integerValue];
            [_stickArray addObject:model];
            self.segmentValueSum += [self.activePersonModel.invite_num integerValue];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentGraphicsContext = UIGraphicsGetCurrentContext();
    CGRect progressRect = rect;
    CGRect lastSegmentRect  = CGRectMake(0, 0, 0, 0);
    
    for (int i = 0; i < self.stickArray.count; i++) {
        RYGDistributeModel *model = [self.stickArray objectAtIndex:i];
        float currentSegmentValue = model.segmentValue;
        CGColorRef color          = model.color.CGColor;
        float percentage          = currentSegmentValue / self.segmentValueSum;
        
        progressRect = rect;
        progressRect.size.width  *= percentage;
        progressRect.origin.x    += lastSegmentRect.origin.x + lastSegmentRect.size.width;
        
        if (progressRect.origin.x > 0) progressRect.origin.x += 0.20;
        
        lastSegmentRect = progressRect;
        
        CGContextAddRect(currentGraphicsContext, lastSegmentRect);
        CGContextSetFillColorWithColor(currentGraphicsContext, color);
        CGContextFillRect(currentGraphicsContext, lastSegmentRect);
    }
}

@end
