//
//  EnumDefinition.h
//  B2CConsumers
//
//  Created by Mr.chen on 15/3/20.
//  Copyright (c) 2015年 pjb. All rights reserved.
//

#ifndef B2CConsumers_EnumDefinition_h
#define B2CConsumers_EnumDefinition_h

/**
 *  分类排序
 */
typedef NS_ENUM(NSInteger, NSortType){
    /**
     *  不排序
     */
    NSortNone = 0,
    /**
     *  按照优惠排序
     */
    NSortFavorable,
    /**
     *  按照距离排序
     */
    NSortDistance,
    /**
     *  按照热门
     */
    NSortVolume
};


#endif
