//
//  RYGDataCache.m
//  文件缓存
//
//  Created by jiaocx on 15/9/14.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGDataCache.h"

@implementation RYGDataCache

+ (id)sharedInstance {
    static RYGDataCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[RYGDataCache alloc] init];
    });
    return cache;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            NSString *bundleCacheDirectory = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Cache.bundle"];
            NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            [self copyFileToSourceDirectory:bundleCacheDirectory destinationDirectory:cachesDirectory];
        });
    }
    
    return self;
}

- (void)copyFileToSourceDirectory:(NSString *)sourceDirectory destinationDirectory:(NSString *)destDirectory
{
    NSFileManager *localFileManager=[[NSFileManager alloc] init];

    
    for (NSString *subpath in [localFileManager subpathsAtPath:sourceDirectory])
    {
        NSString *destinationDirectory = [destDirectory stringByAppendingPathComponent:subpath];
        NSString *sourceCacheDirectory = [sourceDirectory stringByAppendingPathComponent:subpath];
        
        BOOL isDir;
        if ([localFileManager fileExistsAtPath:destinationDirectory isDirectory:&isDir])
        {
            if (isDir)
            {
                [self copyFileToSourceDirectory:sourceCacheDirectory destinationDirectory:destinationDirectory];
            }
        }
        else
        {
            [self copyItemAtPath:sourceCacheDirectory toPath:destinationDirectory];
        }
    }
}

- (void)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    
    NSError *error;
    [localFileManager copyItemAtPath:srcPath toPath:dstPath error:&error];
    if (error)
    {
        NSLog(@"copy item failed: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"copy item success: %@", dstPath);
    }
}

#pragma mark -
#pragma mark - File
- (NSString *)directoryWithFileName:(NSString *)fileName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    return path;
}

- (BOOL)writeData:(id)data toFile:(NSString *)fileName
{
    NSString *fullPath = [self directoryWithFileName:fileName];
    NSData *tmpData = [NSKeyedArchiver archivedDataWithRootObject:data];
    NSError *error = nil;
    BOOL flag = [tmpData writeToFile:fullPath options:NSDataWritingAtomic error:&error];
    NSAssert(flag, @"%s", __FUNCTION__);
    return flag;
}

- (id)dataInFile:(NSString *)fileName
{
    
    NSString *fullPath = [self directoryWithFileName:fileName];
    
    id data = nil;
    @try
    {
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    }
    @catch (NSException *exception)
    {
        if ([exception isKindOfClass:[NSInvalidArgumentException class]])
        {
            data = nil;
        }
    }
    @finally
    {
        
    }
    
    return data;
}

- (id)dataInPath:(NSString *)path {
    id data = nil;
    @try
    {
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    @catch (NSException *exception)
    {
        if ([exception isKindOfClass:[NSInvalidArgumentException class]])
        {
            data = nil;
        }
    }
    @finally
    {
        
    }
    
    return data;
}

@end
