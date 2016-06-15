//
//  purpleParse.m
//  markDown
//
//  Created by rogerjiang on 4/26/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "purpleParse.h"
#import "purpleScanner.h"

@implementation purpleParse
{
    purpleScanner *_scanner;
    purpleDocument  *_document;
    BOOL _resolveText;
    BOOL _contentBefore;
    purpleElement *contentElement;
}

- (purpleDocument *)parseMarkdown:(NSString *)markdown error:(__autoreleasing NSError **)error
{
    _document = [[purpleDocument alloc] initWithMarkDown:markdown];
    purpleScanner *scanner = [[purpleScanner alloc] initWithMarkDown:markdown];
    
    [self parseElements:scanner];
    
    return _document;
}

- (void)parseElements:(purpleScanner *)scanner
{
    _resolveText = NO;
    while (!scanner.atEndOfString)
    {
        //title
        [scanner beginTransaction];
        purpleElement *headElement = nil;
        headElement = [self parsePrefixHeaderWithScanner:scanner];
        
        if(headElement) {
            [scanner commitTransaction:YES];
            [_document addElement:headElement];
            _resolveText = YES;
            continue;
        }
        else {
            [scanner commitTransaction:NO];
        }
        
        //quote
        [scanner beginTransaction];
        purpleElement *quoteElement = nil;
        quoteElement = [self parseBlockquoteWithScanner:scanner];
        if(quoteElement) {
            [scanner commitTransaction:YES];
            [_document addElement:quoteElement];
            continue;
        }
        else {
            [scanner commitTransaction:NO];
        }
        
        //link
        [scanner beginTransaction];
        purpleElement *linkElement = nil;
        linkElement = [self parseLinkWithScanner:scanner];
        if(linkElement) {
            [scanner commitTransaction:YES];
            [_document addElement:linkElement];
            continue;
        }
        else {
            [scanner commitTransaction:NO];
        }
        
        //image
        [scanner beginTransaction];
        purpleElement *imageElement = nil;
        imageElement = [self parseImageWithScanner:scanner];
        if(imageElement) {
            [scanner commitTransaction:YES];
            [_document addElement:imageElement];
            continue;
        }
        else {
            [scanner commitTransaction:NO];
        }
        
        //list
        [scanner beginTransaction];
        purpleElement *listElement = nil;
        listElement = [self parseListWithScanner:scanner];
        if(listElement) {
            [scanner commitTransaction:YES];
            [_document addElement:listElement];
            continue;
        }
        else {
            [scanner commitTransaction:NO];
        }
        
        //content
        
        if(_contentBefore)
        {
            [self addContentText:scanner];
        }
        else
        {
            [self addContentText:scanner];
        }
        contentElement = [self parsePrefixContentWithScanner:scanner];
        if(contentElement) {
            [scanner commitTransaction:YES];
            [_document addElement:contentElement];
        }
        else {
            [scanner commitTransaction:NO];
        }
        
    }
    
    return;
}


//resolve header #
- (purpleElement *)parsePrefixHeaderWithScanner:(purpleScanner *)scanner
{
    NSUInteger level = 0;
    while (scanner.nextCharacter == '#' && level < 6)
    {
        level++;
        [scanner advance];
    }
    
    if (level == 0)
        return nil;
    
    [scanner skipCharactersFromSet:NSCharacterSet.whitespaceCharacterSet];
    
    NSRange headerRange = scanner.currentRange;
    
    // Remove trailing whitespace
    NSCharacterSet *whitespaceSet = NSCharacterSet.whitespaceCharacterSet;
    while (headerRange.length > 0)
    {
        unichar character = [scanner.markDownText characterAtIndex:NSMaxRange(headerRange)-1];
        if ([whitespaceSet characterIsMember:character])
            headerRange.length--;
        else
            break;
    }
    
    [scanner advanceToNextLine];
    
    purpleElement *element = [purpleElement new];
    element.type  = PurpleElementTypeHeader;
    element.range = NSMakeRange(scanner.startLocation, NSMaxRange(scanner.currentRange)-scanner.startLocation);
    element.level = level;
    element.innerRange = NSMakeRange(headerRange.location, headerRange.length);
//    [element.innerRanges addObject:];
    
    
    return element;
}


//block quote
- (purpleElement *)parseBlockquoteWithScanner:(purpleScanner *)scanner
{
    // Must have a >
    if (scanner.nextCharacter != '>')
        return nil;
    [scanner advance];
    
    // Can be followed by a space
    if (scanner.nextCharacter == ' ')
        [scanner advance];
    
    NSRange headerRange = scanner.currentRange;
    [scanner advanceToNextLine];
    
    purpleElement *element = [purpleElement new];
    element.range = NSMakeRange(scanner.startLocation, NSMaxRange(scanner.currentRange)-scanner.startLocation);
    element.type  = PurpleElementTypeBlockquote;
    element.innerRange = NSMakeRange(headerRange.location, headerRange.length);

    return element;
}


