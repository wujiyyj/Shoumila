//
//  RYGFeedDetailCommentFrame.h
//  shoumila
//
//  Created by 贾磊 on 15/9/12.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYGCommentModel.h"
@interface RYGFeedDetailCommentFrame : NSObject

@property(nonatomic,strong)RYGCommentModel *commentModel;

@property(nonatomic,assign)BOOL isNeedFooter;

@property (nonatomic, assign, readonly) CGRect commentF;

@property (nonatomic, assign, readonly) CGRect timeF;

@property (nonatomic, assign, readonly) CGRect praiseF;

@property (nonatomic, assign, readonly) CGRect messageF;

@property (nonatomic, assign, readonly) CGRect threadTableViewF;

@property (nonatomic,strong) NSMutableArray *threadCellF;

@property (nonatomic,assign) CGFloat cellHeight;
@end
