//
//  RYGShareView.m
//  shoumila
//
//  Created by 贾磊 on 15/10/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDynamicShareView.h"
#import "RYGShareCell.h"
#import "RYGSocialPlatformManager.h"
#import "MBProgressHUD+MJ.h"
#import "RYGHttpRequest.h"
#import "RYGFeedDeatailParam.h"

static NSString *shareCell = @"shareCell";

@interface RYGDynamicShareView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)RYGShareContentModel *contentModel;
@property (nonatomic,strong) UICollectionView *shareView;
@property(nonatomic,strong)NSMutableArray  *shareModelList;
@end

@implementation RYGDynamicShareView{
    
}

- (instancetype)initWithModel:(RYGShareContentModel *)contentModel{
    self = [super init];
    if (self) {
        _shareModelList = [NSMutableArray array];
        _contentModel = contentModel;
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 173, SCREEN_WIDTH, 173);
        self.backgroundColor = ColorShareView;
        [self setUpShareModel];
        [self setUpContentView];
    }
    return self;
}

- (void)setUpContentView{
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 15)];
    shareLabel.text = @"分享";
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.textColor = ColorSecondTitle;
    shareLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:shareLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(60*SCREEN_SCALE, 70);
    //        layout.minimumInteritemSpacing = 20*SCREEN_SCALE;
    layout.minimumLineSpacing = 100;
    CGRect shareViewFrame = CGRectMake(20, 40, SCREEN_WIDTH - 40, 70);
    _shareView = [[UICollectionView alloc]initWithFrame:shareViewFrame collectionViewLayout:layout];
    _shareView.delegate = self;
    _shareView.dataSource = self;
    _shareView.backgroundColor = ColorShareView;
    [_shareView registerClass:[RYGShareCell class] forCellWithReuseIdentifier:shareCell];
    [self addSubview:_shareView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 128, SCREEN_WIDTH - 30, 1)];
    line.backgroundColor = ColorLine;
    [self addSubview:line];
    UIButton *cancelLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 127, SCREEN_WIDTH, 46)];
    [cancelLabel setTitle:@"取消" forState:UIControlStateNormal];
    [cancelLabel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelLabel setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
    [self addSubview:cancelLabel];
}

-(void)setUpShareModel{
    RYGShareModel *weixin = [[RYGShareModel alloc]init];
    weixin.shareName = @"微信";
    weixin.iconName  = @"user_other_weixin";
        weixin.shareType = ShareTypeWeixiSession;
    //    if ([WXApi isWXAppInstalled]) {
    [_shareModelList addObject:weixin];
    //    }
    
    RYGShareModel *pengyouquan = [[RYGShareModel alloc]init];
    pengyouquan.shareName = @"朋友圈";
    pengyouquan.iconName  = @"user_other_moment";
        pengyouquan.shareType = ShareTypeWeixiTimeline;
    //    if ([WXApi isWXAppInstalled]) {
    [_shareModelList addObject:pengyouquan];
    //    }
    
    RYGShareModel *weibo = [[RYGShareModel alloc]init];
    weibo.shareName = @"微博";
    weibo.iconName  = @"user_other_weibo";
        weibo.shareType = ShareTypeSinaWeibo;
    //    if ([WeiboSDK isWeiboAppInstalled]) {
    [_shareModelList addObject:weibo];
    //    }
    
    RYGShareModel *copy = [[RYGShareModel alloc]init];
    copy.shareType = ShareTypeCopy;
    copy.shareName = @"复制";
    copy.iconName  = @"user_other_copy";
    [_shareModelList addObject:copy];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _shareModelList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RYGShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCell forIndexPath:indexPath];
    cell.shareMode = _shareModelList[indexPath.row];
    cell.ShareBlock = ^(RYGShareModel *shareModel){
        RYGFeedDeatailParam *param = [RYGFeedDeatailParam param];
        param.feed_id = _contentModel.feed_id;
        [RYGHttpRequest postWithURL:Feed_up_sharenum params:[param keyValues] success:^(id json) {
            NSLog(@"success");
        } failure:^(NSError *error) {
            NSLog(@"error");
        }];
        NSString *content = _contentModel.content;
        NSString *shareUrl = _contentModel.shareUrl;
        
        if (shareModel.shareType == ShareTypeCopy) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = shareUrl;
            
            _cancelBlock();
            return ;
        }
        
        if (shareModel.shareType == ShareTypeSinaWeibo) {
            if (!content) {
                content = @"";
            }
            [[RYGSocialPlatformManager sharedInstance] shareWithContent:[NSString stringWithFormat:@"%@%@\n",content,shareUrl] defaultContent:content image:nil  title:@"收米啦" url:shareUrl description:content shareType:ShareTypeSinaWeibo mediaType:SSPublishContentMediaTypeNews  isFollowing:YES compelteBlock:^{
                [MBProgressHUD showSuccess:@"分享成功"];
                
            }];
            
            _cancelBlock();
            return ;
        }
        
        SSPublishContentMediaType mediaType = SSPublishContentMediaTypeNews;
        NSLog(@"content = %@",content);
        [[RYGSocialPlatformManager sharedInstance] shareWithContent:content defaultContent:nil image:[UIImage imageNamed:@"shareIcon"]  title:@"收米啦" url:shareUrl description:content shareType:shareModel.shareType mediaType:mediaType  isFollowing:YES compelteBlock:^{
            [MBProgressHUD showSuccess:@"分享成功"];
        }];
        _cancelBlock();
    };
    return cell;
}

- (void)cancel{
    if (_cancelBlock) {
        _cancelBlock();
    }
}
@end
