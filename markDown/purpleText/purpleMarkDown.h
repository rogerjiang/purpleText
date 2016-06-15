//
//  purpleMarkDown.h
//  markDown
//
//  Created by rogerjiang on 5/25/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "purpleParse.h"
#import "purpleScanner.h"

@interface purpleMarkDown : NSObject

@property(nonatomic, retain) purpleParse *marDownParse;

- (purpleDocument *)parseMarkdown:(NSString *)markdown error:(__autoreleasing NSError **)error;

@end
