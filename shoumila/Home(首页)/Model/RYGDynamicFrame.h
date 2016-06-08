//
//  RYGDynamicFrame.h
//  shoumila
//
//  Created by 贾磊 on 15/9/4.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGDynamicModel.h"
@interface RYGDynamicFrame : NSObject
@property(nonatomic,strong) RYGDynamicModel *dynamicModel;

@property(nonatomic,assign) BOOL isDetail;

@property (nonatomic, assign, readonly) CGRect avatarF;

@property (nonatomic, assign, readonly) CGRect nameF;

@property (nonatomic, assign, readonly) CGRect publish_timeF;

@property (nonatomic, assign, readonly) CGRect contentF;

@property (nonatomic, assign, readonly) CGRect photosViewF;

@property (nonatomic, assign, readonly) CGRect barViewF;

@property (nonatomic, assign, readonly) CGRect contentViewF;

@property (nonatomic, assign, readonly) CGRect recommendHeaderF;
@property (nonatomic, assign, readonly) CGRect recommendCollectionF;
@property (nonatomic, assign, readonly) CGRect bigArrowF;
@property (nonatomic, assign, readonly) CGRect publishTimeF;


//comment cell
@property (nonatomic, assign, readonly) CGRect avatar1F;
@property (nonatomic, assign, readonly) CGRect avatar2F;
@property (nonatomic, assign, readonly) CGRect avatar3F;

@property (nonatomic, assign, readonly) CGRect label1F;
@property (nonatomic, assign, readonly) CGRect label2F;
@property (nonatomic, assign, readonly) CGRect label3F;

@property (nonatomic, assign, readonly) CGRect line1F;
@property (nonatomic, assign, readonly) CGRect lineF;
@property (nonatomic, assign, readonly) CGRect line2F;

@property (nonatomic, assign, readonly) CGRect moreMsgBtnF;

@property (nonatomic, assign, readonly) CGRect commentViewF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;
@end
