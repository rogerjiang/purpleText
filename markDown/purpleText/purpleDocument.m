//
//  purpleDocument.m
//  markDown
//
//  Created by rogerjiang on 4/25/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "purpleDocument.h"

@implementation purpleDocument
{
//    NSMutableArray *_elements;
}

-(instancetype)initWithMarkDown:(NSString*)text
{
    if(self = [super init])
    {
        _elements = [[NSMutableArray alloc] init];
        _markDown = text;
    }
    
    return self;
}

- (void)addElement:(purpleElement *)anElement
{
    [self willChangeValueForKey:@"elements"];
    [_elements addObject:anElement];
    [self didChangeValueForKey:@"elements"];
}

- (void)insertElement:(purpleElement *)anElement index:(NSUInteger)index
{
    [_elements insertObject:anElement atIndex:index];
}

- (NSUInteger)elementCount
{
    return _elements.count;
}

@end
