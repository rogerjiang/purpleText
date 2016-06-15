//
//  purpleShowView.h
//  markDown
//
//  Created by rogerjiang on 5/16/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "purpleDocument.h"
#import "purpleLayoutPluginConfigs.h"

@interface purpleShowView : UIScrollView

- (instancetype)initWithDocument:(purpleDocument*)document style:(purpleTextStyle)style;

@end
