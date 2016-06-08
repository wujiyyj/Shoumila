//
//  QDCommentCollecitonCell.h
//  QDBestiPad
//
//  Created by lijianjie on 14-11-20.
//  Copyright (c) 2014年 QDbest. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kQDCommentCollecitonImgCellID @"QDCommentCollecitonImgCellID"
@interface RYGCommentCollecitonImgCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *deleteButton;
@property(nonatomic,strong) UIImageView *imageView;

-(void)setImage:(NSString *)image;
@end

#define kQDCommentCollecitonAddCellID @"QDCommentCollecitonAddCellID"
@interface RYGCommentCollecitonAddCell : UICollectionViewCell

@property (nonatomic, strong, ) UIButton *addButton;

@end

#define kQDCommentCollecitonFooterViewID @"QDCommentCollecitonFooterViewID"
@interface RYGCommentCollecitonFooterView : UICollectionReusableView

@property (nonatomic, strong) UILabel *textLabel;

@end