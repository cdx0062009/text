//
//  ApiRequestRoot.h
//  XtuanMoive
//
//  Created by X团 on 14-11-13.
//  Copyright (c) 2014年 X团. All rights reserved.
//

#import "ApiRequestBase.h"
#import "EnumDefinition.h"

@interface ApiRequestRoot : ApiRequestBase

//所有的请求

/**
 *  广告位接口
 *
 *  @param delegate 绑定网络请求
 *  @param tag      标识
 */
- (void)postBannerList:(id<HttpApiDelegate>)delegate withTag:(NSObject *)tag;

@end



