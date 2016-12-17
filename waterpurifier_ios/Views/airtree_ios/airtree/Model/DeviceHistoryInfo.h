//
//  DeviceHistoryInfo.h
//  airtree
//
//  Created by if on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceHistoryInfo : NSObject

@property(nonatomic, strong) NSString    *time;
@property(nonatomic, strong) NSString    *allNumbers;
@property(nonatomic, strong) NSString    *PM25;
@property(nonatomic, strong) NSString    *temperature;
@property(nonatomic, strong) NSString    *humidity; //湿度
@property(nonatomic, strong) NSString    *formaldehyde; //甲醛
@end
