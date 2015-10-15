//
//  NSString+Replacing.h
//  Text_glod_request
//
//  Created by Mr.chen on 15/7/8.
//  Copyright (c) 2015年 bitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Replacing)
+ (NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr;
- (NSString *)encodeURL;
/**
 *  空时间处理
 *
 *  @return 处理结果
 */
- (NSString *)emptyData;
@end
