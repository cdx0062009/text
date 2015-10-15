//
//  NSString+Replacing.m
//  Text_glod_request
//
//  Created by Mr.chen on 15/7/8.
//  Copyright (c) 2015年 bitom. All rights reserved.
//

#import "NSString+Replacing.h"

@implementation NSString (Replacing)

+ (NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:dataStr];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSString *temp;
    NSCharacterSet*newLineAndWhitespaceCharacters = [ NSCharacterSet newlineCharacterSet];
    // 扫描
    while (![scanner isAtEnd])
    {
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // 替换换行符
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@"|"];
        }
    }
    return result;
}
- (NSString *)encodeURL
{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if (newString)
    {
        return newString;
    }
    return @"";
}
- (NSString *)emptyData
{
    if ([self isEqualToString:@"0001-01-01 00:00:00"])
    {
        return @"";
    }
    return self;
}
@end
