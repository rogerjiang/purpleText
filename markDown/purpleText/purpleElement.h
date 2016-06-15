//
//  purpleElement.h
//  markDown
//
//  Created by rogerjiang on 4/25/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PurpleElementType) {
    PurpleElementTypeNone,
    PurpleElementTypeHeader,
    PurpleElementTypeParagraph,
    PurpleElementTypeBlockquote,
    PurpleElementTypeNumberedList,
    PurpleElementTypeBulletedList,
    PurpleElementTypeCodeBlock,
    PurpleElementTypeImage,
    PurpleElementTypeLink,
    PurpleElementTypeTable,
    PurpleElementTypeTableHeader,
    PurpleElementTypeTableHeaderCell,
    PurpleElementTypeTableRow,
    PurpleElementTypeTableRowCell,
};

typedef NS_ENUM(NSUInteger, PurpleSubElementType) {
    PurpleSubElementTypeNone,
    PurpleSubElementTypeList,
};

@interface purpleElement : NSObject

@property (assign, nonatomic) PurpleElementType  type;
@property (assign, nonatomic) PurpleSubElementType  subType;
@property (assign, nonatomic) NSUInteger      level;
@property (assign, nonatomic) NSRange         range;
@property (retain, nonatomic) NSMutableArray  *innerRanges;
@property (assign, nonatomic) NSRange         innerRange;
@property (retain, nonatomic) NSString        *url;
@property (retain, nonatomic) NSMutableArray  *subElement;


@end
