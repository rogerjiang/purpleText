//
//  UrlPhoto.h
//  CodingDream
//
//  Created by rogerjiang on 9/8/15.
//  Copyright (c) 2015 rogerjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol photoDownloadDelegate <NSObject>

- (void)photoDownloadSuccess:(NSDictionary*)info;
- (void)photoDownloadFail:(NSDictionary*)info;

@end

@interface UrlPhoto : NSObject
{
    UIImage* _image;
    NSString* _photoPath;
}

@property(nonatomic, retain) NSString* photoUrl;
@property(nonatomic, assign) id delegate;

- (UIImage*)localImage;
- (void)downloadPhoto;

@end
