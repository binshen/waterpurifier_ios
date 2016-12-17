//
//  StringUtil.h
//  airtree
//
//  Created by WindShan on 2016/11/14.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject


/*
 * 将字符串转换为字节
 */
+ (void)convertString:(NSString *)source toHexBytes:(unsigned char *)hexBuffer;

/*
 * 将当前时间转换为时间戳字符串：since 1970，如@"1369118167"
 */
+ (NSString *)intervalFromNowTime;

/*
 * 删除中文输入法下的空格
 */
+ (NSString *)deleteChinesSpace:(NSString *)sourceText;

/*
 * 转化为字符串类型
 */
+(NSString *)stringFromObject:(id)obj;
/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回false
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel;

//邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email;

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;

//车型验证
+ (BOOL) validateCarType:(NSString *)CarType;

//用户名验证
+ (BOOL) validateUserName:(NSString *)name;

//密码验证
+ (BOOL) validatePassword:(NSString *)passWord;

//昵称验证
+ (BOOL) validateNickname:(NSString *)nickname;

//身份证号验证
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

@end
