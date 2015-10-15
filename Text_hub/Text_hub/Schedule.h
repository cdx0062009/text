//
//  Schedule.h
//  Text_hub
//
//  Created by Mr.chen on 15/10/13.
//  Copyright © 2015年 Bitom. All rights reserved.
//

#import "JSONModel.h"
#import "Events.h"
@interface Schedule : JSONModel

@property (nonatomic, assign) NSInteger ScheduleID;

@property (nonatomic, strong) NSDate * StartDate;

@property (nonatomic, strong) NSArray<Optional,Events*> * EventList;
@end
