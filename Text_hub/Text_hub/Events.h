//
//  Events.h
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import "JSONModel.h"

@interface Events : JSONModel

/**
 *  项目ID
 */
@property (nonatomic, assign) NSInteger EventID;
/**
 *  项目名称
 */
@property (nonatomic, strong) NSString * EventName;
/**
 *  项目信息
 */
@property (nonatomic, strong) NSArray * EventInfo;

@end
