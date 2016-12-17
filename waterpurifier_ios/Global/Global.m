//
// Created by Bin Shen on 16/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//

#import "Global.h"

@implementation Global

NSString * const MORAL_API_BASE_PATH = @"api.7drlb.com";

NSMutableDictionary * _loginUser;
NSMutableDictionary * _selectedDevice;


+ (Global *)global
{
    static Global *s_global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_global = [[Global alloc] init];
    });

    return s_global;
}

+ (BOOL)isSystemLowIOS11
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat systemVer = [[device systemVersion] floatValue];
    if (systemVer - IOSBaseVersion11 < -0.001) {
        return YES;
    }

    return NO;
}

+ (BOOL)isSystemLowIOS10
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat systemVer = [[device systemVersion] floatValue];
    if (systemVer - IOSBaseVersion10 < -0.001) {
        return YES;
    }

    return NO;
}

+ (BOOL)isSystemLowIOS9
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat systemVer = [[device systemVersion] floatValue];
    if (systemVer - IOSBaseVersion9 < -0.001) {
        return YES;
    }

    return NO;
}

+ (BOOL)isSystemLowIOS8
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat systemVer = [[device systemVersion] floatValue];
    if (systemVer - IOSBaseVersion8 < -0.001) {
        return YES;
    }

    return NO;
}

+ (BOOL)isSystemLowIOS7
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat systemVer = [[device systemVersion] floatValue];
    if (systemVer - IOSBaseVersion7 < -0.001) {
        return YES;
    }

    return NO;
}

+ (BOOL)isSystemLowiOS6
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat systemVer = [[device systemVersion] floatValue];
    if (systemVer < IOSBaseVersion6) {
        return YES;
    }

    return NO;
}

+ (NSString *)clientVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}


#pragma mark - 系统提示

+ (void)alertMessage:(NSString *)message
{
    [Global alertMessageEx:message
                     title:nil
                  okTtitle:@"确定"
               cancelTitle:nil
                  delegate:nil];
}

+ (void)alertMessageEx:(NSString *)message
                 title:(NSString *)title
              okTtitle:(NSString *)okTitle
           cancelTitle:(NSString *)cancelTitle
              delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:title
                  message:message
                 delegate:delegate
        cancelButtonTitle:cancelTitle
        otherButtonTitles:okTitle,
                    nil];

    [alertView show];
}

@end