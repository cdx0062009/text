//
//  ApiResponseBase.m
//  XtuanMoive
//
//  Created by ppl on 14-11-12.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import "ApiResponseBase.h"
#import "JSONKit.h"

@implementation ApiResponseBase

- (id)init
{
    self = [super init];
    
    if (self) {
        self.status = -1;
        self.message = @"连接失败";
    }
    
    return self;
}

- (NSDictionary *)parse:(NSData *)data
{
    NSError *error = nil;
    NSString *lastStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSDictionary *dictionary = [lastStr objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
    
    if (error == nil && dictionary != nil) {
        self.status = [[dictionary objectForKey:@"Code"] intValue];
        self.main = [dictionary objectForKey:@"Result"];
        self.dataDic = dictionary;
    }
    
    return dictionary;
}

@end
