//
//  RYGShareView.m
//  shoumila
//
//  Created by 阴～ on 15/9/15.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGShareView.h"
//#import "WXApi.h"
//#import "WXApiObject.h"
//#import "WeiboSDK.h"
//#import <ShareSDK/ShareSDK.h>
#import "RYGShareModel.h"
//#import <TencentOpenAPI/QQApi.h>
#import "RYGShareCell.h"
#import "RYGShareViewHandler.h"
#import "RYGSocialPlatformManager.h"
#import "RYGAttentionParam.h"
#import "RYGHttpRequest.h"
#import "MBProgressHUD+MJ.h"

static NSString *shareCell = @"shareCell";

@interface RYGShareView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *shareView;
@property (nonatomic,strong) RYGShareViewHandler *handler;
@end

@implementation RYGShareView
{
    NSMutableArray  *shareModelList;
}

-(instancetype)initWithHandler:(RYGShareViewHandler *)handler{
    _handler = handler;
    self = [super init];
    shareModelList = [NSMutableArray array];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 243);
    if (self) {
        [self setUpShareModel];
        UILabel *top_title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
        top_title.centerX = SCREEN_WIDTH/2;
        top_title.textAlignment = NSTextAlignmentCenter;
        top_title.text = @"分享";
        top_title.font = [UIFont systemFontOfSize:14];
        top_title.textColor = ColorSecondTitle;
        [self addSubview:top_title];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(60*SCREEN_SCALE, 70);
        //        layout.minimumInteritemSpacing = 20*SCREEN_SCALE;
        layout.minimumLineSpacing = 100;
        CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 243);
        CGRect shareViewFrame = CGRectMake(20, 40, SCREEN_WIDTH - 40, 100);
        self.frame = frame;
        self.backgroundColor = ColorShareView;
        _shareView = [[UICollectionView alloc]initWithFrame:shareViewFrame collectionViewLayout:layout];
        _shareView.delegate = self;
        _shareView.dataSource = self;
        _shareView.backgroundColor = ColorShareView;
        [_shareView registerClass:[RYGShareCell class] forCellWithReuseIdentifier:shareCell];
        [self addSubview:_shareView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 126, SCREEN_WIDTH - 30, 0.5)];
        line.backgroundColor = ColorLine;
        [self addSubview:line];
        
        UILabel *bottom_title = [[UILabel alloc]initWithFrame:CGRectMake(20, 127, 100, 30)];
        bottom_title.centerX = SCREEN_WIDTH/2;
        bottom_title.textAlignment = NSTextAlignmentCenter;
        bottom_title.text = @"更多";
        bottom_title.font = [UIFont systemFontOfSize:14];
        bottom_title.textColor = ColorSecondTitle;
        [self addSubview:bottom_title];
        
        //举报
        UIButton* reportIcon = [[UIButton alloc]initWithFrame:CGRectMake(37, 167, 36, 36)];
        [reportIcon setImage:[UIImage imageNamed:@"user_other_report"] forState:UIControlStateNormal];
        [reportIcon addTarget:self action:@selector(reportBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reportIcon];
        UILabel* reportName = [[UILabel alloc]initWithFrame:CGRectMake(19, 213, 70, 20)];
        reportName.text = @"举报";
        reportName.textColor = ColorSecondTitle;
        reportName.textAlignment = NSTextAlignmentCenter;
        reportName.font = [UIFont systemFontOfSize:11];
        [self addSubview:reportName];
        
        //拉黑
        UIButton* defriendIcon = [[UIButton alloc]initWithFrame:CGRectMake(57+60*SCREEN_SCALE, 167, 36, 36)];
        [defriendIcon setImage:[UIImage imageNamed:@"user_other_defriend"] forState:UIControlStateNormal];
        [defriendIcon addTarget:self action:@selector(defriendBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:defriendIcon];
        UILabel* defriendName = [[UILabel alloc]initWithFrame:CGRectMake(39+60*SCREEN_SCALE, 213, 70, 20)];
        defriendName.text = @"拉黑";
        defriendName.textColor = ColorSecondTitle;
        defriendName.textAlignment = NSTextAlignmentCenter;
        defriendName.font = [UIFont systemFontOfSize:11];
        [self addSubview:defriendName];
    }
    return self;
}

