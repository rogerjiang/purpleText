//
//  purpleBaseLayout.m
//  markDown
//
//  Created by rogerjiang on 6/3/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "purpleBaseLayout.h"

@implementation purpleLayoutModel

@end

@implementation purpleBaseLayout

-(instancetype)initWithDocument:(purpleDocument*)document
{
    if(self = [super init])
    {
        _purpleDocument = document;
        _imageSign = [[NSMutableDictionary alloc] init];
        _currentHeight = 0;
        _currentCTFrameBounds = CGRectZero;
    }
    
    return self;
}

-(void)purpleLayoutForStyle:(purpleLayoutModel*)model;
{
    _purpleDocument = model.document;
    [self purpleLayout:model.context Rect:model.rect];
}

-(void)purpleLayout:(CGContextRef)context Rect:(CGRect)rect;
{
    
}

@end
