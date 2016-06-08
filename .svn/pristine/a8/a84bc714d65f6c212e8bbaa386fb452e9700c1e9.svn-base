//
//  RYGCreatePackageTableViewCell.m
//  shoumila
//
//  Created by 阴～ on 15/9/9.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGCreatePackageTableViewCell.h"

@interface RYGCreatePackageTableViewCell ()

@property (nonatomic,retain)   UILabel *ytjcc_num;
@property (nonatomic,retain)   UILabel *yjs_num;
@property (nonatomic,retain)   UILabel *jldq_num;
@property (nonatomic,retain)   UILabel *tcfy_num;

@property (nonatomic,strong)    UILabel* dateLabel;
@property (nonatomic,strong)    UIView* circleView;
@property (nonatomic,strong)    UIView* topView;
@property (nonatomic,strong)    UILabel* orderDateLabel;
@property (nonatomic,strong)    UILabel* orderNumLabel;
@property (nonatomic,strong)    UILabel* stateLabel;

@end

@implementation RYGCreatePackageTableViewCell
@synthesize ytjcc_num;
@synthesize yjs_num;
@synthesize jldq_num;
@synthesize tcfy_num;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCreatePackageCell];
    }
    return self;
}

- (void)createCreatePackageCell {
    
    self.contentView.backgroundColor = ColorRankMyRankBackground;
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 126)];
    backView.backgroundColor = ColorRankMyRankBackground;
    [self.contentView addSubview:backView];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 40, 20)];
//    _dateLabel.text = @"05-04";
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont systemFontOfSize:10];
    _dateLabel.textColor = ColorRankMedal;
    [backView addSubview:_dateLabel];
    
    UIView* linView = [[UIView alloc]initWithFrame:CGRectMake(64.5, 9, 1, 121)];
    linView.backgroundColor = ColorLine;
    [backView addSubview:linView];
    
    _circleView = [[UIView alloc]initWithFrame:CGRectMake(60, 4, 10, 10)];
    _circleView.layer.cornerRadius = 5;
//    _circleView.backgroundColor = ColorRateTitle;
    [backView addSubview:_circleView];
    
    UIView* formView = [[UIView alloc]initWithFrame:CGRectMake(80, 4, SCREEN_WIDTH-95, 115)];
    formView.layer.borderWidth = 0.5;
    formView.layer.cornerRadius = 2;
    [backView addSubview:formView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, formView.frame.size.width, 50)];
//    _topView.backgroundColor = ColorRateTitle;
    [formView addSubview:_topView];
    
    _orderDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
//    _orderDateLabel.text = @"下单时间：05-04 13:24";
    _orderDateLabel.textColor = [UIColor whiteColor];
    _orderDateLabel.font = [UIFont systemFontOfSize:10];
    [_topView addSubview:_orderDateLabel];
    
    _orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 200, 20)];
//    _orderNumLabel.text = @"订单号：x9898424710124";
    _orderNumLabel.textColor = [UIColor whiteColor];
    _orderNumLabel.font = [UIFont systemFontOfSize:10];
    [_topView addSubview:_orderNumLabel];
    
    UILabel* ytjcc_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 60, 15)];
    ytjcc_label.text = @"已推荐场次";
    ytjcc_label.textColor = ColorName;
    ytjcc_label.font = [UIFont systemFontOfSize:10];
    [formView addSubview:ytjcc_label];
    
    ytjcc_num = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 80, 15)];
//    ytjcc_num.text = @"16场";
    ytjcc_num.textColor = ColorName;
    ytjcc_num.font = [UIFont systemFontOfSize:12];
    [formView addSubview:ytjcc_num];
    
    UILabel* yjs_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 78, 70, 15)];
    yjs_label.text = @"已净胜/需净胜";
    yjs_label.textColor = ColorName;
    yjs_label.font = [UIFont systemFontOfSize:10];
    [formView addSubview:yjs_label];
    
    yjs_num = [[UILabel alloc]initWithFrame:CGRectMake(90, 78, 80, 15)];
//    yjs_num.text = @"8/15";
    yjs_num.textColor = ColorName;
    yjs_num.font = [UIFont systemFontOfSize:12];
    [formView addSubview:yjs_num];
    
    UILabel* jldq_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 96, 70, 15)];
    jldq_label.text = @"距离到期还有";
    jldq_label.textColor = ColorName;
    jldq_label.font = [UIFont systemFontOfSize:10];
    [formView addSubview:jldq_label];
    
    jldq_num = [[UILabel alloc]initWithFrame:CGRectMake(80, 96, 80, 15)];
//    jldq_num.text = @"15天";
    jldq_num.textColor = ColorName;
    jldq_num.font = [UIFont systemFontOfSize:12];
    [formView addSubview:jldq_num];
    
    UILabel* tcfy_label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95-70, 60, 50, 15)];
    tcfy_label.text = @"套餐费用";
    tcfy_label.textAlignment = NSTextAlignmentRight;
    tcfy_label.textColor = ColorName;
    tcfy_label.font = [UIFont systemFontOfSize:12];
    [formView addSubview:tcfy_label];
    
    tcfy_num = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95-70, 75, 50, 15)];
//    tcfy_num.text = @"¥300";
    tcfy_num.textAlignment = NSTextAlignmentRight;
    tcfy_num.textColor = ColorName;
    tcfy_num.font = [UIFont boldSystemFontOfSize:13];
    [formView addSubview:tcfy_num];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-95-60, 90, 40, 20)];
//    _stateLabel.text = @"进行中";
//    _stateLabel.textColor = ColorRateTitle;
    _stateLabel.textAlignment = NSTextAlignmentRight;
    _stateLabel.font = [UIFont systemFontOfSize:12];
    [formView addSubview:_stateLabel];
    
}

- (void)setPackageCreatedModel:(RYGPackageCreatedModel *)packageCreatedModel {
    _packageCreatedModel = packageCreatedModel;
    
    [self updateCell];
}

- (void)updateCell {
    if (_packageCreatedModel.status.intValue == 1) {
        _stateLabel.text = @"进行中";
        _stateLabel.textColor = ColorRateTitle;
        _circleView.backgroundColor = ColorRateTitle;
        _topView.backgroundColor = ColorRateTitle;
    }
    else if (_packageCreatedModel.status.intValue == 2) {
        _stateLabel.text = @"已成功";
        _stateLabel.textColor = ColorGreen;
        _circleView.backgroundColor = ColorGreen;
        _topView.backgroundColor = ColorGreen;
    }
    else if (_packageCreatedModel.status.intValue == 3) {
        _stateLabel.text = @"未成功";
        _stateLabel.textColor = ColorRankMedal;
        _circleView.backgroundColor = ColorRankMedal;
        _topView.backgroundColor = ColorRankMedal;
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@",[_packageCreatedModel.cdate substringFromIndex:5]];
    _orderDateLabel.text = [NSString stringWithFormat:@"下单时间：%@",_packageCreatedModel.ctime];
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",_packageCreatedModel.order_no];
    ytjcc_num.text = [NSString stringWithFormat:@"%@场",_packageCreatedModel.recommended_num];
    yjs_num.text = [NSString stringWithFormat:@"%@/%@",_packageCreatedModel.win_num,_packageCreatedModel.target_win];
    jldq_num.text = [NSString stringWithFormat:@"%@天",_packageCreatedModel.remaining_days];
    tcfy_num.text = [NSString stringWithFormat:@"¥%@",_packageCreatedModel.fee];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
