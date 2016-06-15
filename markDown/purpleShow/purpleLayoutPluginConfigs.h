//
//  purpleLayoutPluginConfigs.h
//  markDown
//
//  Created by rogerjiang on 6/3/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "purpleBaseLayout.h"

typedef NS_ENUM(NSInteger, purpleTextStyle) {

    purpleTextLayout_BlackRose = 0,
    purpleTextLayout_Count,
    
};

@interface purpleLayoutPluginConfigs : NSObject

+ (instancetype)shareInstance;
- (BOOL)purpleLayout:(purpleLayoutModel*)model style:(purpleTextStyle)style;

@end
