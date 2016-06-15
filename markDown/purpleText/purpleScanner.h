//
//  purpleScanner.h
//  markDown
//
//  Created by rogerjiang on 4/26/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface purpleScanner : NSObject

@property (nonatomic, retain) NSArray  *lineRanges;
@property (nonatomic, assign) NSUInteger rangeIndex;
@property (assign, nonatomic) NSRange    currentRange;
@property (strong, nonatomic) NSString *markDownText;
@property (assign, nonatomic) NSUInteger startLocation;
@property (strong, nonatomic) NSMutableArray *transactions;

-(instancetype)initWithMarkDown:(NSString*)markDown;

- (BOOL)atBeginningOfLine;
- (BOOL)atEndOfLine;
- (BOOL)atEndOfString;
- (void)advance;

- (void)beginTransaction;
- (void)commitTransaction:(BOOL)shouldSave;

- (unichar)nextCharacter;
- (void)advanceToNextLine;
- (NSUInteger)skipCharactersFromSet:(NSCharacterSet *)aSet;

@end
