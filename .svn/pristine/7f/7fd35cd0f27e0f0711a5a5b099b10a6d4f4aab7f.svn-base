//
//  RYGRecommendContentView.m
//  shoumila
//
//  Created by 贾磊 on 15/9/5.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGRecommendContentView.h"
#import "UIImageView+WebCache.h"
#import "RYGDynamicModel.h"
#import "RYGDateUtility.h"
#import "RYGUserCenterViewController.h"

static NSString *avatarCell = @"collecaioncell";
@interface RYGRecommendContentView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) UILabel *headerLeabel;
@property(nonatomic,strong) UICollectionView *avatarCollectionView;
@property(nonatomic,strong) UIImageView *numImage;
@property(nonatomic,strong) UIImageView *arrowImage;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *avatar;
@property(nonatomic,strong) UILabel *userName;
@property(nonatomic,strong) UILabel *target_win_rate;
@property(nonatomic,strong) UILabel *target_profit_margin;
@property(nonatomic,strong) UILabel *target_matches;
@property(nonatomic,strong) UIButton *days;
@property(nonatomic,strong) UILabel *daysLabel;
@property(nonatomic,strong) UILabel *publish_time;
@property(nonatomic,strong) NSArray *avatars;
@property(nonatomic,strong) UILabel *numLabel;
@end
@implementation RYGRecommendContentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 173);
        self.backgroundColor = [UIColor whiteColor];
        _headerLeabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH -30, 40)];
        _headerLeabel.numberOfLines = 0;
        [self addSubview:_headerLeabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(15, 15);
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
        _avatarCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 67, 60, 60) collectionViewLayout:layout];
        _avatarCollectionView.dataSource = self;
        _avatarCollectionView.delegate = self;
        [_avatarCollectionView registerClass:[UICollectionViewCell alloc].class forCellWithReuseIdentifier:avatarCell];
        _avatarCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_avatarCollectionView];
        
        _numImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _numImage.image = [UIImage imageNamed:@"bottom"];
        _numImage.alpha = 0.6;
        [_avatarCollectionView addSubview:_numImage];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, 60, 14)];
        _numLabel.font = [UIFont systemFontOfSize:9];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [_avatarCollectionView addSubview:_numLabel];
        
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_arrow"]];
        _arrowImage.frame = CGRectMake(84*SCREEN_SCALE, 86, 40, 20);
        [self addSubview:_arrowImage];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(128*SCREEN_SCALE, 67, 177*SCREEN_SCALE, 60)];
        _bgView.layer.borderColor = ColorLine.CGColor;
        _bgView.layer.borderWidth = 1;
        _bgView.layer.cornerRadius = 2;
        [self addSubview:_bgView];
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 2;
        [_bgView addSubview:_avatar];
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 100, 14)];
        _userName.textColor = ColorName;
        _userName.font = [UIFont systemFontOfSize:13];
        [_bgView addSubview:_userName];
        
        _target_win_rate = [[UILabel alloc]initWithFrame:CGRectMake(60, 27, 50, 10)];
        _target_win_rate.textColor = ColorSecondTitle;
        _target_win_rate.font = [UIFont systemFontOfSize:9];
        [_bgView addSubview:_target_win_rate];
        
        _target_profit_margin = [[UILabel alloc]initWithFrame:CGRectMake(110, 27, 55, 10)];
        _target_profit_margin.textColor = ColorSecondTitle;
        _target_profit_margin.font = [UIFont systemFontOfSize:9];
        [_bgView addSubview:_target_profit_margin];
        
        _target_matches = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, 40, 10)];
        _target_matches.textColor = ColorSecondTitle;
        _target_matches.font = [UIFont systemFontOfSize:9];
        [_bgView addSubview:_target_matches];
        
        _days = [[UIButton alloc]initWithFrame:CGRectMake(_bgView.width -30, 0, 30, 30)];
        UIImage *image = [UIImage imageNamed:@"sanjiao"];
        [_days setBackgroundImage:image forState:UIControlStateNormal];
        [_days setBackgroundImage:[UIImage imageNamed:@"sanjiao_red"] forState:UIControlStateSelected];
        _days.layer.cornerRadius = 2;
        [_bgView addSubview:_days];
        
        _daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, 30, 30)];
        _daysLabel.font = [UIFont systemFontOfSize:9];
        _daysLabel.textColor = [UIColor whiteColor];
        CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/4);
        [_daysLabel setTransform:at];
        [_days addSubview:_daysLabel];
        _publish_time = [[UILabel alloc]initWithFrame:CGRectMake(15, 145, 40, 11)];
        _publish_time.textColor = ColorSecondTitle;
        _publish_time.font = [UIFont systemFontOfSize:10];
        [self addSubview:_publish_time];
    }
    return self;
}

-(void)setDynamicFrame:(RYGDynamicFrame *)dynamicFrame{
    _dynamicFrame = dynamicFrame;
    _avatars = _dynamicFrame.dynamicModel.extended_content.attention.avatars;
    RYGDynamicModel *model = dynamicFrame.dynamicModel;
    RYGExtendCommentModel *extendModel = model.extended_content;
    
        _headerLeabel.attributedText = [self getAttributeStr];
    
    _arrowImage.image = [UIImage imageNamed:@"big_arrow"];
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.extended_content.avatar] placeholderImage:[UIImage imageNamed:@"user_head"]];
    _numLabel.text = extendModel.attention.num;
    _userName.text = model.extended_content.username;
