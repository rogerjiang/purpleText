//
//  PhotoPathManager.h
//  CodingDream
//
//  Created by rogerjiang on 12/9/15.
//  Copyright © 2015 rogerjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoPathManager : NSObject
{
    NSString* _cachePath;
    NSRecursiveLock* _threadLock;
}

+ (instancetype)shareInstance;
- (void)storeImage:(UIImage*)image forUrl:(NSString*)url;

@end
