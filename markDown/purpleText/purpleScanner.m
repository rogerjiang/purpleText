//
//  purpleScanner.m
//  markDown
//
//  Created by rogerjiang on 4/26/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "purpleScanner.h"

@implementation purpleScanner
{
}

-(instancetype)initWithMarkDown:(NSString*)markDown
{
    if(self = [super init])
    {
        _markDownText = markDown;
        _rangeIndex =  0;
        
        self.lineRanges = [self lineRangesForString:_markDownText];
        self.transactions = [NSMutableArray array];
        self.currentRange = [self.lineRanges[self.rangeIndex] rangeValue];
    }
    
    return self;
}

- (NSArray *)lineRangesForString:(NSString *)aString
{
    NSMutableArray *result = [NSMutableArray array];
    
    NSUInteger location = 0;
    NSUInteger idx;
    for (idx = 0; idx < aString.length; idx++)
    {
        unichar character = [aString characterAtIndex:idx];
        if (character == '\r' || character == '\n')
        {
            NSRange range = NSMakeRange(location, idx-location);
            [result addObject:[NSValue valueWithRange:range]];
            
            // If it's a carriage return, check for a line feed too
            if (character == '\r')
            {
                if (idx + 1 < aString.length && [aString characterAtIndex:idx + 1] == '\n')
                {
                    idx += 1;
                }
            }
            
            location = idx + 1;
        }
    }
    
    // Add the final line if the string doesn't end with a newline
    if (location < aString.length)
    {
        NSRange range = NSMakeRange(location, aString.length-location);
        [result addObject:[NSValue valueWithRange:range]];
    }
    
    return result;
}

- (BOOL)atEndOfString
{
    return self.atEndOfLine && self.rangeIndex == self.lineRanges.count - 1;
}

- (BOOL)atBeginningOfLine
{
    return self.location == self.currentLineRange.location;
}

- (BOOL)atEndOfLine
{
    return self.location == NSMaxRange(self.currentLineRange);
}

- (void)advance
{
    if (self.atEndOfLine)
        return;
    
    NSUInteger location = self.currentRange.location+1;
    self.currentRange = NSMakeRange(location, NSMaxRange(self.currentLineRange)-location);
}

- (void)advanceToNextLine
{
    //if this is the end character
    if (self.rangeIndex == self.lineRanges.count - 1)
    {
        self.currentRange = NSMakeRange(NSMaxRange(self.currentLineRange), 0);
    }
    // Otherwise actually go to the next line
    else
    {
        self.rangeIndex += 1;
        self.currentRange = self.currentLineRange;
    }
}

- (unichar)nextCharacter
{
    if (self.atEndOfLine)
        return '\n';
    return [self.markDownText characterAtIndex:self.location];
}

- (NSUInteger)location
{
    return self.currentRange.location;
}

- (NSRange)currentLineRange
{
    return [self.lineRanges[self.rangeIndex] rangeValue];
}

//- (unichar)nextCharacter
//{
//    if (self.atEndOfLine)
//        return '\n';
//    return [self.string characterAtIndex:self.location];
//}

- (NSUInteger)skipCharactersFromSet:(NSCharacterSet *)aSet
{
    NSRange searchRange = self.currentRange;
    NSRange range = [self.markDownText rangeOfCharacterFromSet:[aSet invertedSet]
                                                       options:0
                                                         range:searchRange];
    
    NSUInteger current = self.location;
    
    if (range.location == NSNotFound)
    {
        self.currentRange = NSMakeRange(NSMaxRange(self.currentRange), 0);
    }
    else
    {
        self.currentRange = NSMakeRange(range.location, NSMaxRange(self.currentRange)-range.location);
    }
    
    return self.location - current;
}

- (void)beginTransaction
{
    BOOL endOfString = NO;
    if(self.atEndOfString) {
        endOfString = YES;
    }
    
    NSDictionary *transaction = @{
                                  @"rangeIndex":      @(self.rangeIndex),
                                  //                                  @"location":        @(self.location),
                                  @"startLocation":   @(self.startLocation),
                                  @"endOfString":     @(true),
                                  };
    [self.transactions addObject:transaction];
    self.startLocation = self.location;
}

- (void)commitTransaction:(BOOL)shouldSave
{
    if (!self.transactions.count)
        [NSException raise:@"Transaction underflow" format:@"Could not commit transaction because the stack is empty"];
    
    NSDictionary *transaction = [self.transactions lastObject];
    [self.transactions removeLastObject];
    
    self.startLocation = [[transaction objectForKey:@"startLocation"] unsignedIntegerValue];
    if (!shouldSave)
    {
        BOOL endOfString = [[transaction objectForKey:@"endOfString"] boolValue];
        
        if(!endOfString)
        {
            self.rangeIndex    = [[transaction objectForKey:@"rangeIndex"]    unsignedIntegerValue];
            self.currentRange  = self.currentLineRange;
        }
    }
}

@end
