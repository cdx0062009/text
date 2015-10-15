//
//  ApiResponseBase.h
//  XtuanMoive
//
//  Created by ppl on 14-11-12.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiResponseBase : NSObject

@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id main;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, strong) NSDictionary * dataDic;
//根据返回值的格式生成
- (NSDictionary *)parse:(NSData *)data;

@end
