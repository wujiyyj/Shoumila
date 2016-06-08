//
//  QDUploadImageHandler.h
//  qudouzhuanjia
//
//  Created by  on 15/6/9.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDUploadImageHandler : NSObject
@property (nonatomic,copy) void(^imageUploadComplate)(NSString *images);
-(void)uploadImage:(NSArray *)imageList;
+(NSArray *)compressImage:(NSArray *)imgArray prx:(CGFloat)prx;
@end
