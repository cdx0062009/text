//
//  ApiRequestBase.h
//  XtuanMoive
//
//  Created by ppl on 14-11-12.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpApi.h"

@interface ApiRequestBase : NSObject

@property (nonatomic, strong) NSObject *tag; //标志
@property (nonatomic, weak) id<HttpApiDelegate> delegate; //接收返回数据的代理
@property (nonatomic, assign) BOOL resend; //当前在请求过程中是否执行新请求
@property (nonatomic, assign) NSTimeInterval timeout; //超时时间
@property (nonatomic, strong) NSString *url; //url
@property (nonatomic, strong) NSDictionary *params; //参数
@property (nonatomic, strong) NSDictionary *files; //上传文件，key-文件标识 value-文件路径
@property (nonatomic, strong) NSDictionary *fileDatas; //上传文件数据，key-文件标识 value-array(0-文件名,1-文件内容)
@property (nonatomic, assign) BOOL isHideIndicator;
@property (nonatomic, strong) HttpApi *api;

/**
 *  根据具体的接口需求添加token验证
 */
- (void)validationToken;
//整合请求
- (void)sendRequest;

@end
