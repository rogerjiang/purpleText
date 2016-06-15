//
//  purpleDocument.h
//  markDown
//
//  Created by rogerjiang on 4/25/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "purpleElement.h"

@interface purpleDocument : NSObject

@property(strong, nonatomic, readonly) NSString *markDown;
@property(copy,   nonatomic) NSMutableArray  *elements;

-(instancetype)initWithMarkDown:(NSString*)text;
- (void)addElement:(purpleElement *)anElement;

@end
