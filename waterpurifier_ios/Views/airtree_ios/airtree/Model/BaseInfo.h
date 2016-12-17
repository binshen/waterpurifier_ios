//
//  BaseInfo.h
//  airtree
//
//  Created by WindShan on 2016/11/14.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfo : NSObject


@property(nonatomic, strong) NSString    *ID;
@property(nonatomic, strong) NSString    *name;

+ (instancetype)infoFromDict:(NSDictionary *)dict;
+ (NSArray *)arrayFromDict:(NSDictionary *)dict;
+ (NSArray *)arrayFromArray:(NSArray *)array;


@end
