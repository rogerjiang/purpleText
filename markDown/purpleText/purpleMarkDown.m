//
//  purpleMarkDown.m
//  markDown
//
//  Created by rogerjiang on 5/25/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "purpleMarkDown.h"

@implementation purpleMarkDown

- (instancetype)init
{
    if(self = [super init])
    {
        _marDownParse = [[purpleParse alloc] init];
    }
    return self;
}

- (purpleDocument *)parseMarkdown:(NSString *)markdown error:(__autoreleasing NSError **)error
{
    NSError *parseError = nil;
    purpleDocument  *document = [_marDownParse parseMarkdown:markdown error:&parseError];
    
    return document;
}

@end
