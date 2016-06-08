//
//  QDUploadImageHandler.m
//  qudouzhuanjia
//
//  Created by  on 15/6/9.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "QDUploadImageHandler.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"
#import "AFNetworking.h"
#import "RYGHttpRequest.h"
#import "RYGBaseParam.h"

#define kBgQueue dispatch_get_main_queue()

@implementation QDUploadImageHandler{
    NSString *imgBaseUrl;
    NSString *token;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        RYGBaseParam *param = [RYGBaseParam param];
        [RYGHttpRequest getWithURL:Upload_uptoken params:[param keyValues] success:^(id json) {
            NSDictionary *dic = [json objectForKey:@"data"];
            imgBaseUrl = [dic objectForKey:@"upurl"];
            token      = [dic objectForKey:@"uptoken"];
        } failure:^(NSError *error) {
            
        }];
    }
    return self;
}
-(void)uploadImage:(NSArray *)imageList{
    NSMutableString *imgs = [NSMutableString string];
    NSArray *newImageList = [QDUploadImageHandler compressImage:imageList prx:800];
    __block int flag = 0;
    if (newImageList.count >0) {
        [newImageList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImage *image = obj;
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            NSData *imageData = [image resizedAndReturnData];
            NSString *imageName = [self getImageName];
            [upManager putData:imageData key:imageName token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSString *imageUrl;
                          flag ++;
                          imageUrl = [NSString stringWithFormat:@"%@/%@,",imgBaseUrl,key];
                          [imgs appendString:imageUrl];
                          if (flag == newImageList.count) {
                              NSString *images = [imgs substringToIndex:imgs.length-1];
                              _imageUploadComplate(images);
                          }
                      } option:nil];
        }];
    }
}


- (NSString *)getImageName
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    NSString        *imageName;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    dateString = [formatter stringFromDate:[NSDate date]];
    int randomNum = arc4random() % 1000000000;
    imageName = [NSString stringWithFormat:@"img/%@/%d.png",dateString,randomNum];
    return imageName;
}
/**
 *  压缩图片
 *
 *  @param imgArray
 *  @param prx
 *
 *  @return
 */
+(NSArray *)compressImage:(NSArray *)imgArray prx:(CGFloat)prx{
    NSMutableArray *tmpArray=[[NSMutableArray alloc]init];
    if (imgArray && imgArray.count>0)
    {
        for (UIImage *imgItem in imgArray)
        {
            //设置image的尺寸
            CGSize imagesize = imgItem.size;
            CGFloat width = imagesize.width;
            CGFloat height = imagesize.height;
            if (imagesize.width >= imagesize.height) {
                if (imagesize.width > prx)
                {
                    width = prx;
                    height = imagesize.height * (prx / imagesize.width);
                }
            }
            else
            {
                if (imagesize.height > prx)
                {
                    height = prx;
                    width = imagesize.width * (prx / imagesize.height);
                }
            }
            imagesize.width = width;
            imagesize.height = height;
            //对图片大小进行压缩--
            UIImage *imageNew = [self imageWithImage:imgItem scaledToSize:imagesize];
            [tmpArray addObject:imageNew];
        }
    }
    return tmpArray;
    
}

//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
