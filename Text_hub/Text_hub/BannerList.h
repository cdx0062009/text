//
//  BannerList.h
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import "JSONModel.h"

@interface BannerList : JSONModel

/**
 *  图片下载地址
 */
@property (nonatomic, strong) NSString<Optional> *imageUrl;
/**
 *  内容地址
 */
@property (nonatomic, strong) NSString<Optional> *contentUrl;
@end