//    model.extended_content.package.target_win_rate;
    _target_win_rate.text = [NSString stringWithFormat:@"胜率%@%%",model.extended_content.package.target_win_rate];
    _target_profit_margin.text =[NSString stringWithFormat:@"利润率%@%%",model.extended_content.package.target_profit_margin];
    _target_matches.text = [NSString stringWithFormat:@"场次%@",model.extended_content.package.target_matches];
    
    NSString *day = [NSString stringWithFormat:@"%@天",model.extended_content.package.days];
    _daysLabel.text = day;
    _days.selected = [model.cat isEqualToString:@"4"];
    
    _publish_time.text = model.publish_time;
}

-(NSMutableAttributedString *)getAttributeStr{

    RYGDynamicModel *model = _dynamicFrame.dynamicModel;
    RYGExtendCommentModel *extendModel = model.extended_content;
    NSString *username = extendModel.username;
    if ([model.cat isEqualToString:@"2"]) {
        NSRange nameRange = NSMakeRange(0, username.length+1);
        NSRange line1Range = NSMakeRange(username.length+1, 3);
        NSRange text1 = NSMakeRange(username.length+4, 4);
        NSString *maxWin = extendModel.max_continuous_win;
        NSRange maxWinRange = NSMakeRange(username.length+8, maxWin.length);
        NSRange line2Range = NSMakeRange(username.length+maxWin.length+8, 3);
        NSMutableString *nameStr = [[NSMutableString alloc]init];
        [extendModel.attention.names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [nameStr appendFormat:@"%@、",obj];
        }];
//        NSString *name1 = extendModel.attention.names[0];
//        NSString *name2 = extendModel.attention.names[1];
//        NSString *name3 = extendModel.attention.names[2];
        NSUInteger loc = username.length+maxWin.length+11;
        NSUInteger len = nameStr.length + 2;
        NSRange namesRange = NSMakeRange(loc, len);
        NSString *num = extendModel.attention.num;
        NSString *contentStr = [NSString stringWithFormat:@"@%@ | 成功实现%@连红|%@等%@位用户都在关注他",username,maxWin,nameStr,num];
        loc = loc+len;
        len = contentStr.length -loc;
        NSRange text2Range = NSMakeRange(loc, len);
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:nameRange];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:nameRange];
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorName range:line1Range];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:line1Range];
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorName range:line2Range];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:line2Range];
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorSecondTitle range:text1];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:text1];
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorRateTitle range:maxWinRange];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:maxWinRange];
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorSecondTitle range:namesRange];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:namesRange];
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorName range:text2Range];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:text2Range];
        return attributStr;
    }else{
//        BOOL isCat4 = [model.cat isEqualToString:@"4"];
        BOOL isCat4 = YES;
        NSString *cat4Str = isCat4?@"快来跟TA收米吧!":@"";
        NSString *dataString = [extendModel.package.days isEqual: @"30"]?@"月":@"周";
        NSString *contentStr = [NSString stringWithFormat:@"@%@ | 胜率%@%% 利润率%@%% | 成功夺取%@榜冠军NO.1 %@ ",username,extendModel.win_rate,extendModel.profit_margin,dataString,cat4Str];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
        NSUInteger loc = 0;
        NSUInteger len = username.length+1;
        NSRange nameRange = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorRankMenuBackground range:nameRange];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:nameRange];
        loc = len;
        len = 3;
        NSRange lineRange = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorName range:lineRange];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:lineRange];
        
        loc = loc+len;
        len = 2;
        NSRange text1Range = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorSecondTitle range:text1Range];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:text1Range];
        
        loc = loc+len;
        len = extendModel.win_rate.length + 1;
        NSRange winRange = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorRateTitle range:winRange];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:winRange];
        
        loc = loc+len;
        len = 4;
        NSRange text2Range = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorSecondTitle range:text2Range];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:text2Range];
        
        loc = loc+len;
        len = extendModel.profit_margin.length + 1;
        NSRange profitRange = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorRateTitle range:profitRange];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:profitRange];
        
        loc = loc+len;
        len = 3;
        NSRange line2Range = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorName range:line2Range];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:line2Range];
        
        loc = loc+len;
        len = contentStr.length - loc;
        NSRange text3Range = NSMakeRange(loc, len);
        [attributStr addAttribute:NSForegroundColorAttributeName value:ColorName range:text3Range];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:text3Range];
        
        if (isCat4) {
            loc = contentStr.length - 10;
            len = 10;
            NSRange text4Range = NSMakeRange(loc, len);
            [attributStr addAttribute:NSForegroundColorAttributeName value:ColorSecondTitle range:text4Range];
            [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:text4Range];
        }
        

        return attributStr;
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:avatarCell forIndexPath:indexPath];
    NSString *url = _avatars[indexPath.row];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 2;
    [icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"user_head"]];
    cell.backgroundView = icon;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _avatars.count;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UINavigationController *nv = [RYGUtility getCurrentVC];
    RYGUserCenterViewController *usercenter = [[RYGUserCenterViewController alloc]init];
    RYGExtendCommentModel *content = _dynamicFrame.dynamicModel.extended_content;
    usercenter.userId = content.userid;
    [nv pushViewController:usercenter animated:YES];
}
@end
