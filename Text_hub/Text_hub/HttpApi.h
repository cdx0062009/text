//
//  HttpApi.h
//  XtuanMoive
//
//  Created by ppl on 14-11-4.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetWorkToast.h"

@protocol HttpApiDelegate

- (void)apiDidFinishLoading:(NSData *)data withTag:(NSObject *)tag;
- (void)apiDidFail:(NSError *)error withTag:(NSObject *)tag;

@end

@interface HttpApi : NSObject<NSURLConnectionDataDelegate>
{
    NSError *errors;
    UIAlertView * alert;
}
@property (nonatomic, weak) id<HttpApiDelegate> delegate;

@property (nonatomic, strong) NSObject *tag;
@property (nonatomic, assign) BOOL isHideIndicator;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NetWorkToast * toast;

@property (nonatomic, strong) NSTimer *timeoutTimer;

- (void)httpRequest:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout;
- (void)httpGet:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout;
- (void)httpPost:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout;
- (void)httpPostFile:(NSString *)url withParams:(NSDictionary *)params withFile:(NSDictionary *)files withTimeout:(NSTimeInterval)timeout;
- (void)httpRequestPost:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout;
- (void)httpPostData:(NSString *)url withParams:(NSDictionary *)params withData:(NSDictionary *)datas withTimeout:(NSTimeInterval)timeout;

/**
 *  金虎接口专用
 *
 *  @param url     url地址
 *  @param params  接入参数
 *  @param timeout 超时时间
 */
- (void)httpRequestPostJson:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout;
- (void)stop;

@end
