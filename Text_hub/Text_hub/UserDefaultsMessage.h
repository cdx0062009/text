//
//  UserDefaultsMessage.h
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  需要保存本地的简短信息
 */
@interface UserDefaultsMessage : NSObject

@property (nonatomic, strong) NSString *mineId;
@property (nonatomic, strong) NSString *mineName;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *position;
/**
 *  通知设备标识码
 */
@property (nonatomic, strong) NSString *deviceToken;

- (void)clearMineMessage;
@end
