//
//  PhotoPathManager.m
//  CodingDream
//
//  Created by rogerjiang on 12/9/15.
//  Copyright © 2015 rogerjiang. All rights reserved.
//

#import "PhotoPathManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PhotoPathManager


+ (instancetype)shareInstance
{
    static PhotoPathManager* pathManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pathManager = [[PhotoPathManager alloc] init];
    });
    
    return pathManager;
}

+ (NSString*)defaultCachePath
{
    static NSString* defaultCachePath = nil;
    
    if(defaultCachePath != nil) {
        return defaultCachePath;
    }
    
    NSArray* homePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* homePath = [homePaths objectAtIndex:0];
    NSString* cachePath = [homePath stringByAppendingPathComponent:@"/UrlPhoto"];
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    if(![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return cachePath;
    
}

- (instancetype)init
{
    if(self = [super init])
    {
        _cachePath = [PhotoPathManager defaultCachePath];
        
        _threadLock = [[NSRecursiveLock alloc] init];
    }
    
    return self;
}

- (NSString *)keyForURL:(NSString*)url {
    if (url == nil || url.length == 0) {
        return nil;
    }
    const char* str = [url UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (void)storeImage:(UIImage*)image forKey:(NSString*)key
{
    if(image == nil || key == nil) return;
    
    NSString* documentPath = [PhotoPathManager defaultCachePath];
    NSString* fileName = key;
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", documentPath, fileName];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [_threadLock lock];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
        if(![imageData writeToFile:filePath atomically:YES]) {
            
        }
    }
    [_threadLock unlock];
}

- (void)storeImage:(UIImage*)image forUrl:(NSString*)url
{
    if(image == nil || url == nil) return;
    
    NSString* key = [self keyForURL:url];
    
    NSString* documentPath = [PhotoPathManager defaultCachePath];
    NSString* fileName = key;
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", documentPath, fileName];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [_threadLock lock];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
        if(![imageData writeToFile:filePath atomically:YES]) {
            
        }
    }
    [_threadLock unlock];
}

@end
