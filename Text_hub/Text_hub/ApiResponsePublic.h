//
//  ApiResponsePublic.h
//  XtuanMoive
//
//  Created by X团 on 14-11-17.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiResponseBase.h"
#import "BannerList.h"

@interface ApiResponsePublic : ApiResponseBase

//整合模型

/**
 *  生成广告条
 *
 *  @param requestData 请求到的数据
 *
 *  @return 广告条数组
 */
- (NSArray *)getBannerList:(NSData *)requestData;

@end
