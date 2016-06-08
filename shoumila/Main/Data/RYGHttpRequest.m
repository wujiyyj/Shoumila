//
//  RYGHttpRequest.m
//  shoumila
//
//  Created by 贾磊 on 15/7/23.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGHttpRequest.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@implementation RYGHttpRequest

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    [mgr POST:requestUrl parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              NSLog(@"responseObject = %@",responseObject);
              if (![RYGHttpRequest erroMsg:responseObject]) {
                  if (failure) {
                      failure(responseObject);
                      
//                      NSNumber *code = [responseObject valueForKey:@"code"];
//                      if (![code isEqual:@207]) {
//                          if (![RYGUtility validateUserLogin])
//                          {
//                              return ;
//                          }
//                      }
                      
                      
                  }
                  return ;
              }
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}


+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    [mgr GET:requestUrl parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             if (![RYGHttpRequest erroMsg:responseObject]) {
                 if (failure) {
                     
                     if (![RYGUtility validateUserLogin])
                     {
                         return;
                     }
                     
                     failure(nil);
                 }
                 return ;
             }
             success(responseObject);
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

//统一处理错误
+(BOOL)erroMsg:(id)responseObject{
    NSNumber *code = [responseObject valueForKey:@"code"];
    
    // 有些页面会有多次请求，所以回调用多次。所以还是自己处理自己的 登陆逻辑 .
    // 用 [RYGUtility validateUserLogin] 方法来判断
    
    if ([code  isEqual: @400]) {
        
        RYGUserInfoModel *userInfoModel = [RYGUtility getUserInfo];
        userInfoModel.token = @"";
        NSString *path = [DOC_PATH stringByAppendingPathComponent:@"userInfo.data"];
        [NSKeyedArchiver archiveRootObject:userInfoModel toFile:path];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNSNotification object:nil];
        return NO;
    }
    if (![code  isEqual: @0]&&![code isEqual:@502]) {
        [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
        return NO;
    }
       return YES;
}


@end