- (void)defriendBtn
{
    _handler.removeViewBlock();
    
    RYGAttentionParam *attentionParam = [RYGAttentionParam param];
    attentionParam.userid = _handler.contentModel.userid;
    attentionParam.op = @"0";
    [RYGHttpRequest postWithURL:User_AddBlack params:attentionParam.keyValues success:^(id json) {
        NSNumber *code = [json valueForKey:@"code"];
        if (code && code.integerValue == 0) {
            //添加黑名单成功
            [MBProgressHUD showSuccess:@"添加黑名单成功"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)reportBtn
{
    _handler.removeViewBlock();
    
    RYGAttentionParam *attentionParam = [RYGAttentionParam param];
    attentionParam.userid = _handler.contentModel.userid;
    [RYGHttpRequest postWithURL:User_Report params:attentionParam.keyValues success:^(id json) {
        NSNumber *code = [json valueForKey:@"code"];
        if (code && code.integerValue == 0) {
            //举报成功
            [MBProgressHUD showSuccess:@"举报成功"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)setUpShareModel{
    RYGShareModel *weixin = [[RYGShareModel alloc]init];
    weixin.shareName = @"微信";
    weixin.iconName  = @"user_other_weixin";
    weixin.shareType = ShareTypeWeixiSession;
//    if ([WXApi isWXAppInstalled]) {
        [shareModelList addObject:weixin];
//    }
    
    RYGShareModel *pengyouquan = [[RYGShareModel alloc]init];
    pengyouquan.shareName = @"朋友圈";
    pengyouquan.iconName  = @"user_other_moment";
    pengyouquan.shareType = ShareTypeWeixiTimeline;
//    if ([WXApi isWXAppInstalled]) {
        [shareModelList addObject:pengyouquan];
//    }
    
    RYGShareModel *weibo = [[RYGShareModel alloc]init];
    weibo.shareName = @"微博";
    weibo.iconName  = @"user_other_weibo";
    weibo.shareType = ShareTypeSinaWeibo;
//    if ([WeiboSDK isWeiboAppInstalled]) {
        [shareModelList addObject:weibo];
//    }
    
    RYGShareModel *copy = [[RYGShareModel alloc]init];
    copy.shareType = ShareTypeCopy;
    copy.shareName = @"复制";
    copy.iconName  = @"user_other_copy";
    [shareModelList addObject:copy];
}

-(void)removeView{
    
    [RYGShareViewHandler removeShareView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return shareModelList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RYGShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCell forIndexPath:indexPath];
    cell.shareMode = shareModelList[indexPath.row];
    cell.ShareBlock = ^(RYGShareModel *shareModel){
        
        
        NSString *content = _handler.contentModel.content;
        NSString *shareUrl = _handler.contentModel.shareUrl;
        
        if (shareModel.shareType == ShareTypeCopy) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = shareUrl;
            
            [MBProgressHUD showSuccess:@"复制成功"];
            
            _handler.removeViewBlock();
            return ;
        }
        if (shareModel.shareType == ShareTypeSinaWeibo) {
            SSPublishContentMediaType mediaType = _handler.contentModel.mediaType?_handler.contentModel.mediaType:SSPublishContentMediaTypeText;
            NSLog(@"content = %@",content);
            [[RYGSocialPlatformManager sharedInstance] shareWithContent:[NSString stringWithFormat:@"%@%@\n",content,shareUrl] defaultContent:nil image:nil  title:@"收米啦" url:shareUrl description:content shareType:ShareTypeSinaWeibo mediaType:mediaType  isFollowing:YES compelteBlock:^{
                [MBProgressHUD showSuccess:@"分享成功"];
            }];
            
            _handler.removeViewBlock();
            return ;
        }
        
        SSPublishContentMediaType mediaType = _handler.contentModel.mediaType?_handler.contentModel.mediaType:SSPublishContentMediaTypeText;
        NSLog(@"content = %@",content);
        [[RYGSocialPlatformManager sharedInstance] shareWithContent:[NSString stringWithFormat:@"%@%@\n",content,shareUrl] defaultContent:nil image:[UIImage imageNamed:@"shareIcon"]  title:@"收米啦" url:shareUrl description:content shareType:shareModel.shareType mediaType:mediaType  isFollowing:YES compelteBlock:^{
            [MBProgressHUD showSuccess:@"分享成功"];
        }];
        _handler.removeViewBlock();
    };
    return cell;
}

@end
