//
//  purpleBaseLayout.h
//  markDown
//
//  Created by rogerjiang on 6/3/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"
#import "purpleDocument.h"

@interface purpleLayoutModel : NSObject

@property(nonatomic, assign) CGContextRef context;
@property(nonatomic, assign) CGRect rect;
@property(nonatomic, retain) purpleDocument *document;

@end

@interface purpleBaseLayout : NSObject
{
    purpleDocument *_purpleDocument;
    CGFloat _currentHeight;
    CGRect _currentCTFrameBounds;
    NSMutableDictionary *_imageSign;
}

-(instancetype)initWithDocument:(purpleDocument*)document;
-(void)purpleLayoutForStyle:(purpleLayoutModel*)model;
-(void)purpleLayout:(CGContextRef)context Rect:(CGRect)rect;

@end
