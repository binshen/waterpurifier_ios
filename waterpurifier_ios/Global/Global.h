//
// Created by Bin Shen on 16/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

+ (Global *)global;

// 系统版本
+ (BOOL)isSystemLowIOS11;
+ (BOOL)isSystemLowIOS10;
+ (BOOL)isSystemLowIOS9;
+ (BOOL)isSystemLowIOS8;
+ (BOOL)isSystemLowIOS7;
+ (BOOL)isSystemLowiOS6;
+ (NSString *)clientVersion;


// 系统提示
+ (void)alertMessage:(NSString *)message;
+ (void)alertMessageEx:(NSString *)message
                 title:(NSString *)title
              okTtitle:(NSString *)okTitle
           cancelTitle:(NSString *)cancelTitle
              delegate:(id)delegate;



extern NSString * const MORAL_API_BASE_PATH;
extern NSMutableDictionary * _loginUser;
extern NSMutableDictionary * _selectedDevice;


@end