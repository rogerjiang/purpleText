//
//  UrlPhoto.m
//  CodingDream
//
//  Created by rogerjiang on 9/8/15.
//  Copyright (c) 2015 rogerjiang. All rights reserved.
//

#import "UrlPhoto.h"
#import "AFNetworking.h"
#import "PhotoPathManager.h"


@implementation UrlPhoto

#pragma mark - image
- (UIImage*)localImage
{
    if(_image != nil) {
        return _image;
    }
    
    UIImage* image = [self getStorageImage];
    
    return image;
}

- (UIImage*)getStorageImage
{
    if(_photoPath)
    {
        UIImage* image = [UIImage imageWithContentsOfFile:_photoPath];
        _image = image;
    }
    
    return _image;
}

- (void)setPhotoUrl:(NSString *)photoUrl
{
    if(!photoUrl) return;
    
    if(_photoUrl && [_photoUrl isEqualToString:photoUrl]) {
        return;
    }
    
    _photoUrl = photoUrl;
//    _photoPath = photoUrl ? [PhotoPathManager shareInstance]
}

- (void)downloadPhoto
{
//    NSString* imageUrl = @"http://img5.duitang.com/uploads/item/201510/11/20151011153554_vKSTB.png";
    if(!_photoUrl) return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    [manager GET:_photoUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage* responseImage = responseObject;
        if(responseImage) {
            NSString* requestUrl = [operation.request.URL absoluteString];
            if(requestUrl) {
                [[PhotoPathManager shareInstance] storeImage:responseImage forUrl:requestUrl];
            }
        }
        
        NSDictionary* responseInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"retCode", responseImage , @"response", nil];
        
        if(_delegate && [_delegate respondsToSelector:@selector(photoDownloadSuccess:)]) {
            [_delegate photoDownloadSuccess:responseInfo];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(_delegate && [_delegate respondsToSelector:@selector(photoDownloadSuccess:)]) {
            [_delegate photoDownloadFail:nil];
        }
        NSLog(@"Error: %@", error);
    }];
}



@end
