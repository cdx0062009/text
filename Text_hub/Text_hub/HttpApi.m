//
//  HttpApi.m
//  XtuanMoive
//
//  Created by ppl on 14-11-4.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import "HttpApi.h"
#import "JSONKit.h"


@implementation HttpApi

#pragma mark - NSURLConnectionDataDelegate

- (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}

- (void)httpRequest:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout
{
    [self httpPost:url withParams:params withTimeout:timeout];
}

- (void)httpGet:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout
{
    [self stop];
    if (!self.isHideIndicator)
    {
        self.toast = [[NetWorkToast alloc]init];
        [self.toast showWaittingIndicator];
    }
    
    NSMutableString *body = [NSMutableString string];
    
    if (params) {
        //参数的集合的所有key的集合
        NSArray *keys= [params allKeys];
        
        //添加其他参数
        for(int i=0;i<[keys count];i++) {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            
            if (body.length > 0) {
                [body appendString:@"&"];
            }
            
            [body appendFormat:@"%@=%@", key, [self encodeURL:[[params objectForKey:key] description]]];
        }
    }
    
    NSString *fullUrl = url;
    
    if (body.length > 0) {
        fullUrl = [NSString stringWithFormat:@"%@?%@", url, [body description]];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    if (timeout > 0) {
        [request setTimeoutInterval:timeout];
    }
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)httpPost:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout
{
    [self stop];
    
    NSMutableString *body = [NSMutableString string];
    
    if (params) {
        //参数的集合的所有key的集合
        NSArray *keys= [params allKeys];
        
        //添加其他参数
        for(int i=0;i<[keys count];i++) {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            
            if (body.length > 0) {
                [body appendString:@"&"];
            }
            
            [body appendFormat:@"%@=%@", key, [self encodeURL:[[params objectForKey:key] description]]];
        }
    }
    

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (timeout > 0) {
        self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(onTimeout:) userInfo:nil repeats:NO];
    }
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

/**
 * 上传文件
 * files:key-文件标识 value-文件路径
 */
- (void)httpPostFile:(NSString *)url withParams:(NSDictionary *)params withFile:(NSDictionary *)files withTimeout:(NSTimeInterval)timeout
{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    NSArray *keys = [files allKeys];
    for (int i = 0; i < [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *filePath = [files objectForKey:key];
        NSString *fileName = [filePath lastPathComponent];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [newDictionary setObject:[NSArray arrayWithObjects:fileName, data, nil] forKey:key];
    }
    [self httpPostData:url withParams:params withData:newDictionary withTimeout:timeout];
}

/**
 * 上传文件内容
 * datas:key-文件标识 value-array(0-文件名,1-文件内容)
 */
- (void)httpPostData:(NSString *)url withParams:(NSDictionary *)params withData:(NSDictionary *)datas withTimeout:(NSTimeInterval)timeout
{
    [self stop];
    
    NSString *hyphens = @"--";
    NSString *boundary = @"*****";
    NSString *end = @"\r\n";
    
    NSMutableData *myRequestData1=[NSMutableData data];
    
    if (datas) {
        //遍历数组，添加多张图片
        NSArray *dataKeys= [datas allKeys];
        for (int i = 0; i < [dataKeys count]; i ++) {
            NSString *key=[dataKeys objectAtIndex:i];
            NSArray *arr = [datas objectForKey:key];
            if (arr.count < 2) {
                continue;
            }
            
            NSString *fileName = [arr objectAtIndex:0];
            NSData *data = [arr objectAtIndex:1];
            
            //所有字段的拼接都不能缺少，要保证格式正确
            [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
            [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
            [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableString *fileTitle=[[NSMutableString alloc]init];
            //要上传的文件名和key，服务器端用file接收
            [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"", key, fileName];
            
            [fileTitle appendString:end];
            
            [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
            [fileTitle appendString:end];
            
            [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
            
            [myRequestData1 appendData:data];
            
            [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (params) {
        //参数的集合的所有key的集合
        NSArray *keys= [params allKeys];
        
        //添加其他参数
        for(int i=0;i<[keys count];i++) {
            
            NSMutableString *body=[[NSMutableString alloc]init];
            [body appendString:hyphens];
            [body appendString:boundary];
            [body appendString:end];
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //添加字段名称
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"", key];
            
            [body appendString:end];
            
            [body appendString:end];
            
            //添加字段的值
            [body appendFormat:@"%@", [params objectForKey:key]];

            [body appendString:end];
            
            [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                         timeoutInterval:20];
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    if (timeout > 0) {
        self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(onTimeout:) userInfo:nil repeats:NO];
    }

    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)httpRequestPostJson:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout
{
    [self stop];
    if (!self.isHideIndicator)
    {
        self.indicator = [[NProgressIndicator alloc]init];
        [self.indicator show];
    }
    
    NSString * bodyStr = [params JSONString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request addValue:@"Json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (timeout > 0) {
        self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(onTimeout:) userInfo:nil repeats:NO];
    }
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)httpRequestPost:(NSString *)url withParams:(NSDictionary *)params withTimeout:(NSTimeInterval)timeout
{
    [self stop];
    
    NSString * bodyStr = [params JSONString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request addValue:@"Json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (timeout > 0) {
        self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(onTimeout:) userInfo:nil repeats:NO];
    }
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
- (void)stop
{
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
}

- (void)onTimeout:(NSTimer *)timer
{
    [self.indicator close];
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    self.timeoutTimer = nil;
    
    if (self.delegate) {
        NSError *error = [[NSError alloc] initWithDomain:@"连接超时" code:-1 userInfo:nil];
        [self.delegate apiDidFail:error withTag:self.tag];
    }
    
    if (alert)
    {
        
    }
    else
    {
        alert = [[UIAlertView alloc]initWithTitle:@"网络请求失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.indicator close];
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
    
    self.connection = nil;
    
    if (self.delegate) {
        [self.delegate apiDidFinishLoading:self.receiveData withTag:self.tag];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.indicator close];
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
    
    self.connection = nil;
    errors = error;
    if (self.delegate)
    {
        [self.delegate apiDidFail:errors withTag:self.tag];
    }
    
    if (alert)
    {
        
    }
    else
    {
        alert = [[UIAlertView alloc]initWithTitle:@"" message:@"网络连接失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

@end
