//
//  purpleBlackRoseLayout.m
//  markDown
//
//  Created by rogerjiang on 6/3/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "purpleBlackRoseLayout.h"

#define CTFrameLeading 10
#define CTBlockLeadingDiff 12

@implementation purpleBlackRoseLayout


-(void)purpleLayout:(CGContextRef)context Rect:(CGRect)rect;
{
    [super purpleLayout:context Rect:rect];
    
    [[UIColor colorWithRed:253/255.0 green:255/255.0 blue:255/255.0 alpha:1] setFill];
    UIRectFill(rect);
    
    _currentHeight = rect.size.height;
    NSUInteger count = _purpleDocument.elements.count;
    for(NSUInteger index = 0; index < count; ++index)
    {
        _currentCTFrameBounds = CGRectZero;
        
        purpleElement *element = [_purpleDocument.elements objectAtIndex:index];
        
        if(element.type == PurpleElementTypeHeader)
        {
            NSString *headElement = [NSString stringWithFormat:@"%@\n", [_purpleDocument.markDown substringWithRange:element.innerRange]];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:headElement];
            
            NSInteger fontSize = 14 + element.level*2;
            
            NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName, [UIColor colorWithRed:46/255.0 green:46/255.0 blue:47/255.0 alpha:1.000] ,NSForegroundColorAttributeName, nil];
            
            [attributedString addAttributes:attributeDic range:NSMakeRange(0, [attributedString length])];
            
            CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
            
            CGSize constraints = CGSizeMake(rect.size.width, CGFLOAT_MAX);
            CFDictionaryRef attributeRef = (__bridge CFDictionaryRef)attributeDic;
            CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter,
                                                                              CFRangeMake(0, attributedString.length),
                                                                              attributeRef,
                                                                              constraints,
                                                                              nil);
            
            
            CGMutablePathRef path = CGPathCreateMutable();
            _currentCTFrameBounds = CGRectMake(0.0, _currentHeight-contentSize.height, rect.size.width, contentSize.height);
            CGPathAddRect(path, NULL, _currentCTFrameBounds);
            
            CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
            CTFrameDraw(ctFrame, context);
            
            CFRelease(ctFrame);
            CFRelease(path);
            CFRelease(ctFramesetter);
            
            _currentHeight -= (contentSize.height+CTFrameLeading);
        }
        else if(element.type == PurpleElementTypeBlockquote)
        {
            NSString *quoteElement = [NSString stringWithFormat:@"%@\n", [_purpleDocument.markDown substringWithRange:element.innerRange]];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:quoteElement];
            
            NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor colorWithRed:75/255.0 green:76/255.0 blue:77/255.0 alpha:1],NSForegroundColorAttributeName, [UIColor blueColor], NSBackgroundColorAttributeName, nil];
            
            [attributedString addAttributes:attributeDic range:NSMakeRange(0, [attributedString length])];
            
            CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
            
            CGSize constraints = CGSizeMake(rect.size.width, CGFLOAT_MAX);
            CFDictionaryRef attributeRef = (__bridge CFDictionaryRef)attributeDic;
            CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter,
                                                                              CFRangeMake(0, attributedString.length),
                                                                              attributeRef,
                                                                              constraints,
                                                                              nil);
            
            CGMutablePathRef path = CGPathCreateMutable();
            _currentCTFrameBounds = CGRectMake(5, _currentHeight-contentSize.height-CTBlockLeadingDiff, rect.size.width, contentSize.height);
            CGPathAddRect(path, NULL, _currentCTFrameBounds);
            
            CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
            
            
            //左边的矩形框
            CGRect leftRect = CGRectMake(0, _currentHeight-contentSize.height-2*CTBlockLeadingDiff, 5, contentSize.height+2*CTBlockLeadingDiff);
            CGContextSetLineWidth(context, 0.0f);
            CGContextStrokeRect(context, leftRect);
            UIColor *leftRectangleColor = [UIColor colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1.0];
            CGContextSetFillColorWithColor(context, leftRectangleColor.CGColor);
            CGContextFillRect(context, leftRect);
            
            //右边的矩形框
            CGRect rightRect = CGRectMake(5, _currentHeight-contentSize.height-2*CTBlockLeadingDiff, rect.size.width-5, contentSize.height+2*CTBlockLeadingDiff);
            CGContextSetLineWidth(context, 0.0f);
            CGContextStrokeRect(context, rightRect);
            UIColor *rightRectangleColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245.0/255.0 alpha:1.0];
            CGContextSetFillColorWithColor(context, rightRectangleColor.CGColor);
            CGContextFillRect(context, rightRect);
            
            CTFrameDraw(ctFrame, context);
            
            CFRelease(ctFrame);
            CFRelease(path);
            CFRelease(ctFramesetter);
            
            _currentHeight -= (contentSize.height+CTFrameLeading+2*CTBlockLeadingDiff);
            
        }
        else if(element.type == PurpleElementTypeLink)
        {
            NSString *linkElement = [NSString stringWithFormat:@"%@\n", [_purpleDocument.markDown substringWithRange:element.innerRange]];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:linkElement];
            
            NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor colorWithRed:0.000 green:(0xce/255.0) blue:(0xD1/255.0) alpha:1.000],NSForegroundColorAttributeName, [UIColor colorWithRed:0.000 green:1 blue:1.000 alpha:1.000], NSBackgroundColorAttributeName, nil];
            
            [attributedString addAttributes:attributeDic range:NSMakeRange(0, [attributedString length])];
            
            CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
            
            
            CGSize constraints = CGSizeMake(rect.size.width, CGFLOAT_MAX);
            CFDictionaryRef attributeRef = (__bridge CFDictionaryRef)attributeDic;
            CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter,
                                                                              CFRangeMake(0, attributedString.length),
                                                                              attributeRef,
                                                                              constraints,
                                                                              nil);
            
            
            CGMutablePathRef path = CGPathCreateMutable();
            _currentCTFrameBounds = CGRectMake(0.0, _currentHeight-contentSize.height, rect.size.width, contentSize.height);
            CGPathAddRect(path, NULL, _currentCTFrameBounds);
            
            CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
            CTFrameDraw(ctFrame, context);
            
            CFRelease(ctFrame);
            CFRelease(path);
            CFRelease(ctFramesetter);
            
            _currentHeight -= (contentSize.height+CTFrameLeading);
            
        }
        else if(element.type == PurpleElementTypeBulletedList)
        {
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
            
            NSUInteger count = element.subElement.count;
            for(NSUInteger index = 0; index < count; ++index)
            {
                purpleElement *subElement = [element.subElement objectAtIndex:index];
                
                NSString *subListString = [NSString stringWithFormat:@".%@\n", [_purpleDocument.markDown substringWithRange:subElement.innerRange]];
                
                NSMutableAttributedString *subAttributedString = [[NSMutableAttributedString alloc] initWithString:subListString];
                
                [attributedString insertAttributedString:subAttributedString atIndex:attributedString.length];
            }
            
            NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor colorWithRed:(0xee/255.0) green:(0x76/255.0) blue:(0x21/255.0) alpha:1.000],NSForegroundColorAttributeName, [UIColor colorWithRed:0.0 green:1 blue:1 alpha:1.000], NSBackgroundColorAttributeName, nil];
            
            [attributedString addAttributes:attributeDic range:NSMakeRange(0, [attributedString length])];
            
            CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
            
            CGSize constraints = CGSizeMake(rect.size.width, CGFLOAT_MAX);
            CFDictionaryRef attributeRef = (__bridge CFDictionaryRef)attributeDic;
            CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFramesetter,
                                                                              CFRangeMake(0, attributedString.length),
                                                                              attributeRef,
                                                                              constraints,
                                                                              nil);
            
            CGMutablePathRef path = CGPathCreateMutable();
            _currentCTFrameBounds = CGRectMake(0.0, _currentHeight-contentSize.height, rect.size.width, contentSize.height);
            CGPathAddRect(path, NULL, _currentCTFrameBounds);
            
            CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
            CTFrameDraw(ctFrame, context);
            
            CFRelease(ctFrame);
            CFRelease(path);
            CFRelease(ctFramesetter);
            
            _currentHeight -= (contentSize.height+CTFrameLeading);
        }
        else if(element.type == PurpleElementTypeImage)
        {
            //这里图片暂时比较独立，不需要混排。直接用画出来即可。但是markdown并不支持这个宽和高的指定，只能扩展一下。如果不指定，按默认的来.
            
            NSString *imageUrl = @"setting_New.png";
            UIImage *image = [UIImage imageNamed:imageUrl];
            
            CGRect imageRect = CGRectMake(0, _currentHeight-80, rect.size.width, 80);
            [_imageSign setObject:[NSValue valueWithCGRect:imageRect] forKey:imageUrl];
            CGContextDrawImage(context, imageRect, image.CGImage);
            
            _currentHeight -= (80+CTFrameLeading);
            
        }
        
    }
    
}

@end
