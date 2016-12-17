//
//  ResultInfo.h
//  AiShangTaiCangTuan
//
//  Created by zxt on 16/5/25.
//  Copyright © 2016年 gloria. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ResultInfo : NSObject

@property(nonatomic,strong) NSString *message;
@property(nonatomic,assign) int state;

@property(nonatomic,strong) id obj;

@end