//Link
- (purpleElement *)parseLinkWithScanner:(purpleScanner *)scanner
{
    if(scanner.nextCharacter  != '[') return nil;
    [scanner advance];
    
    NSUInteger textLen = 0;
    while(scanner.nextCharacter != ']'  && !scanner.atEndOfLine) {
        textLen++;
        [scanner advance];
    }
    
    if(scanner.nextCharacter == ']') {
        [scanner advance];
    }
    else {
        return nil;
    }
    
    NSRange textRange = NSMakeRange(scanner.currentRange.location-textLen-1, textLen);
    
    if(scanner.nextCharacter != '(') {
        return nil;
    }
    
    [scanner advance];
    
    NSUInteger urlLen = 0;
    while(scanner.nextCharacter != ')' && !scanner.atEndOfLine)
    {
        urlLen++;
        [scanner advance];
    }
    
    NSRange urlRange = NSMakeRange(scanner.currentRange.location-urlLen-1, urlLen);
    [scanner advanceToNextLine];
    
    purpleElement *element = [purpleElement new];
    element.type  = PurpleElementTypeLink;
    element.range = NSMakeRange(scanner.startLocation, NSMaxRange(scanner.currentRange)-scanner.startLocation);;
    element.url  = [scanner.markDownText substringWithRange:urlRange];
    element.innerRange = textRange;
    
    return element;
}


//image
- (purpleElement *)parseImageWithScanner:(purpleScanner *)scanner
{
    if (scanner.nextCharacter != '!')
        return nil;
    [scanner advance];
    
    if(scanner.nextCharacter != '[') return nil;
    [scanner advance];
    
    NSUInteger textLen = 0;
    while(scanner.nextCharacter != ']'  && !scanner.atEndOfLine) {
        textLen++;
        [scanner advance];
    }
    
    if(scanner.nextCharacter == ']') {
        [scanner advance];
    }
    else {
        return nil;
    }
    
    NSRange textRange = NSMakeRange(scanner.currentRange.location-textLen-1, textLen);
    
    if(scanner.nextCharacter != '(') {
        return nil;
    }
    
    [scanner advance];
    
    NSUInteger urlLen = 0;
    while(scanner.nextCharacter != ')' && !scanner.atEndOfLine)
    {
        urlLen++;
        [scanner advance];
    }
    
//    if()
    
    NSRange urlRange = NSMakeRange(scanner.currentRange.location-urlLen, urlLen);
    [scanner advanceToNextLine];

    purpleElement *element = [purpleElement new];
    element.type  = PurpleElementTypeImage;
    element.range = NSMakeRange(scanner.startLocation, NSMaxRange(scanner.currentRange)-scanner.startLocation);
    element.url  = [scanner.markDownText substringWithRange:urlRange];
    element.innerRange = textRange;
    
    return element;
}

//list
- (purpleElement *)parseListWithScanner:(purpleScanner *)scanner
{
    if(scanner.nextCharacter != '*' && scanner.nextCharacter != '-' && scanner.nextCharacter != '+')
    {
        return nil;
    }
    
    purpleElement *element = [purpleElement new];
    element.type = PurpleElementTypeBulletedList;
    
    while (!scanner.atEndOfString)
    {
        [scanner beginTransaction];
        
        purpleElement *subElement = [self parseSubListWithScanner:scanner];
        if (!subElement)
        {
            [scanner commitTransaction:NO];
            break;
        }
        [scanner commitTransaction:YES];
        
        [element.subElement addObject:subElement];
    }
    
    element.range = NSMakeRange(scanner.startLocation, NSMaxRange(scanner.currentRange)-scanner.startLocation);
    
    return element;
}

//list subElement
- (purpleElement *)parseSubListWithScanner:(purpleScanner *)scanner
{
    if(scanner.nextCharacter != '*' && scanner.nextCharacter != '-' && scanner.nextCharacter != '+') {
        return nil;
    }
    
    [scanner advance];
    
    NSRange headerRange = scanner.currentRange;
    
    // Remove trailing whitespace
    NSCharacterSet *whitespaceSet = NSCharacterSet.whitespaceCharacterSet;
    while (headerRange.length > 0)
    {
        unichar character = [scanner.markDownText characterAtIndex:NSMaxRange(headerRange)-1];
        if ([whitespaceSet characterIsMember:character])
            headerRange.length--;
        else
            break;
    }
    
    [scanner advanceToNextLine];
    
    purpleElement *element = [purpleElement new];
    element.subType = PurpleSubElementTypeList;
    element.innerRange = headerRange;
    
    return element;
}

//resolve content

- (void)addContentText:(purpleScanner *)scanner
{
    
}

- (purpleElement *)parsePrefixContentWithScanner:(purpleScanner *)scanner
{
    NSUInteger level = 0;
    while (scanner.nextCharacter == '#' && level < 6)
    {
        level++;
        [scanner advance];
    }
    
    if (level == 0)
        return nil;
    
    [scanner skipCharactersFromSet:NSCharacterSet.whitespaceCharacterSet];
    
    NSRange headerRange = scanner.currentRange;
    
    // Remove trailing whitespace
    NSCharacterSet *whitespaceSet = NSCharacterSet.whitespaceCharacterSet;
    while (headerRange.length > 0)
    {
        unichar character = [scanner.markDownText characterAtIndex:NSMaxRange(headerRange)-1];
        if ([whitespaceSet characterIsMember:character])
            headerRange.length--;
        else
            break;
    }
    
    [scanner advanceToNextLine];
    
    purpleElement *element = [purpleElement new];
    element.type  = PurpleElementTypeHeader;
    element.range = NSMakeRange(scanner.startLocation, NSMaxRange(scanner.currentRange)-scanner.startLocation);
    element.level = level;
    element.innerRange = NSMakeRange(headerRange.location, headerRange.length);
    //    [element.innerRanges addObject:];
    
    
    return element;
}


@end
