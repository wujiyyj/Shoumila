//
//  RYGRecommendContentView1.m
//  shoumila
//
//  Created by 贾磊 on 15/9/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRecommendContentView1.h"
#import "UIImageView+WebCache.h"
#import "RYGDateUtility.h"
#import "RYGShareContentModel.h"
#import "RYGUserCenterViewController.h"
#import "RYGDynamicShareHandler.h"

@interface RYGRecommendContentView1 ()
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *avatar;
@property(nonatomic,strong) UILabel *content;
@property(nonatomic,strong) UIButton *recommendBtn;
@property(nonatomic,strong) UILabel *publish_time;
@end
@implementation RYGRecommendContentView1

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 116);
        self.backgroundColor = [UIColor whiteColor];
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 60)];
        _bgView.layer.borderColor = ColorLine.CGColor;
        _bgView.layer.borderWidth = 1;
        _bgView.layer.cornerRadius = 4;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 4;
        [_bgView addSubview:_avatar];
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, SCREEN_WIDTH - 170, 50)];
        _content.numberOfLines = 0;
        [_bgView addSubview:_content];
        
        _recommendBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_content.frame)+10, 14, 74, 30)];
        _recommendBtn.backgroundColor = ColorRankMenuBackground;
        [_recommendBtn setTitle:@"邀请收米" forState:UIControlStateNormal];
        [_recommendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _recommendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _recommendBtn.layer.cornerRadius = 2;
        [_recommendBtn addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_recommendBtn];
        
        _publish_time = [[UILabel alloc]initWithFrame:CGRectMake(15, 89, 60, 13)];
        _publish_time.textColor = ColorSecondTitle;
        _publish_time.font = [UIFont systemFontOfSize:10];
        [self addSubview:_publish_time];
    }
    return self;
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    RYGExtendCommentModel *content = dynamicFrame.dynamicModel.extended_content;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:content.avatar] placeholderImage:[UIImage imageNamed:@"user_head"]];
    
    
    NSString *contentStr = [NSString stringWithFormat:@"%@ | %@",content.username,content.text];
    NSRange nameRange = NSMakeRange(0, content.username.length);
    NSRange line = NSMakeRange(content.username.length, 2);
    NSRange contentRange = NSMakeRange(content.username.length+2,contentStr.length -9- content.username.length);
    NSRange praise = NSMakeRange(contentStr.length-7, 2);
    NSRange text = NSMakeRange(contentStr.length-4, 4);
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:nameRange];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:ColorSecondTitle range:contentRange];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:ColorName range:line];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:ColorRateTitle range:praise];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:ColorName range:text];
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:nameRange];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:contentRange];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:line];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:praise];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:text];
    
    _content.attributedText = attributeStr;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UINavigationController *nv = [RYGUtility getCurrentVC];
    RYGUserCenterViewController *usercenter = [[RYGUserCenterViewController alloc]init];
    RYGExtendCommentModel *content = _dynamicFrame.dynamicModel.extended_content;
    usercenter.userId = content.userid;
    [nv pushViewController:usercenter animated:YES];
}
- (void)invite{
    RYGShareContentModel *model = [[RYGShareContentModel alloc]init];
    model.shareUrl = _dynamicFrame.dynamicModel.share_url;
    model.mediaType = SSPublishContentMediaTypeNews;
    RYGDynamicShareHandler *handler = [[RYGDynamicShareHandler alloc]init];
    handler.contentModel = model;
    [handler showShareView];
}

@end
