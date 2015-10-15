//
//  DESAlgorithm.h
//  notification
//
//  Created by Mr.chen on 14-9-5.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

/******字符串转base64（包括DES加密）******/
#define __BASE64( text )        [DESAlgorithm base64StringFromText:text]

/******base64（通过DES解密）转字符串******/
#define __TEXT( base64 )        [DESAlgorithm textFromBase64String:base64]

#define __MD5( text )           [DESAlgorithm getMd5_32Bit_String:text];
@interface DESAlgorithm : NSObject

/************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 **********************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 **********************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;

/**
 *  生成32位MD5加密
 *
 *  @param srcString 原内容
 *
 *  @return MD5加密后内容
 */
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
@end
