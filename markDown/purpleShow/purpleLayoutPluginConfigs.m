//
//  purpleLayoutPluginConfigs.m
//  markDown
//
//  Created by rogerjiang on 6/3/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "purpleLayoutPluginConfigs.h"
#import "purpleBlackRoseLayout.h"

@implementation purpleLayoutPluginConfigs
{
    NSMutableArray *_layoutConfigs;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static purpleLayoutPluginConfigs *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[purpleLayoutPluginConfigs alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    if(self = [super init])
    {
        _layoutConfigs = [[NSMutableArray alloc] initWithObjects:
                          @{
                            @"class":[[purpleBlackRoseLayout alloc] init],
                            @"desc" : @"black and white, normal layout",
                            },
                          nil];
    }
    return self;
}

- (BOOL)purpleLayout:(purpleLayoutModel*)model style:(purpleTextStyle)style;
{
    if(style>= purpleTextLayout_Count) return false;
    
    NSDictionary *purplePlugin = [_layoutConfigs objectAtIndex:style];
    
    if(purplePlugin && [purplePlugin isKindOfClass:[NSDictionary class]])
    {
        purpleBaseLayout *layout = [purplePlugin objectForKey:@"class"];
    
        [layout purpleLayoutForStyle:model];
    
        return true;
    }
    
    return false;
}


@end
