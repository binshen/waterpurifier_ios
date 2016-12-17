//
// Defines.h
// waterpurifier_ios
//
// Created by Bin Shen on 16/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//


#if (DEBUG || TESTCASE)
#define FxLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define FxLog(format, ...)
#endif

// 日志输出宏
#define BASE_LOG(cls,sel) FxLog(@"%@-%@",NSStringFromClass(cls), NSStringFromSelector(sel))
#define BASE_ERROR_LOG(cls,sel,error) FxLog(@"ERROR:%@-%@-%@",NSStringFromClass(cls), NSStringFromSelector(sel), error)
#define BASE_INFO_LOG(cls,sel,info) FxLog(@"INFO:%@-%@-%@",NSStringFromClass(cls), NSStringFromSelector(sel), info)

// 日志输出函数
#if (DEBUG || TESTCASE)
#define BASE_LOG_FUN()         BASE_LOG([self class], _cmd)
#define BASE_ERROR_FUN(error)  BASE_ERROR_LOG([self class],_cmd,error)
#define BASE_INFO_FUN(info)    BASE_INFO_LOG([self class],_cmd,info)
#else
#define BASE_LOG_FUN()
#define BASE_ERROR_FUN(error)
#define BASE_INFO_FUN(info)
#endif

// 设备类型判断
#define IsiPad     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsiPhone   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IsRetain   ([[UIScreen mainScreen] scale] >= 2.0)
#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define ScreenMaxLength (MAX(ScreenWidth, ScreenHeight))
#define ScreenMinLength (MIN(ScreenWidth, ScreenHeight))

#define IsiPhone4   (IsiPhone && ScreenMaxLength < 568.0)
#define IsiPhone5   (IsiPhone && ScreenMaxLength == 568.0)
#define IsiPhone6   (IsiPhone && ScreenMaxLength == 667.0)
#define IsiPhone6P  (IsiPhone && ScreenMaxLength == 736.0)

// iOS系统版本
#define IOSBaseVersion11     11.0
#define IOSBaseVersion10     10.0
#define IOSBaseVersion9     9.0
#define IOSBaseVersion8     8.0
#define IOSBaseVersion7     7.0
#define IOSBaseVersion6     6.0


// 过去当前APP版本号
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 消息通知
#define RegisterNotify(_name, _selector)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:nil];

#define RemoveNofify            \
[[NSNotificationCenter defaultCenter] removeObserver:self];

#define SendNotify(_name, _object)  \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object];

// 消息通知Key
#define NotifyDevideInfo      @"MonitorDevice"


// 设置颜色值
#define RgbColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define BGCOLOR [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define NAVIGATIONTINTCOLOR kUIColorFromRGB(0xe43286)
#define BLACKTEXTCOLOR_TITLE kUIColorFromRGB(0x303030)
#define BLACKTEXTCOLOR_SUB kUIColorFromRGB(0x7b7b7b)
#define BLUE_BUTTON_COLOR kUIColorFromRGB(0x18ADEB)


// 字体定义
#define FONT8 [UIFont systemFontOfSize:8.0]
#define FONT10 [UIFont systemFontOfSize:10.0]
#define FONT11 [UIFont systemFontOfSize:11.0]
#define FONT12 [UIFont systemFontOfSize:12.0]
#define FONT13 [UIFont systemFontOfSize:13.0]
#define FONT14 [UIFont systemFontOfSize:14.0]
#define FONT15 [UIFont systemFontOfSize:15.0]
#define FONT16 [UIFont systemFontOfSize:16.0]
#define FONT17 [UIFont systemFontOfSize:17.0]
#define FONT18 [UIFont systemFontOfSize:18.0]

// 其他常量
#define NavBarHeight        44
#define NavBarHeight7       64

#define UserDefault [NSUserDefaults standardUserDefaults]
#define Application [UIApplication sharedApplication]
#define GetAppDelegate [AppDelegate AppInstance]

//是否启动 libsmartlinklib_7x.a
//#define USE_SmartLink     101

/*网络相关
 {result:ok, data:data}
 {result:error,message:""}
 {result:invalidatetoken, message:"token失效"}
 */
#define NetOk               @"ok"
#define NetData             @"data"
#define HTTPGET             @"GET"
#define HTTPPOST            @"POST"


// 提示信息
#define LoginingTip         @"登录中..."
#define LoadingTip          @"加载中..."
#define LoginCheckTip       @"用户名或密码不能为空"
