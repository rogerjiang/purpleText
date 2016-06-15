//
//  purpleParse.h
//  markDown
//
//  Created by rogerjiang on 4/26/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "purpleElement.h"
#import "purpleDocument.h"
#

@interface purpleParse : NSObject

- (purpleDocument *)parseMarkdown:(NSString *)markdown error:(__autoreleasing NSError **)error;

@end
