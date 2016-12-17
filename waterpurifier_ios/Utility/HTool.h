//
//  HTool.h
//  AiShangTaiCangTuan
//
//  Created by zxt on 16/5/25.
//  Copyright © 2016年 gloria. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDate+Util.h"
#import "ResultInfo.h"

typedef enum
{
    VALIDATEMOBILE, //手机号码
    VALIDATEPASSWORD, //密码
}ValidateItem;

//工具类
@interface HTool : NSObject

+(ResultInfo *)changeDicToRespondMessage:(NSMutableDictionary *)dic;

+(UIColor *)bgViewWhite;

//获取label的宽度
+(CGSize)caculateContentWidth:(NSString *)content contentFont:(UIFont *)font contentHeight:(float)height;

//获取label的高度
+(CGSize)caculateContentHeight:(NSString *)content contentFont:(UIFont *)font contentWidth:(float)width;

//判断对象是否为空
+(BOOL)isEmptyObject:(id)object;

//判断字符串是否为空
+(BOOL)isEmptyString:(NSString *)string;

//若字符串为空，则传@""
+(NSString *)convertString:(NSString *)string;

//将整型传字符串
+(NSString *)convertIntToString:(NSInteger)intValue;

//判断字典是否有某key
+(BOOL)judgeDicContainKey:(NSMutableDictionary *)dic withKey:(NSString *)key;

//将bool型转成服务器需要的string型
+(NSString *)convertBoolToString:(BOOL)boolValue;

//将sting型转成客户端需要的bool型
+(BOOL)convertStringToBool:(NSString *)stringValue;

//时间格式刷
+(NSString *)timeFormater:(NSString *)shortTime;

+(NSString *)timeFormater2:(NSString *)serverTime;

//显示年月日 时分时间
+(NSString *)showYMDHMFromServerTime:(NSString *)serverTime;

//显示年月日 时分秒时间
+(NSString *)showYMDHMSFromServerTime:(NSString *)serverTime;

//计算两个时间之间的差
+(long)caculateDifferBetweenTime:(NSString *)startTime andEndTime:(NSString *)endTime;

//获取当前时间戳
+(NSString *)getCurrentTimestamp;

//获取当前时间
+(NSString *)getCurrentTimeString;

//手机号码
+(NSString *)showMobileWithPartNumber:(NSString *)phone;

//根据url生成图片
+ (UIImage *) loadWebImageWithURL:(NSString *)url;

+ (UIImage *)scaleToSize:(UIImage *)img;

+(NSString *)changeFloat:(NSString *)stringFloat;

//显示年月日时间
+(NSString *)showYMDFromServerTime:(NSString *)serverTime;

//打电话出去
+(void)callOut:(NSString *)phoneNumber;

//图文详情拼接字符串
+(NSString *)stringBystring:(NSString *)bodyHTML;

+ (UIColor *) colorWithHexString: (NSString *)color;

@end

