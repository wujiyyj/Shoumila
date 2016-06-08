//
//  RYGSelectorView.m
//  shoumila
//
//  Created by 贾磊 on 15/8/29.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGSelectorView.h"

@interface RYGSelectorView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,strong)NSMutableArray *selectedItems;
@property(nonatomic,strong)NSMutableArray *allItems;
@end

@implementation RYGSelectorView

-(instancetype)initWithData:(NSMutableSet *)data{
    self = [super init];
    if (self) {
        _data = [data allObjects];
        _selectedItems = [NSMutableArray array];
        _allItems = [NSMutableArray array];
        [self selectAllBtnAction];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, 270, 400*SCREEN_SCALE);
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(15, 20, 30, 18);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = ColorName;
        label.text = @"筛选";
        [self addSubview:label];
        
        UIButton *selectBtn = [[UIButton alloc]init];
        selectBtn.frame = CGRectMake(self.width - 131, 20, 48, 23);
        [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        selectBtn.layer.borderColor = ColorLine.CGColor;
        selectBtn.layer.borderWidth = 0.5;
        selectBtn.layer.cornerRadius = 2.0;
        [selectBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectAllBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBtn];
        
        UIButton *unSelectBtn = [[UIButton alloc]init];
        unSelectBtn.frame = CGRectMake(self.width - 68, 20, 48, 23);
        [unSelectBtn setTitle:@"反选" forState:UIControlStateNormal];
        unSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        unSelectBtn.layer.borderColor = ColorLine.CGColor;
        unSelectBtn.layer.borderWidth = 0.5;
        unSelectBtn.layer.cornerRadius = 2.0;
        [unSelectBtn setTitleColor:ColorSecondTitle forState:UIControlStateNormal];
        [unSelectBtn addTarget:self action:@selector(unSelectBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unSelectBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+15, self.width - 30, 0.5)];
        line.backgroundColor = ColorLine;
        [self addSubview:line];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 100);
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), self.width, 280*SCREEN_SCALE) collectionViewLayout:flowLayout];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:_collectionView];
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), self.width, 280*SCREEN_SCALE)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [self addSubview:_tableview];
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_tableview.frame)+15, 105, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.backgroundColor = ColorRankMedal;
        cancelBtn.layer.cornerRadius = 4.0;
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(145, CGRectGetMaxY(_tableview.frame)+15, 105, 30)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        confirmBtn.backgroundColor = ColorRateTitle;
        confirmBtn.layer.cornerRadius = 4.0;
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
    }
    [self selectAllBtnAction];
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    if ([_selectedItems containsObject:_data[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *item = _data[indexPath.row];
    if ([_selectedItems containsObject:item]) {
        [_selectedItems removeObject:item];
    }else{
        [_selectedItems addObject:item];
    }
    [_tableview reloadData];
    
}

- (void)selectAllBtnAction{
    _selectedItems = [NSMutableArray arrayWithArray:_data];
    [_tableview reloadData];
}

-(void)unSelectBtnAction{
    [_data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *item = _data[idx];
        if ([_selectedItems containsObject:item]) {
            [_selectedItems removeObject:item];
        }else{
            [_selectedItems addObject:item];
        }
    }];
    [_tableview reloadData];
}

- (void)confirmAction{
    if (_confirmBlock) {
        NSMutableString *str = [NSMutableString string];
        [_selectedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [str appendString:obj];
            [str appendString:@","];
        }];
        _confirmBlock(str);
    }
}
- (void)cancelAction{
    if (_cancelBlock) {
        _cancelBlock();
    }
}


@end
