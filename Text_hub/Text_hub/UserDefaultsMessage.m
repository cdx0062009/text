//
//  UserDefaultsMessage.m
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import "UserDefaultsMessage.h"
#import "DESAlgorithm.h"

@implementation UserDefaultsMessage
- (void)setMineId:(NSString *)mineId
{
    if (![mineId isEqual:@""] && mineId)
    {
        NSDictionary * tokenDic = @{@"mineId":[NSString stringWithFormat:@"000PJB%@",mineId]};
        [self saveToUserDefault:tokenDic];
    }
}

- (NSString *)mineId
{
    return [[self loadUserDefault:@"mineId"] substringFromIndex:6];
}


- (void)setMineName:(NSString *)mineName
{
    if (![mineName isEqual:@""] && mineName)
    {
        NSDictionary * tokenDic = @{@"mineName":mineName};
        [self saveToUserDefault:tokenDic];
    }
}
- (NSString *)mineName
{
    return [self loadUserDefault:@"mineName"];
}


- (void)setDeviceToken:(NSString *)deviceToken
{
    if (![deviceToken isEqual:@""] && deviceToken)
    {
        NSDictionary * tokenDic = @{@"deviceToken":deviceToken};
        [self saveToUserDefault:tokenDic];
    }
}
- (NSString *)deviceToken
{
    return [self loadUserDefault:@"deviceToken"];
}

#pragma mark - 加密，解密，保存本地，取出本地
- (NSString *)encryption:(NSString *)original
{
    NSString * firstValidation = __BASE64(original);
    NSString * secondValidation = __BASE64([firstValidation stringByAppendingString:@"salt=$%^"]);
    return secondValidation;
}
- (NSString *)decryption:(NSString *)cipher
{
    NSString * secondValidation = __TEXT(cipher);
    NSString * firstValidation = __TEXT([secondValidation substringToIndex:secondValidation.length - 8]);
    return firstValidation;
}

- (void)saveToUserDefault:(NSDictionary *)dic
{
    NSString * key = [dic allKeys][0];
    NSString * dicValue = [dic valueForKey:key];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[self encryption:dicValue] forKey:[self encryption:key]];
}

- (NSString *)loadUserDefault:(NSString *)key
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:[self encryption:key]])
    {
        NSString * dicValue = [userDefault objectForKey:[self encryption:key]];
        NSString * decryptionStr = [self decryption:dicValue];
        return decryptionStr;
    }
    else
    {
        return @"";
    }
}

- (void)clearMineMessage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:[self encryption:@"mineId"]];
    [defaults removeObjectForKey:[self encryption:@"mineName"]];
    [defaults removeObjectForKey:[self encryption:@"deviceToken"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
